Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "welcome#index"
  resources :pets
  resources :applications
  resources :shelters do
    resources :pets, controller: "shelter_pets", only: [:index, :new, :create]
  end
  resources :application_pets
  
  scope :admin do
    resources :applications
  end
end 
