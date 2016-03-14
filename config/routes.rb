Rails.application.routes.draw do
  resources :auth do
    collection do
      post 'auth_expa'
    end
  end
end

