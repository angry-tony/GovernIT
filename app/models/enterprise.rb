class Enterprise < ActiveRecord::Base
	has_many :governance_decisions
    has_many :specific_risks, class_name: "Risk", inverse_of: :enterprise
	has_many :governance_structures
	has_many :users
	has_one :configuracion, inverse_of: :enterprise, class_name: "Configuracion"

	has_attached_file :logo, 
	:path => "public/system/logos/:id/:filename"

	#validates_attachment :logo,
  	#:content_type => { :content_type => ["image/jpeg", "image/png", "image/jpg"] }

end
