Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'http://localhost:5173'  # React dev server
      resource '*', headers: :any, methods: [:get, :post, :options]
    end
  end
  