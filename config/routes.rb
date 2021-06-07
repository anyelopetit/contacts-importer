Rails.application.routes.draw do
  root to: 'contacts#index'
  resources :contacts
  resources :contacts_files, except: %i[edit update destroy]
  devise_for :users
end
