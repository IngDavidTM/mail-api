Rails.application.routes.draw do
  post 'send_email', to: 'emails#send_email'

  # Liveness check for the platform; returns 200 when the app boots
  get 'up' => 'rails/health#show', as: :rails_health_check
end
