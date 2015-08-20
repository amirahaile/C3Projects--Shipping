class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token # according to HTTParty


  # shippers
  USPS = ActiveShipping::USPS.new(:login => ENV["ACTIVESHIPPING_USPS_LOGIN"])

  # TODO: Add :shipper
  def prepare
    info = JSON.parse(request.body.read)
    merchant = info["merchant"]
    buyer = info["buyer"]
    products = info["products"] # hash with number keys

    origin = ActiveShipping::Location.new(
      :country => 'US',
      :state => merchant["state"],
      :city => merchant["city"],
      :zip => merchant["zip"]
    )

    destination = ActiveShipping::Location.new(
      :country => 'US',
      :state => buyer["state"],
      :city => buyer["city"],
      :zip => buyer["zip"]
    )

    packages = []
    products.each do |key, parcel|
      package = ActiveShipping::Package.new(
        parcel["weight"],
        [parcel["width"], parcel["height"], parcel["length"]],
        :units => :imperial
      )

      packages << package
    end

    response = USPS.find_rates(origin, destination, packages)
    services = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    # # for our records
    # # Request.new(origin: origin.to_s, destination: destination.to_s)
    render json: services
    # request_info
  end

  def request_info
  #   # Error: 'undefined method `content_mime_type' for nil:NilClass'
  #   # make the HTTP request
  end
  #
  # def parse
  #   # parse the response
  #   # return parsed response
  #   # render json: blahblah
  # end
end
