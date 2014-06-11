Nyborhood::Application.routes.draw do
  # resources :buildings
  get '/buildings' => 'buildings#index'
  # root ‘/buildings#index’
  # get ‘/auctions’ => ‘auctions#index’
  # get ‘/auctions/new’ => ‘auctions#new’, as: ‘new_auctions’
  # post ‘/auctions’ => ‘auctions#create’
  # get ‘/auctions/:id’ => ‘auctions#show’, as: ‘auction’
  # patch ‘/auctions/:id’ => ‘auctions#update’
  # delete ‘/auctions/:id => ‘auctions#destory’
  # get ‘/auctions/:id/edit => ‘auctions#edit’, as: ‘edit_auction’
  # get ‘/auctions/:auction_id/bids/new => ‘bids#new’, as: ‘new_bid’ #(forces you to use form tag) 
  # get ‘/auctions/:auction_id/bids/ => ‘bids#index’, as: ‘auction_bids’
  # post ‘/auctions/:auction_id/bids => ‘bids#create’}

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
