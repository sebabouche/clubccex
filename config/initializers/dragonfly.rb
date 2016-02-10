require 'dragonfly/s3_data_store'

Dragonfly.app.configure do
  plugin :imagemagick

  datastore :s3,
    bucket_name:        ENV['S3_BUCKET'],
    access_key_id:      ENV['AWS_PUBLIC'],
    secret_access_key:  ENV['AWS_SECRET'],
    region:             ENV['S3_REGION']
  
  # datastore :file, :server_root => 'public', :root_path => 'public/images'
end
