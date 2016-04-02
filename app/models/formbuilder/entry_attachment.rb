module Formbuilder
  class EntryAttachment < ActiveRecord::Base
    # Returns remote upload url with carrierwave backwards compatibility
    # Takes version as argument (default is 'original') like 'thumb'.
    def remote_upload_url(version='original')
      directory = raw_store_dir
      file = upload
      if stored_via_carrier_wave?
        prefix = (version == 'original') ? '' : "#{version}_"
        file = "#{prefix}#{file}"
      else
        directory = directory.sub('originals', version.pluralize)
      end
      object_key = URI.decode(File.join(directory, file))
      AWS_BUCKET.object(object_key).presigned_url(:get)
    end

    # Comes from the outside since it gets created in JS S3 Post
    def remote_upload_url=(remote_upload_url)
      if remote_upload_url.present?
        remote_upload_path = URI(URI.encode(remote_upload_url)).path
        path_file_match = remote_upload_path.match(/^(\/([^\/]+\/)+)([^\/]+)$/)
        self.store_dir = path_file_match[1]
        self.upload = path_file_match[3]
      end
    end

    def store_dir
      attributes['store_dir'] || "/#{carrierwave_store_dir}/"
    end

    def raw_store_dir
      store_dir.sub(/^\//, '').sub(/\/$/, '')
    end

    def stored_via_carrier_wave?
      attributes['store_dir'].blank?
    end

    # Used for backward compatibility with older records not having store_dir
    def carrierwave_store_dir
      Digest::SHA2.hexdigest("#{self.class.to_s.underscore}-upload-#{self.id.to_s}").first(32)
    end

  end
end
