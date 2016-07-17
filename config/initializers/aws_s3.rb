# Configure the S3 Gem
# These are required for ticket file uploading.
if ENV['SEATSHARE_S3_BUCKET'].nil? || ENV['SEATSHARE_S3_BUCKET'].nil? || ENV['SEATSHARE_S3_BUCKET'].nil? || ENV['SEATSHARE_S3_PUBLIC'].nil?
  Rails.logger.warn "S3 configuration is not present!"
end

## SDK v2
Aws.config.update({
  region: 'us-east-1',
  credentials: Aws::Credentials.new(ENV['SEATSHARE_S3_KEY'], ENV['SEATSHARE_S3_SECRET'])
})
