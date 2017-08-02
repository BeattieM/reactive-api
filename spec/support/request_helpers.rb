module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end

    def json_params(params = {})
      params.merge(format: :json)
    end
  end
end

# Configure these to modules as helpers in the appropriate tests.
RSpec.configure do |config|
  # Include the help for the request specs.
  config.include Requests::JsonHelpers, type: :controller
end
