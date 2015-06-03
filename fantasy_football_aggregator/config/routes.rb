Rails.application.routes.draw do

  devise_for :users
  root 'search#index'
  # Routes for Player Search
  get "/search", :controller => "search", :action => "index"
  get "/search/results", :controller => "search", :action => "search"


  # Routes for the Account resource:
  # CREATE
  get "/accounts/new", :controller => "accounts", :action => "new"
  post "/create_account", :controller => "accounts", :action => "create"

  # READ
  get "/accounts", :controller => "accounts", :action => "index"
  get "/accounts/:id", :controller => "accounts", :action => "show"

  # UPDATE
  get "/accounts/:id/edit", :controller => "accounts", :action => "edit"
  post "/update_account/:id", :controller => "accounts", :action => "update"

  # DELETE
  get "/delete_account/:id", :controller => "accounts", :action => "destroy"
  #------------------------------



  # Routes for the League resource:
  # CREATE
  get "/leagues/new", :controller => "leagues", :action => "new"
  post "/create_league", :controller => "leagues", :action => "create"

  # READ
  get "/leagues", :controller => "leagues", :action => "index"
  get "/leagues/:id", :controller => "leagues", :action => "show"

  # UPDATE
  get "/leagues/:id/edit", :controller => "leagues", :action => "edit"
  post "/update_league/:id", :controller => "leagues", :action => "update"

  # DELETE
  get "/delete_league/:id", :controller => "leagues", :action => "destroy"

    # Routes for the User resource:
  # CREATE
  get "/users/new", :controller => "users", :action => "new"
  post "/create_user", :controller => "users", :action => "create"

  # READ
  get "/users", :controller => "users", :action => "index"
  get "/users/:id", :controller => "users", :action => "show"

  # UPDATE
  get "/users/:id/edit", :controller => "users", :action => "edit"
  post "/update_user/:id", :controller => "users", :action => "update"

  # DELETE
  get "/delete_user/:id", :controller => "users", :action => "destroy"

  #------------------------------

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
