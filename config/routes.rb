Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # デバイス関連のルーティング
  ##########ここから##########
  devise_for :admins, controllers: {
  sessions:      'admins/sessions',
  passwords:     'admins/passwords',
  #admins/registrationsは必要？  registrations: 'admins/registrations'
  }
  devise_for :customers, controllers: {
  sessions:      'customers/sessions',
  passwords:     'customers/passwords',
  registrations: 'customers/registrations'
  }
  ##########ここまで##########

  #管理者ページのルーティング
  ##########ここから##########
  namespace :admin do
    #admin/customersコントローラのルーティング
    resources :customers, only: [:index, :show, :edit, :update]
    
    #admin/productsコントローラのルーティング
    resources :products, only: [:index, :show, :edit, :new, :update, :create]
    
    #admin/genresコントローラのルーティング
    resources :genres, only: [:index, :edit, :update, :create]
    
    #admin/ordersコントローラのルーティング
    resources :orders, only: [:index, :show, :update] do
      
      #admin/order_itemsコントローラのルーティング
      resources :order_items, only: [:update]
    end
  end
  ##########ここまで##########

  #会員ページのルーティング
  ##########ここから##########
  scope module: :public do
    #public/homesコントローラのルーティング
    root to: 'homes#top'
    get '/about', to: 'homes#about', as: 'about'
  
    #public/cart_itemsコントローラのルーティング 
    resources :cart_items, only: [:index, :update, :create, :destroy]
    delete 'cart_items', to: 'cart_items#destroy_all', as: 'destroy_all'         
  
    
    #public/customersコントローラのルーティング
    get '/customers/mypage', to: 'customers#show', as: 'mypage'
    resource :customers, only: [:edit, :update] do
      collection do
        get 'quit_check'#'/customers/quit_check', to: 'customers#quit_check', as: 
        patch 'quit'#'/customers/quit', to: 'customers#quit', as: 
      end
    end
    
    #public/deliveriesコントローラのルーティング
    resources :deliveries, only: [:index, :edit, :update, :destroy]
  
    #public/ordersコントローラのルーティング
    resources :orders, only: [:index, :show, :new, :create] do
      collection do 
        get 'finish'#'/orders/finish', to: 'orders#finish', as:  
        post 'confirm'#'/orders/confirm', to: 'orders#confirm', as: 
      end
    end
    
    #public/productsコントローラのルーティング
    resources :products, only: [:index, :show]
  end
##########ここまで##########
end