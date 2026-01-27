# Basic Prometheus metrics setup
require "prometheus/client"
require "prometheus/client/formats/text"

PROM_REGISTRY = Prometheus::Client.registry

# Define common metrics
HTTP_REQUESTS_TOTAL = PROM_REGISTRY.counter(:http_requests_total, docstring: "A counter of HTTP requests made")
HTTP_REQUEST_DURATION_SECONDS = PROM_REGISTRY.histogram(:http_request_duration_seconds, docstring: "A histogram of request durations in seconds")

# Middleware to observe requests
class PrometheusMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    status, headers, response = @app.call(env)
    duration = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started

    # Labels: method and path (coarse)
    req = Rack::Request.new(env)
    method = req.request_method
    path = env["PATH_INFO"] || "-"

    HTTP_REQUESTS_TOTAL.increment(labels: { method: method, path: path }) rescue nil
    HTTP_REQUEST_DURATION_SECONDS.observe(duration, labels: { method: method, path: path }) rescue nil

    [status, headers, response]
  end
end

# Insert middleware
Rails.application.config.middleware.use PrometheusMiddleware
