Rails.application.routes.draw do

  get 'recommendations/edit'

  root to: 'sessions#sign_up_form'

  get 'home/index'

  get 'inscription', to: 'sessions#sign_up_form'
  get 'merci', to: 'sessions#thankyou', as: :thank_you

  get 'bienvenue', to: 'logged#index'

  get  "sessions/sign_up_form"
  post "sessions/sign_up"
  get  "sessions/sign_out"
  get  "sessions/sign_in_form"
  post "sessions/sign_in"

  get  "sessions/wake_up_form/:id", controller: :sessions, action: :wake_up_form
  post "sessions/wake_up/:id", controller: :sessions, action: :wake_up, as: :session_wake_up

  resources :recommendations

end
