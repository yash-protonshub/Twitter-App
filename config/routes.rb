Rails.application.routes.draw do
  devise_for :users, controllers: {
        registrations: 'users/registrations',
        sessions: 'users/sessions'
      }

      resources :tweets, only:[:create, :destroy, :index, :show] do
      	get :user_profile, on: :collection
      end

      get 'follow', to: 'relationships#follow_user'
      get 'unfollow', to: 'relationships#unfollow_user'
      get 'followers', to: 'relationships#user_followers'
      get 'followers_tweets', to: 'relationships#followers_tweets'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
