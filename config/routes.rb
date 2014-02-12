DataEngineering::Application.routes.draw do
  resources :import_files, only: [:new, :create, :index]
  
  root 'import_files#new'
end
