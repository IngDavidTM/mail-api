Rails.application.routes.draw do
  post 'send_email', to: 'emails#send_email'
end
