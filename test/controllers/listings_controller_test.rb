require "test_helper"

class ListingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get listings_url
    assert_response :success
  end

  test "index only shows published listings" do
    get listings_url
    assert_match listings(:published_one).property.neighborhood.name, @response.body
  end

  test "should get show" do
    get listing_url(listings(:published_one))
    assert_response :success
  end
end