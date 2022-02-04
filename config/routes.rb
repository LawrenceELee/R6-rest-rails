Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users,
             controllers: {
                sessions: 'users/sessions',
                registrations: 'users/registrations'
             }

  get '/test', to: 'test#show'


  namespace :api do
    namespace :v1 do
      resources :members do
        resources :facts
      end
    end
  end

end
