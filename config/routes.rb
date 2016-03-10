Rails.application.routes.draw do
  
  get 'courses/index'

  devise_for :users, :controllers => {sessions: 'users/sessions', registrations: 'users/registrations'}
  resources :feedbacks, :only => [:new, :create]
  root :to => 'libraries#show', :id => 1

	get "search", to: "libraries#search", :id => 1, :as => 'search_library'
	get "suggestions", to: "libraries#show_suggestions", :id => 1, :as => 'suggestions_library'

  resources :courses, :only => [:index]
  resources :libraries, :except => [:show], :shallow => true do
		# member do
     #  get "search", to: "libraries#search"
		# 	get "suggestions", to: "libraries#show_suggestions"
		# 	put "subscribe", to: "libraries#subscribe"
		# 	put "unsubscribe", to: "libraries#unsubscribe"
		# end
    #resources :categories
		resources :invitations, :except => [:index] do
			member do
				put "accept", to: "invitations#accept"
			end
		end
    resources :categories, :except => [:index] do
      resources :sections, :except => [:index] do
				resources :entries do
					member do
						put "like", to: "entries#upvote"
						put "dislike", to: "entries#downvote"
						put "read", to: "entries#read"
						put "accept", to: "entries#accept"
					end
				end
			end
    end
  end


	
	get "browse_libraries" => "libraries#browse"

  put 'toggle_edit' => 'toggles#toggle_edit'
  put 'toggle_read' => 'toggles#toggle_read'

  #~ get '/tag/:id'  => 'tags#show', as: :tag
  #~ get '/tags' => 'tags#index', as: :tag_search
  
  #get '/signup' => 'users#new'
  #~ get '/login' => 'sessions#new'
  #~ post '/login' => 'sessions#create'
  #~ delete '/logout' => 'sessions#destroy'
  
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
