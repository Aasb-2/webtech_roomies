require "test_helper"

class PropertyTest < ActiveSupport::TestCase
  test "valid with required attributes" do
    property = Property.new(
      host: users(:host_one), neighborhood: neighborhoods(:chico), address: "Carrera 11 #93-20",
      property_type: "apartment", bedrooms: 2, bathrooms: 1
    )
    assert property.valid?
  end

  test "invalid with an unrecognized property type" do
    property = properties(:apartment_one).dup
    property.property_type = "castle"
    assert_not property.valid?
  end

  test "invalid without a host" do
    property = Property.new(
      neighborhood: neighborhoods(:chico), address: "Carrera 11 #93-20",
      property_type: "apartment", bedrooms: 2, bathrooms: 1
    )
    assert_not property.valid?
  end

  test "invalid without a neighborhood" do
    property = Property.new(
      host: users(:host_one), address: "Carrera 11 #93-20",
      property_type: "apartment", bedrooms: 2, bathrooms: 1
    )
    assert_not property.valid?
  end
end