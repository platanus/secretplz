Rails.application.routes.draw do
  resources :secrets, only: [:index, :create, :show, :update], path: 'sh'
end
