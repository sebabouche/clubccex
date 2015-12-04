Rails.application.routes.draw do

  root to: 'home#index'

  get 'home/index'

  get 'inscription', to: 'anonymous#index'
  get 'merci', to: 'anonymous#thankyou'

  get 'bienvenue', to: 'logged#index'

  resources :users

  get  "sessions/sign_up_form"
  post "sessions/sign_up"
  get  "sessions/sign_out"
  get  "sessions/sign_in_form"
  post "sessions/sign_in"

  get  "sessions/wake_up_form/:id", controller: :sessions, action: :wake_up_form
  post "sessions/wake_up/:id", controller: :sessions, action: :wake_up, as: :session_wake_up

end
