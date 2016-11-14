Rails.application.routes.draw do
  root to: redirect('/licenses', status: 302)

  resources :licenses
  resources :plans
end
