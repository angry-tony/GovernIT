module Mapas
  class ComplementaryMechanism < ActiveRecord::Base
  	belongs_to :enterprise, class_name: "Enterprise", foreign_key: "enterprise_id"
  end
end
