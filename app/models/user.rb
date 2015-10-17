class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :enterprise, foreign_key: "enterprise_id"
  has_and_belongs_to_many :roles


  def has_role?(role_name)
  	roles.any? { |r| r.name == role_name }
  end

end
