module ApiHelpers
  include Rack::Test::Methods

  def app
    Rails.application
  end

  def json_response
    JSON.parse(last_response.body)
  end
end

World(ApiHelpers)
