Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  get '/article_url', to: 'articles#find_by_url'
  resources :articles, except: %i[new edit]
end
