# License mapping
class LicenseMapping < ActiveRecord::Base
  belongs_to :mappable, polymorphic: true
end
