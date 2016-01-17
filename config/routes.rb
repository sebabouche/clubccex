Rails.application.routes.draw do

  root to: 'logged#index'

  get 'inscription', to: 'sessions#sign_up_form'
  get 'merci', to: 'sessions#thankyou', as: :thank_you

  get   "sessions/sign_up_form"
  post  "sessions/sign_up"
  get   "sessions/sign_up_sleeping_form/:id", controller: :sessions, action: :sign_up_sleeping_form
  patch "sessions/sign_up_sleeping/:id", controller: :sessions, action: :sign_up_sleeping, as: :session_sign_up_sleeping

  get   "sessions/sign_out"
  
  get   "sessions/sign_in_form"
  post  "sessions/sign_in"

  get  "sessions/wake_up_form/:id", controller: :sessions, action: :wake_up_form
  post "sessions/wake_up/:id", controller: :sessions, action: :wake_up, as: :session_wake_up

  resources :recommendations

end
