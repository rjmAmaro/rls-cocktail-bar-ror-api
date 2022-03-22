Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace 'api' do
    resources :categories do
      resources :cocktails do
        collection do

        end
        resources :ingredients
      end
    end

    #Routes that are not dependent on other Models Ids
    get '/cocktails/all', to: 'cocktails#list_all'
    get '/ingredients/all', to: 'ingredients#list_all'
  end
end