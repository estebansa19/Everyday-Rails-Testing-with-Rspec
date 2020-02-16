Rails.application.routes.draw do

  devise_for :users, controllers: { registrations: 'registrations' }

  authenticated :user do
    root 'projects#index', as: :authenticated_root
  end

  resources :projects do
    resources :notes
    resources :tasks do
      member do
        post :toggle
      end
    end

    member do
      patch :complete
    end
  end

  namespace :api do
    resources :projects do
      collection do
        get 'last', to: 'projects#last_project'
      end
    end
  end

  root "home#index"
end
