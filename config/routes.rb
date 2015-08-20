Rails.application.routes.draw do

  root 'application#prepare'

  # get '/request' => 'application#request', as: 'request'
  # get '/parse'   => 'application#parse',   as: 'parse'
end
