Rails.application.routes.draw do
  post "borderos" => "borderos#create", as: :create_bordero
  post "borderos/calculate" => "borderos#calculate", as: :calculate_bordero

  get "up" => "rails/health#show", as: :rails_health_check
end
