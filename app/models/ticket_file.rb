##
# Ticket file model
class TicketFile < ActiveRecord::Base
  belongs_to :ticket

  validates :user_id, :ticket_id, :path, :file_name, presence: true
  before_destroy :delete_s3_file

  attr_accessor :ticket_file

  ##
  # Create from Attrs
  def self.create_from_attrs(attrs = nil)
    file = TicketFile.upload_s3_file(attrs[:ticket_file], attrs)
    create(
      user_id: attrs[:user_id],
      ticket_id: attrs[:ticket_id],
      path: file[:path],
      file_name: file[:file_name]
    )
  end

  ##
  # Format path as a download link
  def download_link
    "#{ENV['SEATSHARE_S3_PUBLIC']}/#{path}"
  end

  ##
  # Upload S3 file
  def self.upload_s3_file(uploaded_file, attrs)
    File.open(
      Rails.root.join('tmp', 'uploads', uploaded_file.original_filename), 'wb'
    ) do |file|
      file.write(uploaded_file.read)
    end
    raise 'TicketFileNotSaved' unless File.exist?(
      Rails.root.join('tmp', 'uploads', uploaded_file.original_filename)
    )
    path = Rails.root.join('tmp', 'uploads', uploaded_file.original_filename)
    hex = SecureRandom.hex
    ticket_id = attrs[:ticket_id].to_i
    file_s3_key = "#{ticket_id}-#{hex}/#{uploaded_file.original_filename}"
    s3 = Aws::S3::Resource.new(region: ENV['SEATSHARE_S3_REGION'])
    obj = s3.bucket(ENV['SEATSHARE_S3_BUCKET']).object(file_s3_key)
    File.open(path, 'rb') do |file|
      obj.put(body: file, storage_class: 'REDUCED_REDUNDANCY')
    end
    {
      path: file_s3_key,
      file_name: uploaded_file.original_filename
    }
  end

  private

  ##
  # Delete S3 file
  def delete_s3_file
    s3 = Aws::S3::Resource.new
    s3.bucket(ENV['SEATSHARE_S3_BUCKET']).object(path).delete
  end
end
