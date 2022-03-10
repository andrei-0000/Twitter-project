Rails.application.routes.draw do
  resources :tweets do
    member do
      put 'like'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
      end
    end
  root 'tweets#index'
end
