class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  #
  # # shippers
  # USPS = ActiveShipping::USPS.new(:login => ENV["ACTIVESHIPPING_USPS_LOGIN"])
  #
  # # TODO: Add :shipper
  def prepare
    # response = response.body
    # merchant = response["merchant"]
    # buyer = response["buyer"]
    # parcels = response["packages"] # hash with number keys

    origin = ActiveShipping::Location.new(
      :country => 'US',
      # :state => merchant["state"],
      # :city => merchant["city"],
      # :zip => merchant["zip"]
    )

    destination = ActiveShipping::Location.new(
      :country => 'US',
      # :state => buyer[:shipping_state],
      # :city => buyer[:shipping_city],
      # :zip => buyer[:shipping_zip]
    )

    packages = []
    # parcels.each do |number, parcel|
    #   package = ActiveShipping::Package.new(
    #     parcel["weight"],
    #     [parcel["width"], parcel["height"], parcel["length"]],
    #     :units => :imperial
    #   )
    #
    #   packages << package
    # end

    # for our records
    # Request.new(origin: origin.to_s, destination: destination.to_s)

    request_info
  end

  def request_info
  #   # Error: 'undefined method `content_mime_type' for nil:NilClass'
  #   # make the HTTP request
    render :index
  end
  #
  # def parse
  #   # parse the response
  #   # return parsed response
  #   # render json: blahblah
  # end
end
