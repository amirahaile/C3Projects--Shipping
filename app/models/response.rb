class Response < ActiveRecord::Base
# Associations -----------------------------------------------------------------
  belongs_to :request
  has_many   :services
end
