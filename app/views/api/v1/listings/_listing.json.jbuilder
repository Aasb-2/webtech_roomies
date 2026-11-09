json.id listing.id
json.monthly_rent listing.monthly_rent.to_f
json.deposit listing.deposit.to_f
json.available_date listing.available_date
json.minimum_stay listing.minimum_stay
json.furnished listing.furnished
json.private_bathroom listing.private_bathroom
json.state listing.state
json.description listing.description.to_plain_text
json.house_rules listing.house_rules.to_plain_text
json.created_at listing.created_at

json.property do
  json.property_type listing.property.property_type
  json.bedrooms listing.property.bedrooms
  json.bathrooms listing.property.bathrooms
  json.shared_spaces listing.property.shared_spaces
  json.neighborhood listing.property.neighborhood.name
  json.amenities listing.property.amenities.map(&:name)
  json.average_rating listing.property.average_rating
end

json.photo_urls listing.photos.map { |photo| rails_blob_url(photo) }