class ApplicationsMailer < ApplicationMailer
  def new_application(application)
    @application = application
    @listing = application.listing
    @host = @listing.property.host

    mail subject: "New application for your listing", to: @host.email
  end
end