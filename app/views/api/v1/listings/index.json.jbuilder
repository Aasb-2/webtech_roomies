json.listings @listings do |listing|
  json.partial! "api/v1/listings/listing", listing: listing
end

json.meta do
  json.count @listings.size
end