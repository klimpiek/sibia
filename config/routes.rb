Rails.application.routes.draw do
  devise_for :users, only: :sessions

  resources :bits

  resource :user, only: [:edit, :update] do
    get 'profile'
  end
  resolve("User") { [:user] } # to make form_for works properly on singular resource

  get 'favorites', to: 'bits#favorites'
  get 'links', to: 'bits#links'
  get 'tasks', to: 'bits#tasks'
  get 'events', to: 'bits#events'

  get 'workspace', to: 'pages#workspace'
  get 'calendar', to: 'pages#calendar'
  get 'gantt', to: 'pages#gantt'
  get 'dashboard', to: 'pages#dashboard'
  get 'help', to: 'pages#help'

  get 'tags', to: 'pages#tags', as: :tags
  get 'search', to: 'pages#search', as: :search
  get 'search/advanced', to: 'pages#advanced', as: :advanced_search

  # to test vue in rails
  get 'vue', to: 'pages#vue'
  get 'agenda', to: 'pages#agenda'

  post 'line_bot/callback'
  if Rails.env.production?
    # see telegram-bot-rb/lib/telegram/bot/routes_helper.rb
    post "telegram/#{Rails.application.credentials.telegram[:bots][:webhook]}",
        to: Telegram::Bot::Middleware.new(Telegram::Bot::Client.wrap(:default), TelegramBotController),
        as: :telegram_webhook,
        format: false
    #  telegram_webhook TelegramBotController, :webhook, as: :telegram_webhook
  end

  authenticate :user do
    get 'line_bot/account_link'
  end

  get '*missing', to: 'pages#home'

  authenticated :user do
    root 'pages#workspace', as: :user_root
  end

  root 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
