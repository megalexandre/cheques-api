class MetricsController < ActionController::Base
  # Expose Prometheus metrics in text format
  def index
    body = Prometheus::Client::Formats::Text.marshal(PROM_REGISTRY)
    render plain: body, content_type: Prometheus::Client::Formats::Text::CONTENT_TYPE
  end
end
