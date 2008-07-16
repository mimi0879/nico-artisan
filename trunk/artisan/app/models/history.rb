class History < ActiveRecord::Base
  belongs_to :art
  belongs_to :comment
end
