Rails.application.routes.draw do
  resources :videos
  devise_for :users, :controllers => {:registrations => "registrations"}

  namespace :api, defaults: {} do
    namespace :v1 do
      controller :home_page do
        match '/retrive_selected_content', to: 'home_page#retrive_selected_content', via: [:get, :options]
        match '/get_images_or_videos', to: 'home_page#get_images_or_videos', via: [:get, :options]
        match '/get_image_or_video_detail', to: 'home_page#get_image_or_video_detail', via: [:get, :options]
        match '/get_user_favourites', to: 'home_page#get_user_favourites', via: [:get, :options]
        match '/upload_file', to: 'home_page#upload_file', via: [:post, :options]
        match '/set_or_remove_user_favourite', to: 'home_page#set_or_remove_user_favourite', via: [:post, :options]
        match '/get_trending_image', to: 'home_page#get_trending_image', via: [:get, :options]        
      end
    end
  end 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
