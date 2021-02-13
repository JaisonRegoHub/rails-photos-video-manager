class CreateFileAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :file_attachments do |t|
      t.string :uploader_name
      t.string :title
      t.string :file_type
      t.string :category
      t.timestamps
    end
  end
end
