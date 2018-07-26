Rails.application.routes.draw do
  scope path: '/api' do
    api_version(module: "Api::V1", path: { value: "v1" }, defaults: { format: 'json' }) do
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
