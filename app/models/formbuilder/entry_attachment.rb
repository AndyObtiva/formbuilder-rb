module Formbuilder
  class EntryAttachment < ActiveRecord::Base
    def remote_upload_url
      AWS_BUCKET.object(File.join(raw_store_dir, upload)).presigned_url(:get)
    end

    # Comes from the outside since it gets created in JS S3 Post
    def remote_upload_url=(remote_upload_url)
      if remote_upload_url.present?
        remote_upload_path = URI(URI.escape(remote_upload_url)).path
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

    # Used for backward compatibility with older records not having store_dir
    def carrierwave_store_dir
      Digest::SHA2.hexdigest("#{self.class.to_s.underscore}-upload-#{self.id.to_s}").first(32)
    end

  end
end
