import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "results"]

  async search(event) {
    event.preventDefault()

    const formData = new FormData(this.formTarget)
    const params = new URLSearchParams()
    for (const [key, value] of formData.entries()) {
      if (value) params.append(key, value)
    }

    const response = await fetch(`/api/v1/listings?${params.toString()}`, {
      headers: { "Accept": "application/json" }
    })

    if (!response.ok) {
      this.resultsTarget.innerHTML = `<p class="text-danger">Something went wrong loading listings.</p>`
      return
    }

    const data = await response.json()
    this.render(data.listings)

    const url = new URL(window.location)
    url.search = params.toString()
    window.history.pushState({}, "", url)
  }

  render(listings) {
    if (listings.length === 0) {
      this.resultsTarget.innerHTML = `<p class="text-muted">No listings match your search. Try adjusting your filters.</p>`
      return
    }

    this.resultsTarget.innerHTML = `
      <div class="row g-3">
        ${listings.map((listing) => this.cardHtml(listing)).join("")}
      </div>
    `
  }

  cardHtml(listing) {
    const photo = listing.photo_urls[0]
    const availableDate = new Date(`${listing.available_date}T00:00:00`)
      .toLocaleDateString("en-US", { month: "short", day: "numeric", year: "numeric" })

    return `
      <div class="col-md-4">
        <div class="card h-100">
          ${photo ? `<img src="${this.escape(photo)}" class="card-img-top">` : ""}
          <div class="card-body">
            <h5 class="card-title">${this.escape(listing.property.neighborhood)} &bull; ${this.escape(this.capitalize(listing.property.property_type))}</h5>
            <p class="card-text text-muted mb-1">
              $${Math.trunc(listing.monthly_rent).toLocaleString("en-US")}/month
              &bull; ${listing.property.bedrooms} Bed, ${listing.property.bathrooms} Bath
            </p>
            <p class="card-text text-muted mb-1">
              Available ${availableDate}
              ${listing.furnished ? " &bull; Furnished" : ""}
              ${listing.private_bathroom ? " &bull; Private bathroom" : ""}
            </p>
            <a href="/listings/${listing.id}" class="btn btn-sm btn-outline-secondary mt-2">View Details</a>
          </div>
        </div>
      </div>
    `
  }

  capitalize(word) {
    return word.charAt(0).toUpperCase() + word.slice(1)
  }

  escape(value) {
    const div = document.createElement("div")
    div.textContent = value
    return div.innerHTML
  }
}