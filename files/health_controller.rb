class HealthController < ActionController::API
  def index
    render text: 'ok', status: :ok
  end
end
