class AddStoreDirToFormbuilderEntryAttachments < ActiveRecord::Migration
  def change
    add_column :formbuilder_entry_attachments, :store_dir, :string
  end
end
