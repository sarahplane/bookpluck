class Theming < ActiveRecord::Base
  belongs_to :notecard
  belongs_to :theme
end
