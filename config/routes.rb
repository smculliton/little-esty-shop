Rails.application.routes.draw do
  get '/', to: "application#welcome"

  resources :merchants do 
    resources :items 
    resources :invoices
    resources :discounts, only: [:index, :show], controller: 'merchant_discounts'
  end
  
  resources :invoice_items

  namespace :admin do 
    resources :merchants
    resources :invoices
  end
  
  get '/admin', to: 'admin/dashboards#index'
 
  get 'merchants/:id/dashboard', to: 'merchant_dashboards#show' 
end
