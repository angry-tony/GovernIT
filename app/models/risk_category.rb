class RiskCategory < ActiveRecord::Base
	has_one :risk, inverse_of: :risk_category
end
