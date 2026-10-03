# This file populates the database with sample data for development.
# Run via: bin/rails db:seed  (or bin/rails db:reset to drop/create/migrate/seed)

puts "Clearing existing data..."
[Report, SavedListing, Review, Visit, Application, Listing, Property, User].each(&:delete_all)

puts "Creating users..."
moderator = User.create!(name: "Mora Delgado", email: "mora.moderator@roomies.test", role: "moderator")

hosts = [
  User.create!(name: "Ana Restrepo",   email: "ana.host@roomies.test",    role: "member"),
  User.create!(name: "Carlos Jimenez", email: "carlos.host@roomies.test", role: "member"),
  User.create!(name: "Lucia Pardo",    email: "lucia.host@roomies.test",  role: "member")
]

seekers = [
  User.create!(name: "Diego Torres",   email: "diego.seeker@roomies.test",   role: "member"),
  User.create!(name: "Valentina Ruiz", email: "valentina.seeker@roomies.test", role: "member"),
  User.create!(name: "Mateo Gomez",    email: "mateo.seeker@roomies.test",    role: "member"),
  User.create!(name: "Sara Mendoza",   email: "sara.seeker@roomies.test",     role: "member")
]

puts "Creating properties..."
properties = [
  Property.create!(
    host: hosts[0], address: "Calle 85 #12-34", neighborhood: "Chapinero",
    property_type: "apartment", bedrooms: 3, bathrooms: 2,
    shared_spaces: "Living room, kitchen, rooftop terrace",
    amenities: %w[wifi laundry elevator]
  ),
  Property.create!(
    host: hosts[0], address: "Carrera 11 #93-20", neighborhood: "Chico",
    property_type: "apartment", bedrooms: 4, bathrooms: 2,
    shared_spaces: "Living room, kitchen",
    amenities: %w[wifi parking pets_allowed]
  ),
  Property.create!(
    host: hosts[1], address: "Calle 70 #4-56", neighborhood: "Usaquen",
    property_type: "house", bedrooms: 5, bathrooms: 3,
    shared_spaces: "Garden, kitchen, dining room",
    amenities: %w[wifi laundry parking garden]
  ),
  Property.create!(
    host: hosts[2], address: "Transversal 6 #45-10", neighborhood: "La Macarena",
    property_type: "studio", bedrooms: 2, bathrooms: 1,
    shared_spaces: "Kitchenette",
    amenities: %w[wifi]
  )
]

puts "Creating listings..."
listings = []

listings << Listing.create!(
  property: properties[0], monthly_rent: 950.00, deposit: 950.00,
  available_date: Date.today + 10, minimum_stay: 6, furnished: true,
  private_bathroom: false, state: "published",
  description: "Bright room with a shared rooftop terrace, five minutes from the TransMilenio."
)

listings << Listing.create!(
  property: properties[0], monthly_rent: 1050.00, deposit: 1050.00,
  available_date: Date.today + 20, minimum_stay: 12, furnished: true,
  private_bathroom: true, state: "published",
  description: "Quiet room with a private bathroom, ideal for remote workers."
)

listings << Listing.create!(
  property: properties[1], monthly_rent: 1200.00, deposit: 1200.00,
  available_date: Date.today + 5, minimum_stay: 3, furnished: false,
  private_bathroom: false, state: "published",
  description: "Spacious unfurnished room in a pet-friendly apartment."
)

listings << Listing.create!(
  property: properties[2], monthly_rent: 800.00, deposit: 400.00,
  available_date: Date.today + 15, minimum_stay: 6, furnished: true,
  private_bathroom: false, state: "published",
  description: "Cozy room in a shared house with a garden. Housemate already selected."
)

listings << Listing.create!(
  property: properties[2], monthly_rent: 850.00, deposit: 425.00,
  available_date: Date.today - 60, minimum_stay: 6, furnished: true,
  private_bathroom: true, state: "published",
  description: "Room with a private bathroom, currently occupied."
)

listings << Listing.create!(
  property: properties[3], monthly_rent: 700.00, deposit: 350.00,
  available_date: Date.today + 30, minimum_stay: nil, furnished: false,
  private_bathroom: false, state: "draft",
  description: "Studio-style room, still being prepared for publication."
)

listings << Listing.create!(
  property: properties[3], monthly_rent: 650.00, deposit: 325.00,
  available_date: Date.today + 1, minimum_stay: 1, furnished: true,
  private_bathroom: false, state: "withdrawn",
  description: "Previously listed room, taken down by the host."
)

published_1, published_2, published_3, reserved_listing, rented_listing, = listings

puts "Creating applications..."
app_pending = Application.create!(
  listing: published_1, seeker: seekers[0], move_in_date: Date.today + 14,
  duration_months: 8, message: "Hi! I'm a quiet grad student looking for a long-term room.",
  state: "pending"
)

app_shortlisted = Application.create!(
  listing: published_2, seeker: seekers[1], move_in_date: Date.today + 25,
  duration_months: 12, message: "I work from home and would love to see the space.",
  state: "shortlisted"
)

Application.create!(
  listing: published_3, seeker: seekers[2], move_in_date: Date.today + 7,
  duration_months: 3, message: "Short-term stay while I finish an internship.",
  state: "pending"
)

Application.create!(
  listing: published_1, seeker: seekers[3], move_in_date: Date.today + 20,
  duration_months: 6, message: "Looking forward to hearing back from you.",
  state: "withdrawn"
)

# reserved_listing and rented_listing need to pass through "published" first --
# an application can only be created against a published listing. We create
# these as pending, then advance the application and the listing together,
# mirroring what the real "accept application" action will do in Assignment 3.
accepted_application = Application.create!(
  listing: reserved_listing, seeker: seekers[0], move_in_date: Date.today + 15,
  duration_months: 6, message: "Already visited and loved the garden!",
  state: "pending"
)

rejected_application = Application.create!(
  listing: reserved_listing, seeker: seekers[1], move_in_date: Date.today + 15,
  duration_months: 6, message: "Interested in the shared house.",
  state: "pending"
)

past_application = Application.create!(
  listing: rented_listing, seeker: seekers[2], move_in_date: Date.today - 60,
  duration_months: 6, message: "This was my application before moving in.",
  state: "pending"
)

accepted_application.update_columns(state: "accepted")
rejected_application.update_columns(state: "rejected")
past_application.update_columns(state: "accepted")
reserved_listing.update_columns(state: "reserved")
rented_listing.update_columns(state: "rented")

puts "Creating visits..."
Visit.create!(application: app_shortlisted, proposed_date: Date.today + 3, status: "confirmed")
Visit.create!(application: accepted_application, proposed_date: Date.today - 20, status: "completed")
Visit.create!(application: past_application, proposed_date: Date.today - 65, status: "completed")

puts "Creating reviews..."
Review.create!(
  property: properties[2], seeker: seekers[2], rating: 5,
  comment: "Exactly as described -- spacious, quiet, and the host was very responsive."
)
Review.create!(
  property: properties[0], seeker: seekers[1], rating: 4,
  comment: "Great location near Chapinero, a bit noisy on weekends."
)

puts "Creating saved listings..."
SavedListing.create!(user: seekers[3], listing: published_1)
SavedListing.create!(user: seekers[3], listing: published_3)

puts "Creating reports..."
Report.create!(
  reporter: seekers[0], listing: listings.last, reason: "misleading",
  details: "Listing stayed up after the host said it was no longer available.",
  status: "pending"
)
Report.create!(
  reporter: seekers[1], listing: published_3, reason: "offensive",
  details: "Comment in the description seemed inappropriate.",
  status: "dismissed"
)

puts "Seed data created:"
puts "  Users: #{User.count} (#{User.where(role: 'moderator').count} moderator, #{User.where(role: 'member').count} members)"
puts "  Properties: #{Property.count}"
puts "  Listings: #{Listing.count} (#{Listing.published.count} published)"
puts "  Applications: #{Application.count}"
puts "  Visits: #{Visit.count}"
puts "  Reviews: #{Review.count}"
puts "  Saved listings: #{SavedListing.count}"
puts "  Reports: #{Report.count}"