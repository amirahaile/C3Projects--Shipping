class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token # according to HTTParty


  # shippers
  USPS = ActiveShipping::USPS.new(:login => ENV["ACTIVESHIPPING_USPS_LOGIN"])
  UPS = ActiveShipping::UPS.new(
    :login => ENV['ACTIVESHIPPING_UPS_LOGIN'],
    :password => ENV['ACTIVESHIPPING_UPS_PASSWORD'],
    :key => ENV['ACTIVESHIPPING_UPS_KEY'],
    :origin_name => ENV['ACTIVESHIPPING_UPS_ORIGIN_NAME'],
    :origin_account => ENV['ACTIVESHIPPING_UPS_ORIGIN_ACCOUNT']
  )

  def prepare
    info = JSON.parse(request.body.read)
    shipper = info["shipper"]
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

    if shipper == 'usps'
      response = USPS.find_rates(origin, destination, packages)
      delivery = nil # USPS API doesn't offer delivery information
    elsif shipper == 'ups'
      response = UPS.find_rates(origin, destination, packages)
      delivery = response.params["RatedShipment"].map { |package| [package["GuaranteedDaysToDelivery"], package["ScheduledDeliveryTime"]] }
    end

    services = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}

    # for our records
    req = Request.create(
      origin: origin.to_s,
      destination: destination.to_s,
      shipper: params[:shipper]
    )
    res = Response.create
    res.update(request_id: req.id) # create association between request & response

    services.each_with_index do |service, index|
      res.services << Service.create(
        name: service[0],
        rate: service[1],
        delivery_days: delivery.nil? ? nil : delivery[index][0],
        delivery_time: delivery.nil? ? nil : delivery[index][1]
      )
    end

    render json: { services: services, delivery: delivery }.to_json
  end
end
