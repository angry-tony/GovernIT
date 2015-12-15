#encoding: utf-8


# ========================================== DATABASE: DECISION MAPS ===========================

puts 'Engine: Maps (1/2) - Loading seed data...'

Mapas::Engine.load_seed

puts 'Engine: Maps (1/2) - Seed data loaded: 100%'

# ========================================== DATABASE: DECISION MAPS ===========================





# ========================================== DATABASE: ASSESSMENT SCENARIOS ===========================

puts 'Engine: Scenarios (2/2) - Loading seed data...'

Escenarios::Engine.load_seed

puts 'Engine: Scenarios (2/2) - Seed data loaded: 100%'

# ========================================== DATABASE: ASSESSMENT SCENARIOS ===========================

# Creates a dummy enterprise:

dummyEnt = Enterprise.new
dummyEnt.name = 'Test Enterprise'
dummyEnt.description = 'Initial enterprise able to support all functionalities of the software.'
dummyEnt.save


puts '----- Seed data loaded successfully! -----'