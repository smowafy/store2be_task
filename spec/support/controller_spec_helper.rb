# frozen_string_literal: true

module ControllerSpecHelper
  def parsed_response
    JSON.parse(response.body)
  end
end
