require "test_helper"

class ApplicationTest < ActiveSupport::TestCase
  test "valid when a seeker applies to someone else's published listing" do
    application = Application.new(
      listing: listings(:published_one), seeker: users(:seeker_one),
      move_in_date: 10.days.from_now.to_date, state: "pending"
    )
    assert application.valid?
  end

  test "invalid when the host applies to their own listing" do
    application = Application.new(
      listing: listings(:published_one), seeker: users(:host_one),
      move_in_date: 10.days.from_now.to_date, state: "pending"
    )
    assert_not application.valid?
  end

  test "invalid when applying to a listing that is not published" do
    application = Application.new(
      listing: listings(:draft_one), seeker: users(:seeker_one),
      move_in_date: 10.days.from_now.to_date, state: "pending"
    )
    assert_not application.valid?
  end

  test "invalid when the same seeker applies twice to the same listing" do
    Application.create!(
      listing: listings(:published_one), seeker: users(:seeker_one),
      move_in_date: 10.days.from_now.to_date, state: "pending"
    )

    duplicate = Application.new(
      listing: listings(:published_one), seeker: users(:seeker_one),
      move_in_date: 12.days.from_now.to_date, state: "pending"
    )
    assert_not duplicate.valid?
  end
end