class Response < ActiveRecord::Base
  belongs_to :request
  has_many :services
end
