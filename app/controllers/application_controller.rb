class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # shippers
  USPS = ActiveShipping::USPS.new(:login => ENV['ACTIVESHIPPING_USPS_LOGIN'])

  def prepare(merchant, buyer, parcels)
    origin = ActiveShipping::Location.new(
      :country => 'US',
      :state => merchant[:state],
      :city => merchant[:city],
      :zip => merchant[:zip]
    )

    destination = ActiveShipping::Location.new(
      :country => 'US',
      :state => buyer[:shipping_state],
      :city => buyer[:shipping_city],
      :zip => buyer[:shipping_zip]
    )

    packages = []
    our_record = []
    # parcels is an array of Products from the OrderItem objects
    parcels.each do |parcel|
      # to make the request
      package = ActiveShipping::Package.new(
        parcel.weight,
        [parcel.width, parcel.height, parcel.length],
        :units => :imperial
      )

      packages << package
    end

    # for our records
    request = Request.new(origin, destination)
    parcel.each do |parcel|
      request.packages << parcel
    end

    redirect_to request_path(origin, destination, packages)
  end

  def request(origin, destination, packages)
    # make the HTTP request
  end

  def parse(request)
    # parse the response
    # return parsed response
    # render json: blahblah
  end
end
