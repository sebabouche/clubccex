Rails.application.routes.draw do

  root to: 'logged#index'

  get 'inscription', to: 'sessions#sign_up_form'
  get 'merci', to: 'sessions#thankyou', as: :thank_you

  get   "sessions/sign_up_form"
  post  "sessions/sign_up"
  get   "sessions/sign_up_sleeping_form/:id", controller: :sessions, action: :sign_up_sleeping_form, as: :sessions_sign_up_sleeping_form
  get   "sessions/send_sleeping_email/:id", controller: :sessions, action: :send_sleeping_email, as: :sessions_send_sleeping_email
  patch "sessions/sign_up_sleeping/:id", controller: :sessions, action: :sign_up_sleeping #, as: :sessions_sign_up_sleeping

  get   "sessions/sign_out"
  
  get   "sessions/sign_in_form"
  post  "sessions/sign_in"

  get  "sessions/wake_up_form/:id", controller: :sessions, action: :wake_up_form, as: :sessions_wake_up_form
  post "sessions/wake_up/:id", controller: :sessions, action: :wake_up #, as: :session_wake_up

  resources :recommendations

  resources :users do
    get :unconfirmed, on: :collection
    get :next, on: :collection
    get :confirm, on: :member
  end

  resources :posts do
    member do
      post :create_comment
      get :next_comments
    end
  end
  resources :categories
end
