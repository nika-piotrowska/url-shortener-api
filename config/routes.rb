Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :links, only: [:create, :show, :index, :destroy]
    end
  end
  get '/', to: 'application#show_link'
end
