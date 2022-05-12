Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"
  namespace :api do
    namespace :v1 do
      resources :reservations, only: [:index, :show] do
        collection do
          post "registration"
        end
      end
    end
  end
end
