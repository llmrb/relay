# frozen_string_literal: true

require "setup"

class ListModelsRouteTest < Relay::Test
  def test_list_models_route_is_not_defined_under_api_namespace
    get "/api/models"
    assert_equal 404, last_response.status
  end

  def test_models_route_requires_authentication
    get "/models"
    assert_equal 401, last_response.status
    assert_match "Unauthorized", last_response.body
  end

  def test_models_route_returns_json_when_unauthenticated
    get "/models"
    assert_equal 401, last_response.status
    assert_equal "application/json", last_response.headers["Content-Type"]
  end
end
