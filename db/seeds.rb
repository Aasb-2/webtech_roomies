# This file populates the database with sample data for development.
# Run via: bin/rails db:seed  (or bin/rails db:reset to drop/create/migrate/seed)

puts "Clearing existing data..."
# destroy_all (not delete_all) so dependent Active Storage attachments,
# Action Text rich texts, and join records are cleaned up via callbacks,
# and so Neighborhood's restrict_with_error on properties doesn't block
# re-running this script.
[Report, SavedListing, Review, Visit, Application, Listing, Property, Neighborhood, Amenity, User].each(&:destroy_all)

puts "Creating users..."
moderator = User.create!(name: "Mora Delgado", email: "mora.moderator@roomies.test", role: "moderator")

ana    = User.create!(name: "Ana Restrepo",   email: "ana.host@roomies.test",    role: "member")
carlos = User.create!(name: "Carlos Jimenez", email: "carlos.host@roomies.test", role: "member")
lucia  = User.create!(name: "Lucia Pardo",    email: "lucia.host@roomies.test",  role: "member")

diego     = User.create!(name: "Diego Torres",   email: "diego.seeker@roomies.test",   role: "member")
valentina = User.create!(name: "Valentina Ruiz", email: "valentina.seeker@roomies.test", role: "member")
mateo     = User.create!(name: "Mateo Gomez",    email: "mateo.seeker@roomies.test",    role: "member")
sara      = User.create!(name: "Sara Mendoza",   email: "sara.seeker@roomies.test",     role: "member")

puts "Creating neighborhood catalog..."
chapinero   = Neighborhood.create!(name: "Chapinero")
chico       = Neighborhood.create!(name: "Chico")
usaquen     = Neighborhood.create!(name: "Usaquen")
la_macarena = Neighborhood.create!(name: "La Macarena")

puts "Creating amenity catalog..."
wifi          = Amenity.create!(name: "WiFi")
laundry       = Amenity.create!(name: "Laundry")
elevator      = Amenity.create!(name: "Elevator")
parking       = Amenity.create!(name: "Parking")
pets_allowed  = Amenity.create!(name: "Pets allowed")
garden        = Amenity.create!(name: "Garden")

puts "Creating properties..."
p0 = Property.create!(
  host: ana, address: "Calle 85 #12-34", neighborhood: chapinero,
  property_type: "apartment", bedrooms: 3, bathrooms: 2,
  shared_spaces: "Living room, kitchen, rooftop terrace",
  amenities: [wifi, laundry, elevator]
)

p1 = Property.create!(
  host: ana, address: "Carrera 11 #93-20", neighborhood: chico,
  property_type: "apartment", bedrooms: 4, bathrooms: 2,
  shared_spaces: "Living room, kitchen",
  amenities: [wifi, parking, pets_allowed]
)

p2 = Property.create!(
  host: carlos, address: "Calle 70 #4-56", neighborhood: usaquen,
  property_type: "house", bedrooms: 5, bathrooms: 3,
  shared_spaces: "Garden, kitchen, dining room",
  amenities: [wifi, laundry, parking, garden]
)

p3 = Property.create!(
  host: lucia, address: "Transversal 6 #45-10", neighborhood: la_macarena,
  property_type: "studio", bedrooms: 2, bathrooms: 1,
  shared_spaces: "Kitchenette",
  amenities: [wifi]
)

puts "Creating listings..."
l0 = Listing.create!(
  property: p0, monthly_rent: 950.00, deposit: 950.00,
  available_date: Date.today + 10, minimum_stay: 6, furnished: true,
  private_bathroom: false, state: "published",
  description: "Bright room with a shared rooftop terrace, five minutes from the TransMilenio.",
  house_rules: "No smoking indoors. Quiet hours after 10pm."
)

l1 = Listing.create!(
  property: p0, monthly_rent: 1050.00, deposit: 1050.00,
  available_date: Date.today + 20, minimum_stay: 12, furnished: true,
  private_bathroom: true, state: "published",
  description: "Quiet room with a private bathroom, ideal for remote workers.",
  house_rules: "Guests must be announced in advance. Shared kitchen cleaned after use."
)

l2 = Listing.create!(
  property: p1, monthly_rent: 1200.00, deposit: 1200.00,
  available_date: Date.today + 5, minimum_stay: 3, furnished: false,
  private_bathroom: false, state: "published",
  description: "Spacious unfurnished room in a pet-friendly apartment."
)

l3 = Listing.create!(
  property: p2, monthly_rent: 800.00, deposit: 400.00,
  available_date: Date.today + 15, minimum_stay: 6, furnished: true,
  private_bathroom: false, state: "published",
  description: "Cozy room in a shared house with a garden."
)

l4 = Listing.create!(
  property: p2, monthly_rent: 850.00, deposit: 425.00,
  available_date: Date.today + 30, minimum_stay: 6, furnished: true,
  private_bathroom: true, state: "published",
  description: "Room with a private bathroom in the same shared house."
)

l5 = Listing.create!(
  property: p3, monthly_rent: 700.00, deposit: 350.00,
  available_date: Date.today + 30, minimum_stay: nil, furnished: false,
  private_bathroom: false, state: "draft",
  description: "Studio-style room, still being prepared for publication."
)

l6 = Listing.create!(
  property: p3, monthly_rent: 650.00, deposit: 325.00,
  available_date: Date.today + 1, minimum_stay: 1, furnished: true,
  private_bathroom: false, state: "published",
  description: "Small room near the center, previously listed."
)

puts "Creating applications and visits..."

# l0: a plain pending application, untouched -- the simplest case.
Application.create!(
  listing: l0, seeker: diego, move_in_date: Date.today + 14,
  duration_months: 8, message: "Hi! I'm a quiet grad student looking for a long-term room.",
  state: "pending"
)

# l0: an application the seeker thinks better of and withdraws herself,
# exercising Application#withdraw!.
sara_app_l0 = Application.create!(
  listing: l0, seeker: sara, move_in_date: Date.today + 20,
  duration_months: 6, message: "Looking forward to hearing back from you.",
  state: "pending"
)
sara_app_l0.withdraw!

# l1: a full happy path -- shortlisted, visited, confirmed, completed,
# then reviewed. Exercises Application#shortlist! and Visit#confirm!/#complete!.
app_valentina = Application.create!(
  listing: l1, seeker: valentina, move_in_date: Date.today + 25,
  duration_months: 12, message: "I work from home and would love to see the space.",
  state: "pending"
)
app_valentina.shortlist!
visit_valentina = Visit.create!(application: app_valentina, proposed_date: 3.days.from_now, status: "scheduled")
visit_valentina.confirm!
visit_valentina.complete!

Review.create!(property: p0, seeker: valentina, rating: 4, comment: "Great location near Chapinero, a bit noisy on weekends.")

# l2: another plain pending application, on a different host's property.
Application.create!(
  listing: l2, seeker: mateo, move_in_date: Date.today + 7,
  duration_months: 3, message: "Short-term stay while I finish an internship.",
  state: "pending"
)

# l3: the acceptance showcase. Two applicants; accepting one must reject
# the other and reserve the listing, all inside Application#accept!.
app_diego_l3 = Application.create!(
  listing: l3, seeker: diego, move_in_date: Date.today + 15,
  duration_months: 6, message: "Already visited and loved the garden!",
  state: "pending"
)
app_diego_l3.shortlist!
Visit.create!(application: app_diego_l3, proposed_date: 20.days.ago, status: "completed")

app_valentina_l3 = Application.create!(
  listing: l3, seeker: valentina, move_in_date: Date.today + 15,
  duration_months: 6, message: "Interested in the shared house.",
  state: "pending"
)

app_diego_l3.accept! # -> app_diego_l3 accepted, app_valentina_l3 auto-rejected, l3 reserved

# l4: the full lifecycle to "rented". Exercises Listing#mark_rented!.
app_mateo_l4 = Application.create!(
  listing: l4, seeker: mateo, move_in_date: Date.today - 60,
  duration_months: 6, message: "This was my application before moving in.",
  state: "pending"
)
app_mateo_l4.shortlist!
Visit.create!(application: app_mateo_l4, proposed_date: 65.days.ago, status: "completed")
app_mateo_l4.accept!
l4.mark_rented!

Review.create!(property: p2, seeker: diego, rating: 5, comment: "Exactly as described -- spacious, quiet, and the host was very responsive.")
Review.create!(property: p2, seeker: mateo, rating: 5, comment: "Perfect experience from application to move-in.")

# l6: the withdrawal showcase. Withdrawing a listing must also withdraw
# its pending/shortlisted applications, inside Listing#withdraw!.
Application.create!(
  listing: l6, seeker: sara, move_in_date: Date.today + 1,
  duration_months: 1, message: "Interested in this one too.",
  state: "pending"
)
l6.withdraw! # -> l6 withdrawn, sara's application auto-withdrawn

# l5 stays a draft with no applications -- draft listings can't receive any.

puts "Creating saved listings..."
SavedListing.create!(user: sara, listing: l0)
SavedListing.create!(user: sara, listing: l2)

puts "Creating reports..."
Report.create!(
  reporter: diego, listing: l6, reason: "misleading",
  details: "Listing stayed up after the host said it was no longer available.",
  status: "pending"
)
Report.create!(
  reporter: valentina, listing: l2, reason: "offensive",
  details: "Comment in the description seemed inappropriate.",
  status: "dismissed"
)

puts "Seed data created:"
puts "  Users: #{User.count} (#{User.where(role: 'moderator').count} moderator, #{User.where(role: 'member').count} members)"
puts "  Neighborhoods: #{Neighborhood.count}"
puts "  Amenities: #{Amenity.count}"
puts "  Properties: #{Property.count}"
puts "  Listings: #{Listing.count} (#{Listing.published.count} published)"
puts "  Applications: #{Application.count}"
puts "  Visits: #{Visit.count}"
puts "  Reviews: #{Review.count}"
puts "  Saved listings: #{SavedListing.count}"
puts "  Reports: #{Report.count}"