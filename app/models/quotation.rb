class Quotation < ActiveRecord::Base
  belongs_to :author
  belongs_to :notecard
end
