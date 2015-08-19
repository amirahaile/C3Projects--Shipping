class Request < ActiveRecord::Base
  has_many :packages
  has_one :response
end
