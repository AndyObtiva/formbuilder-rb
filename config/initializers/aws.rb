Aws.config[:credentials] = Aws::Credentials.new(Rails.application.secrets.ec2_access_key, Rails.application.secrets.ec2_access_secret)
AWS_BUCKET = Aws::S3::Resource.new(region: Rails.application.secrets.formbuilder_region).bucket(Rails.application.secrets.formbuilder_bucket)
