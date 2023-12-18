Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :geolocations, only: [:index, :show, :create, :destroy], param: :target
    end
  end
end
