require "test_helper"

class ListingTest < ActiveSupport::TestCase
  test "valid with required attributes" do
    listing = Listing.new(
      property: properties(:apartment_one), monthly_rent: 900, deposit: 900,
      available_date: 5.days.from_now.to_date, state: "draft"
    )
    assert listing.valid?
  end

  test "invalid with a non-positive rent" do
    listing = listings(:published_one).dup
    listing.monthly_rent = 0
    assert_not listing.valid?
  end

  test "invalid with an unrecognized state" do
    listing = listings(:published_one).dup
    listing.state = "sold"
    assert_not listing.valid?
  end

  test "published scope only returns published listings" do
    assert_includes Listing.published, listings(:published_one)
    assert_not_includes Listing.published, listings(:draft_one)
  end
end