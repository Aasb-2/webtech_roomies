require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid with name, email and role" do
    user = User.new(name: "Test User", email: "test.user@example.com", role: "member")
    assert user.valid?
  end

  test "invalid without an email" do
    user = User.new(name: "Test User", email: nil, role: "member")
    assert_not user.valid?
  end

  test "invalid with a duplicate email, case-insensitively" do
    duplicate = User.new(name: "Another Name", email: users(:host_one).email.upcase, role: "member")
    assert_not duplicate.valid?
  end

  test "invalid with an unrecognized role" do
    user = User.new(name: "Test User", email: "test.role@example.com", role: "superadmin")
    assert_not user.valid?
  end
end