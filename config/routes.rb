Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do
        collection do
          patch 'refresh_encrypted_key'
        end
      end
      resources :links, only: [:create, :show, :index, :destroy]
    end
  end
  get '/', to: 'application#show_link'
end
