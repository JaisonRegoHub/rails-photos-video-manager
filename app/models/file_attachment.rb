class FileAttachment < ApplicationRecord
	has_one_attached :file
	belongs_to :user
	has_many :favourites

	searchkick word_middle: [:file_type, :category]

	def search_data
		{
			file_attachment_id: id,
			uploader_name: uploader_name,
			title: title,
			file_type: file_type,
			category: category,
			file_path: ActiveStorage::Blob.service.send(:path_for, get_path_key),
			created_at: created_at,
			updated_at: updated_at
		}
	end

	private

	def get_path_key
		file.try(:key).nil? ? "" : file.try(:key)
	end
end
