Rails.application.routes.draw do
  resources :secrets, only: [:create, :show, :update], path: 'sh'
end
