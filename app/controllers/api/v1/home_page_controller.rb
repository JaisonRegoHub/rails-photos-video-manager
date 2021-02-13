module Api
	module V1

		class HomePageController < ApplicationController
			# before_action :get_current_user
			skip_before_action :verify_authenticity_token

			# For search bar at top retieve either image or video to user
			def retrive_selected_content
				file_attachments_hash = get_file_attachments_hash
				render :json => {file_attachments: file_attachments_hash}, status: 200
			end

			# For fetching either images or videos to user 
			def get_images_or_videos
				file_type = params["file_type"]
				if file_type.present?
					if file_type == "image" || file_type == "video"
						file_attachments_hash = get_file_attachments_hash(file_type)
						render :json => {file_attachments: file_attachments_hash}, status: 200
					else
						render :json => {error: "Invalid file type specfied"}, status: 400
					end
				else
					render :json => {error: "No file type specfied"}, status: 400
				end
			end

			# For fetching either image or video details to user 
			def get_image_or_video_detail
				file_attachment_id = params["file_attachment_id"]
				if file_attachment_id.present?
					file_attachments_hash = FileAttachment.search "*", where: {id: file_attachment_id}, load: false
					render :json => {file_attachments: file_attachments_hash}, status: 200
				else
					render :json => {error: "No file file attachment id specfied"}, status: 400
				end
			end

			# For fetching all images and videos which are user_favourite 
			def get_user_favourites
				user = User.where(id: params["user_id"])
				if user.blank?
					render :json => {error: "user id not valid"}, status: 400
				else
					favourites = Favourite.where(user_id: user.last.id)
					if favourites.present?
						file_attachment_ids = favourites.pluck(:file_attachment_id) 
						file_attachments_hash = get_file_attachments_hash(nil, file_attachment_ids)
						render :json => {file_attachments: file_attachments_hash}, status: 200
					else
						render :json => {message: "User has no selected favourites"}, status: 200
					end
				end
			end

			# For setting either image or a video as user_favourite 
			def set_or_remove_user_favourite
				user = User.where(id: params["user_id"])
				file_attachment = FileAttachment.where(id: params["file_attachment_id"])
				if user.blank?
					render :json => {error: "user id not valid"}, status: 400
				elsif file_attachment.blank?
					render :json => {error: "file attachment id not valid"}, status: 400
				else
					favourite = Favourite.where(user_id: user.last.id, file_attachment_id: file_attachment.last.id)
					if favourite.blank?
						Favourite.create(user_id: user.last.id, file_attachment_id: file_attachment.last.id)
						render :json => {message: "Favourite added for user"}, status: 200
					else
						favourite.last.destroy
						render :json => {message: "Favourite removed for user"}, status: 200
					end
				end
			end

			# For uploading either a image or video to server 
			def upload_file
				if params["file"].present?
					file_type = params["file"].content_type.starts_with?("image") ? "image" : "video"
					uploader_name = params["uploader_name"]
					title = params["title"]
					category = params["category"].blank? ? "unknown" : params["category"]
					file_attachment = FileAttachment.new(uploader_name: uploader_name, title: title,
						 file_type: file_type, category: category, file: params["file"])
					if file_attachment.save(validate: false)
						render :json => {message: "File Uploaded Succesfully"}, status: 200
					else
						render :json => {error: "Error while saving file"}, status: 400
					end
				else
					render :json => {error: "No file Uploaded"}, status: 400
				end
			end

			# For fetching trending image
			def get_trending_image
				file_attachment_ids = FileAttachment.where(file_type: "image").pluck(:id)
				file_attachment_id = file_attachment_ids[rand(file_attachment_ids.count)]
				file_attachments_hash = FileAttachment.search "*", where: {id: file_attachment_id}, load: false
				render :json => {file_attachments: file_attachments_hash}, status: 200
			end

			private
			def get_file_attachments_hash(file_type = nil, file_attachment_ids = nil)
				filter_query = {}
				filter_query = {file_type: file_type} if !file_type.nil?
				filter_query = {id: file_attachment_ids} if !file_attachment_ids.nil?
				search_key = params["search_key"].blank? ? "*" : params["search_key"]
				offset = params["offset"].blank? ? 0 : params["offset"].to_i
				limit = params["limit"].blank? ? 20 : params["limit"].to_i 
				response = FileAttachment.search search_key, where: filter_query,
						offset: offset, limit: limit, load: false, match: :word_middle
			end

			# def get_current_user
			# 	@current_user = params[:user_id]
			# end

			def permit_params
				params.require(:file_attachment).permit(:file_type, :file)
			end
		end
		
	end
end