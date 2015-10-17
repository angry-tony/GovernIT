class Configuracion < ActiveRecord::Base
	belongs_to :enterprise, inverse_of: :configuracion, foreign_key: "enterprise_id"
end
