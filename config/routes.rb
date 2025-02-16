Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope 'api' do
    scope 'spend-aggregate' do
      post 'parse', to: 'spend_aggregator#parse'
    end

    post 'currency', to: 'ai_use_case#currency_conversion'
  end

  root to: redirect('https://weiyuan-lane.github.io/')
end
