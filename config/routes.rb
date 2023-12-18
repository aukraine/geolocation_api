Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :geolocations,
                only: [:index, :show, :create, :destroy],
                param: :target,
                constraints: { :target => /[A-Za-z0-9.%:\/]+/ }
    end
  end
end
