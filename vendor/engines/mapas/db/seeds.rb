#encoding: utf-8


# ES: Carga de las decisiones genericas en el sistema:
# EN: Load the generic decisions in the system:

governanceDecisions = Mapas::GovernanceDecision.create([
{description: 'Which one is the desirable Operational Model of the organization?', decision_type: 'GENERIC', dimension: 'Principios de TI'},
{description: 'How IT will support the Operational Model?', decision_type: 'GENERIC', dimension: 'Principios de TI'},
{description: 'Define the desirable behavior of IT in the business, of the IT professionals and users', decision_type: 'GENERIC', dimension: 'Principios de TI'},
{description: 'How IT will be financed?', decision_type: 'GENERIC', dimension: 'Principios de TI'},
{description: 'Define and educate executives about IT strategy', decision_type: 'GENERIC', dimension: 'Principios de TI'},
{description: 'Define principles for each architectural domain', decision_type: 'GENERIC', dimension: 'Arquitectura de TI'},
{description: 'Define and guarantee the logical organization of data, applications and infrastructure', decision_type: 'GENERIC', dimension: 'Arquitectura de TI'},
{description: 'Define politics, relationships and technical options in order to reach the desired standarization and integration of business and IT', decision_type: 'GENERIC', dimension: 'Arquitectura de TI'},
{description: 'Which processes should be supported with IT?', decision_type: 'GENERIC', dimension: 'Arquitectura de TI'},
{description: 'What information guides this processes and how it should be integrated?', decision_type: 'GENERIC', dimension: 'Arquitectura de TI'},
{description: 'What technical capacities should be standardized across the organization to support IT efficiently and to facilitate the process standardization and integration?', decision_type: 'GENERIC', dimension: 'Arquitectura de TI'},
{description: 'What activities should be standardized across the organization?', decision_type: 'GENERIC', dimension: 'Arquitectura de TI'},
{description: 'What technological elections will guide the way the organization attacks IT initiatives?', decision_type: 'GENERIC', dimension: 'Arquitectura de TI'},
{description: 'What infrastructure services are critical to achieve the organization"s strategic goals?', decision_type: 'GENERIC', dimension: 'Infraestructura'},
{description: 'What infrastructure services should be implemented across the organization and what service levels it requires?', decision_type: 'GENERIC', dimension: 'Infraestructura'},
{description: 'What should be the cost structure of the infrastructure services?', decision_type: 'GENERIC', dimension: 'Infraestructura'},
{description: 'What is the updating plan of the technological infrastructure?', decision_type: 'GENERIC', dimension: 'Infraestructura'},
{description: 'What infrastructure services should be outsourced?', decision_type: 'GENERIC', dimension: 'Infraestructura'},
{description: 'Specify the applications" needs to buy or development?', decision_type: 'GENERIC', dimension: 'Aplicaciones de TI'},
{description: 'Coordinate IT demand/portfolio', decision_type: 'GENERIC', dimension: 'Aplicaciones de TI'},
{description: 'Training and education', decision_type: 'GENERIC', dimension: 'Aplicaciones de TI'},
{description: 'Change management', decision_type: 'GENERIC', dimension: 'Aplicaciones de TI'},
{description: 'What are the market and business opportunities for new business applications?', decision_type: 'GENERIC', dimension: 'Aplicaciones de TI'},
{description: 'How will be the success" assessment of experiments/applications?', decision_type: 'GENERIC', dimension: 'Aplicaciones de TI'},
{description: 'How will be the relevance"s assessment of an architectural exception?', decision_type: 'GENERIC', dimension: 'Aplicaciones de TI'},
{description: 'Who is the owner of each project"s results?', decision_type: 'GENERIC', dimension: 'Aplicaciones de TI'},
{description: 'Who is in charge of implementing the required change management to guarantee value?', decision_type: 'GENERIC', dimension: 'Aplicaciones de TI'},
{description: 'Choose initiatives to be financed', decision_type: 'GENERIC', dimension: 'Inversión y Priorización'},
{description: 'Define criteria to reconcile different local and global IT investment needs', decision_type: 'GENERIC', dimension: 'Inversión y Priorización'},
{description: 'What are the strategic processes" changes or improvements for the organization?', decision_type: 'GENERIC', dimension: 'Inversión y Priorización'},
{description: 'What is the AS-IS and TO-BE IT portfolio distribution? Are these portfolios consistent with the organization"s strategic goals?', decision_type: 'GENERIC', dimension: 'Inversión y Priorización'},
{description: 'What is the relative importance of transversal investments against local investments? Is this importance reflected on current investment practices?', decision_type: 'GENERIC', dimension: 'Inversión y Priorización'}
])



# ES: Carga los arquetipos de toma de decisiones:
# EN: Load the decision-take archetypes:
governanceArchetypes = Mapas::DecisionArchetype.create([
{name: 'Business Monarchy', description: "A group of, or individual, business executives (CxO's)"},
{name: 'IT Monarchy', description: "Individuals or groups of IT executives"},
{name: 'Federal', description: "Shared by C level executives and all the business groups (i.e CxO's and BU leaders)"},
{name: 'IT Duopoly', description: "IT executives and one other group (e.g CxO's or BU leaders)"},
{name: 'Feudal', description: "Business unit leaders, key process owners or their delegates"},
{name: 'Anarchy', description: "Individuals"}
])

# ES: Carga los 2 responsables (estructuras de gobierno) ficticias, para modelar los valores: "No aplica" y "No existe"
# EN: Load the 2 fake responsibles (governance structures), to modelate the values: "Not Available" and "Not Exists"  

# ES: Español:
if I18n.default_locale.to_s.eql?("es")
	resps = GovernanceStructure.create([
	{name: 'No aplica', structure_type: ROL, enterprise_id: 0, global_type: GENERIC_TYPE, profile: PERFIL_EST_9},
	{name: 'No existe', structure_type: ROL, enterprise_id: 0, global_type: GENERIC_TYPE, profile: PERFIL_EST_9}
	])
# EN: English:
elsif I18n.default_locale.to_s.eql?("en")
	resps = GovernanceStructure.create([
	{name: 'Not available', structure_type: ROL, enterprise_id: 0, global_type: GENERIC_TYPE, profile: PERFIL_EST_9},
	{name: 'Non-Existent', structure_type: ROL, enterprise_id: 0, global_type: GENERIC_TYPE, profile: PERFIL_EST_9}
	])
end


