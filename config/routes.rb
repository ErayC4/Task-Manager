Rails.application.routes.draw do
  get 'home/index'
  get 'subtasks/index'

  resources :tasks
  devise_for :users
  # config/routes.rb
  
  resources :tasks do
    member do
      get 'edit_subtask', to: 'subtasks#edit'
      patch 'update_subtask', to: 'subtasks#update'

      #for autosave
      patch :update_field

    end
  end
  resources :subtasks, only: [:index] do
    member do
      patch :toggle_finished  # Fügt eine Patch-Route zum Togglen hinzu
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
