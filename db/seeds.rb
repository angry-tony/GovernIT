#encoding: utf-8


	# Carga los roles del sistema:
	roles = Role.create([
	{name: ROLE_USER_GOV, description: 'Access to the IT Governance Module as an user (limited access per enterprise)'},
	{name: ROLE_USER_CONFIG, description: 'Access to the Configuration Module as an user (limited access per enterprise)'},
	{name: ROLE_EVAL, description: 'Access to all the modules as an evaluator'},
	{name: ROLE_ADMIN, description: 'Ilimited access'}
	])


	# Crea un usuario administrador inicial:
	sysAdmin = Role.where(name: ROLE_ADMIN).first

	generated_password = Devise.friendly_token.first(8)

	user = User.new
	user.email = '[YOUR_ADMIN_MAIL_HERE]'
	user.password = generated_password

	user.roles = [sysAdmin]
	user.activo = true


	user.save





# ========================================== DATABASE: DECISION MAPS ===========================

Mapas::Engine.load_seed

# ========================================== DATABASE: DECISION MAPS ===========================





# ========================================== DATABASE: ASSESSMENT SCENARIOS ===========================

Escenarios::Engine.load_seed

# ========================================== DATABASE: ASSESSMENT SCENARIOS ===========================
