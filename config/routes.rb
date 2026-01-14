Rails.application.routes.draw do
  resources :cheques

  get "bank_holidays/index"
  get "bank_holidays/show"
  get "bank_holidays/create"
  get "bank_holidays/update"
  get "bank_holidays/destroy"

  resources :bank_holidays
  post "borderos/preview" => "bordero_previews#preview", as: :calculate_preview
  post "borderos" => "borderos#create", as: :create_bordero

  get "up" => "rails/health#show", as: :rails_health_check
end
