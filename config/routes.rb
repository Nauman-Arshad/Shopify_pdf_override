Rails.application.routes.draw do
  resources :resumes do
    
  end
  get '/test_resume', to: 'resumes#test_resume', as: 'test_resume'
  root 'resumes#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
