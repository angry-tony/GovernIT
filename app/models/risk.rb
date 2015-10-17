class Risk < ActiveRecord::Base
	belongs_to :risk_category, inverse_of: :risk, foreign_key: "risk_category_id"
end
