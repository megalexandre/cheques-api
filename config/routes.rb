Rails.application.routes.draw do
  resources :cheques
  resources :borderos
    
  get "up" => "rails/health#show", as: :rails_health_check

end
