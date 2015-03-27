Dazuoxiaoti::Application.routes.draw do

  namespace :mobile do
    resources :questions do
      member do
        get 'skip'
      end
      collection do
        get 'random'
      end
      resources :answers
    end
    resources :question_sets do
      member do
        get 'subscribe'
        get 'unsubscribe'
      end
    end
    resources :home, only: :index
    resources :projects, :past_projects
    root :to => "home#index"
  end
  
  get "/question_sets" ,to: "classifies#index"
  resources :classifies 
  resources :messages,:only=>[:index,:show,:destroy] do
    collection do 
      post :delete
    end
  end
  namespace :new_admin do
      resources :users
      resources :yixin_cards
      resources :messages do
        collection do
          get :list
        end
      end
      resources :projects do
        member do
           get  'toggle'
        end
      end

      resources :home_notices
      resources  :assets
      resources :categories
      resources :question_sets do
        member do
          get :export
        end
      end
      resources :questions do 
         collection do
            get :upload
            post :upload_sponsor
         end
      end
      root :to =>"categories#index"

      resources :pending_questions do
        member do
          post 'accept'
          post 'reject'
        end
        collection do
          post "batch_update"
          get 'list'
          get 'uploading'
          post "import"
        end
      end

  end
  
  devise_for :users, :controllers => {
    :sessions => "users/sessions",
    :registrations => "users/registrations",
    :passwords => "users/passwords",
    :omniauth_callbacks => "authentications"
  }

  resources :questions do
    member do
      get 'skip'
      get 'like'
    end
    collection do
      get 'random'
      get 'shuffle_all'
      get 'search'
    end
    resources :answers, :feedbacks
  end

  resources :surveys do
    collection do
      get 'random'
    end
  end

  resources :pending_questions do
    member do
      post 'accept'
      post 'reject'
    end
    collection do
      get 'list'
    end
  end

  resources :dashboard do
    collection do
      get 'main'
      get 'sets'
      get 'questions'
    end
  end

  controller :pending_questions do
    post 'pending_questions/import' => :import
  end
  
  resources :question_sets do
    member do
      get 'subscribe'
      get 'unsubscribe'
    end
    collection do
      get 'manage'
    end
  end
      
  namespace :sina_app do
    resources :app do
      collection do
        post 'authenticate'
        get 'authorize'
        get 'main'
      end
    end
    resources :questions do
      collection do
        get 'random'
      end
    end
    resources :projects do
      collection do
        get 'current'
      end
    end
    resources :answers
    resources :question_sets do
      member do
        get 'select'
      end
    end
  end
  
  resources :projects, :past_projects, :organizations, :benefits, :question_sets, :feedbacks
  
  match 'fillup', :controller => 'surveys', :action => 'fillup'
  match 'update_category', :controller => 'categories', :action => 'update_categories_to_user'
  match 'about_us', :controller => 'static', :action => 'about_us'
  match 'faq', :controller => 'static', :action => 'faq'
  match 'donate', :controller => 'static', :action => 'donate'
  match 'contact', :controller => 'static', :action => 'contact'
  match 'thanks', :controller => 'static', :action => 'thanks'
  match 'share', :controller => 'static', :action => 'share'
  match 'guide', :controller => 'static', :action => 'guide'
  match 'close_notice', :controller => 'static', :action => 'close_notice'
  match 'admin', :controller => 'static', :action => 'admin'
  match 'home', :controller => 'static', :action => 'home'
  match 'sizhong', :controller => 'static', :action => 'sizhong'
  match 'fuzhong', :controller => 'static', :action => 'fuzhong'
  match 'diandian', :controller => 'static', :action => 'diandian'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'static#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
