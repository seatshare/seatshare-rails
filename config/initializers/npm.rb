# Run npm install
system 'npm install' if Rails.env.development? || Rails.env.test?
