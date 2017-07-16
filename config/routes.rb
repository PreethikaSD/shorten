Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    match '/' => 'links#api_shorten', via: :post, :defaults => { :format => :json }
    get '/:short_link', to: "links#show"
    get '/' => 'links#get_link'

end
