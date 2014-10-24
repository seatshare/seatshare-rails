# Configure the SODA XML Team gem
# These are required getting data from SODA
if ENV['SODA_USERNAME'].nil? || ENV['SODA_PASSWORD'].nil? || ENV['SODA_ENVIRONMENT'].nil?
  Rails.logger.warn "SODA configuration is not present!"
end
