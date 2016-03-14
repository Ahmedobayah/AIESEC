Rails.application.routes.draw do
	resources :auth do
		collection do
			get 'auth_expa'
		end
	end
end

