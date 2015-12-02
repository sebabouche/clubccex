Rails.application.routes.draw do

  root to: 'home#index'

  get 'home/index'
  get 'home/thankyou'

  resources :users

end
