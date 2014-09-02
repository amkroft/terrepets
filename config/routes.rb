Terrepets::Application.routes.draw do

  resources :recipes

  devise_for :users, :controllers => { :registrations => "registrations" }

  root :to => 'home#index'

  match 'terms_of_service' => 'policies#terms_of_service', :via => :get, as: :terms_of_service
  match 'privacy_policy' => 'policies#privacy_policy', :via => :get, as: :privacy_policy
  match 'copyright' => 'policies#copyright', :via => :get, as: :copyright

  authenticate(:user) do

    get 'users/active'
    get 'users/online'
    resources :users, except: :show
    match 'users/:id/award' => 'users#award', :via => :post, as: :user_award

    resources :custom_pet_templates
    resources :standard_pet_templates

    resources :custom_avatars
    resources :standard_avatars

    # Plaza routes
    get 'forums/stars_received'
    get 'forums/stars_given'
    get 'forums/irc'
    match 'posts/:id' => 'posts#show', via: :get, as: :post
    resources :forums do
      resources :topics do
        resources :posts
      end
    end
    match 'forum/:forum_id/topic/:topic_id/posts/:id/star' => 'posts#star', :via => :get, as: :star_post
    match 'posts/:id/star' => 'posts#star_post_ajax', :via => :get, as: :star_post_ajax


    resources :items
    resources :item_templates
    resources :makeables
    match 'items/action' => 'items#action', :via => :post
    match 'item_encyclopedia/:name' => 'item_encyclopedia#show', :via => :get, as: :item_encyclopedia
    # match 'items/do_action/:id'
    
    resources :locations

    match 'admin' => 'admin#index', :via => :get, as: :admin
    match 'status'=> 'admin#check_status', :via => :get, as: :status
    # match 'test_mail' => 'admin#test_mail', :via => :get
    match 'email_name' => 'admin#email_name', :via => :get

    match 'bank' => 'bank#index', :via => :get, as: :bank
    get 'bank/stars'
    match 'bank/stars' => 'bank#buy_stars', via: :post
    namespace :bank do
      post 'deposit'
      post 'withdraw'
      post 'transact'
    end

    # Favor routes
    match 'favor' => 'favor#index', via: :get
    match 'favor' => 'favor#process_payment', :via => :post
    match 'favor/history' => 'favor#history', via: :get
    match 'favor/regraphic_pet' => 'favor#regraphic_pet', via: :get
    match 'favor/regraphic_pet' => 'favor#regraphic_pet_update', via: :post
    match 'favor/custom_pet' => 'favor#custom_pet', via: :get
    match 'favor/custom_pet' => 'favor#customize_pet', via: :post
    get 'favor/transfer'
    match 'favor/transfer' => 'favor#process_transfer', via: :post
    get 'favor/tickets'
    match 'favor/tickets' => 'favor#redeem_tickets', via: :post, as: :favor_redeem_tickets

    # Pet routes
    resources :pets, except: :show
    match 'pets/:id/equip' => 'pets#equip', via: :get, as: :equip_pet
    match 'pets/:id/equip' => 'pets#update_equip', via: :post, as: :update_equip_pet
    match 'pets/:id/unequip' => 'pets#unequip', via: :post, as: :unequip_pet
    match 'pets/:id/hour_logs' => 'pets#hour_logs', via: :get, as: :pet_hour_logs
    match 'pets/:id/reincarnate' => 'pets#reincarnation', via: :get, as: :pet_reincarnation
    match 'pets/:id/reincarnate' => 'pets#reincarnate', via: :post, as: :pet_reincarnate
	
    # House routes
    match 'house'=> 'house#index', :via=> :get 
    match 'house/run_hours' => 'house#run_hours', :via => :post
    get 'house/run_hours', to: redirect('/house')
    match 'house/force_run_hour' => 'house#force_run_hour', :via => :post
    get 'house/force_run_hour', to: redirect('/house')

    match 'incoming' => 'house#incoming', via: :get, as: :incoming

    # Pet Shelter routes
    match 'pet_shelter'=> 'pet_shelter#index', :via=> :get, as: :pet_shelter
    match 'pet_shelter/giveup'=> 'pet_shelter#give_up', :via=> :get, as: :give_up

    match 'pet_shelter/adopt'=> 'pet_shelter#adopt', :via=> :post, as: :adopt_pet
    match 'pet_shelter/giveup'=> 'pet_shelter#give_up_pets', :via=> :post, as: :give_up_pets

    match 'pet_shelter/rename' => 'pet_shelter#rename', :via => :get, as: :rename
    match 'pet_shelter/rename' => 'pet_shelter#rename_pets', :via => :post, as: :rename_pets

    # My Account routes
    match 'my_account' => 'my_account#index', :via => :get, as: :my_account_index
    match 'my_account/avatar' => 'my_account#avatar', :via => :get
    match 'my_account/update_password/:user_id' => 'passwords#update', :via => :put, as: :update_password
    match 'my_account/avatar' => 'my_account#update_avatar', :via => :post
    get 'my_account/stats'
    get 'my_account/profile'
    match 'my_account/profile' => 'my_account#update_profile', via: :put, as: :my_account_update_profile

    # Commerce routes
    match 'trading_post' => 'commerce/item_trades#index', :via => :get  
    match 'trading_post/new' => 'commerce/item_trades#new', via: :get, as: :new_trade
    match 'trading_post/new' => 'commerce/item_trades#create', via: :post, as: :create_trade
    match 'item_trades/:id/cancel' => 'commerce/item_trades#cancel', via: :get, as: :cancel_trade
    match 'item_trades/:id/accept' => 'commerce/item_trades#accept', via: :get, as: :accept_trade
    match 'item_trades/:id/negotiate' => 'commerce/item_trades#negotiate', via: :get, as: :negotiate_trade
    match 'item_trades/:id/negotiate' => 'commerce/item_trades#process_negotiation', via: :post, as: :process_trade_negotiation

    match 'flea_market' => 'commerce/flea_market#index', :via => :get, as: :flea_market
    match 'flea_market/search' => 'commerce/flea_market#search', :via => :post, as: :search_flea_market

    match 'stores/logs' => 'commerce/store_transactions#index', :via => :get, as: :store_logs
    match 'stores(/:user_id)' => 'commerce/stores#index', :via => :get, as: :stores
    # match 'stores/sell' => 'commerce/stores#sell', :via => :post
    match 'stores/action' => 'commerce/stores#action', :via => :post
    match 'stores/:user_id/buy' => 'commerce/stores#buy', :via => :post, as: :stores_buy

    # Service routes
    match 'grocery_store' => 'services/grocery_store#index', :via => :get
    match 'grocery_store/buy' => 'services/grocery_store#buy', :via => :post
    match 'recycling' => 'services/recycling#index', :via => :get
    match 'giving_tree' => 'services/giving_tree#index', :via => :get
    match 'pattern_shop' => 'services/pattern_shop#index', via: :get
    match 'pattern_shop' => 'services/pattern_shop#trade', via: :post

    # Internal Mail
    match 'internal_mail/mdestroy' => 'internal_mail#mdestroy', :via => :delete, as: :internal_mail_mdestroy
    resources :internal_mail

    # Statistics
    match 'statistics' => 'statistics#index', :via => :get
    get 'statistics/giving_tree'
    get 'statistics/pattern'
    get 'statistics/recycling'

    # Pattern
    match 'pattern' => 'pattern#index', via: :get
    match 'pattern/pattern_tile' => 'pattern#pattern_tile', via: :get, as: :pattern_tile
    match 'pattern/pattern_tile' => 'pattern#place_pattern_tile', via: :post, as: :place_pattern_tile
    match 'pattern/move/:direction' => 'pattern#move', via: :get, as: :pattern_user_move
    match 'pattern/overview' => 'pattern#overview', via: :get
    match 'pattern/overview' => 'pattern#view_overview', via: :post, as: :pattern_view_overview

  end

  resources :users, only: :show
  resources :pets, only: :show

  #get "errors/error_404"
  #get "errors/error_500"

  unless Rails.application.config.consider_all_requests_local
    match '*not_found' => 'errors#error_404', :via => :get
  end

end
