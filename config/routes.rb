Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :users
      resources :attendances do
        collection do
          post :clock_in
          post :clock_out
          get :summary
        end
      end
    end
  end
end
