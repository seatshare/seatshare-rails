require 'test_helper'

##
# Ticket File test
class TicketFileTest < ActiveSupport::TestCase
  test 'ticket file upload' do
    uploaded_file = Rack::Test::UploadedFile.new(
      './test/fixtures/ticket_files/000000-00000.pdf',
      'application/pdf'
    )
    ticket_file = TicketFile.create_from_attrs(
      user_id: 2,
      ticket_id: 2,
      ticket_file: uploaded_file
    )

    assert_equal '000000-00000.pdf', ticket_file.file_name
    refute_nil ticket_file.path
  end

  test 'delete' do
    ticket_file = TicketFile.find(1)
    ticket_file.destroy!

    assert ticket_file.destroyed?
  end

  test 'download link' do
    tf = TicketFile.find(1)

    assert_match(
      "#{ENV['SEATSHARE_S3_PUBLIC']}/abcdefg1234.pdf?X-Amz-Algorithm=",
      tf.download_link
    )
  end
end
