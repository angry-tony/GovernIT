#encoding: utf-8

# ES: Carga los riesgos genericos:
# (Aunque debe verificar si no estan cargados ya, mediante la existencia de las categorias de riesgo)

# EN: Load the generic risks:
# (Although it must verify if those risks are not loaded already, through the risk categories existence)


RiskCategory.all.size > 0 ? cargados = true : false

if !cargados

	if I18n.default_locale.to_s.eql?("en")
    	risksG = Risk.create([
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 4, descripcion: "Incorrect programmes selected for implementation and misaligned with corporate strategy and priorities."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 4, descripcion: "Duplication among different initiatives."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 4, descripcion: "New and important programme creates long-term incompatibility with the enterprise architecture."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 5, descripcion: "Failure to adopt and exploit new technologies (i.e.,functionality, optimisation) in a timely manner."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 5, descripcion: "New and important technology trends not identified."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 5, descripcion: "Inability to use technology to realise desired outcomes (e.g., failure to make required business model or organisational changes)."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 6, descripcion: "Business managers or representatives not involved in important IT investment decision making regarding new applications, prioritisation or new technology opportunities."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 7, descripcion: "Business not assuming accountability over those IT areas it should such as functional requirements, development priorities and assessing opportunities through new technologies."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 8, descripcion: "Projects that are failing due to cost, delays, scope creep or changed business priorities not terminated in a timely manner."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 9, descripcion: "Isolated IT project budget overrun."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 9, descripcion: "Consistent and important IT projects budget overruns."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 9, descripcion: "Absence of view on portfolio and project economics."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 10, descripcion: "Complex and inflexible IT architecture obstructing further evolution and expansion."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 11, descripcion: "Extensive dependency and use of end-user computing and ad hoc solutions for important information needs."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 11, descripcion: "Separate and non-integrated IT solutions to support business processes."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 12, descripcion: "Operational glitches when new software is made operational."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 12, descripcion: "Users not prepared to use and exploit new application software."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 13, descripcion: "Occasional late IT project delivery by internal development department."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 13, descripcion: "Routinely important delays in IT project delivery."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 13, descripcion: "Excessive delays in outsourced IT development project."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 14, descripcion: "Insufficient quality of project deliverables due to software, documentation or compliance with functional requirements."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 15, descripcion: "Obsolete IT technology cannot satisfy new business requirements such as networking, security and storage."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 16, descripcion: "Application software that is old, poorly documented, expensive to maintain, difficult to extend or not integrated in current architecture."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 17, descripcion: "Non-compliance with regulations of accounting or manufacturing."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 18, descripcion: "Inadequate support and services delivered by vendors, not in line with SLAs."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 18, descripcion: "Inadequate performance of outsourcer in large-scale, long-term outsourcing arrangement."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 19, descripcion: "Theft of laptop with sensitive data."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 19, descripcion: "Theft of a substantial number of development servers."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 20, descripcion: "Destruction of data centre due to sabotage or other causes."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 20, descripcion: "Accidental destruction of individual laptops."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 21, descripcion: "Departure or extended unavailability of key IT staff."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 21, descripcion: "Key development team leaving the enterprise."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 21, descripcion: "Inability to recruit IT staff."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 22, descripcion: "Lack or mismatch of IT-related skills within IT due to new technologies or other causes."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 22, descripcion: "Lack of business understanding by IT staff."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 23, descripcion: "Intentional modification of software leading to wrong data or fraudulent actions."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 23, descripcion: "Unintentional modification of software leading to unexpected results."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 23, descripcion: "Unintentional configuration and change management errors."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 24, descripcion: "Misconfiguration of hardware components."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 24, descripcion: "Damage of critical servers in the computer room due to accident or other causes."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 24, descripcion: "Intentional tampering with hardware such as security devices."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 25, descripcion: "Regular software malfunctioning of critical application software."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 25, descripcion: "Intermittent performance problems with important system software."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 26, descripcion: "Inability of systems to handle transaction volumes when user volumes increase."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 26, descripcion: "Inability of systems to handle system load when new applications or initiatives are deployed."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 27, descripcion: "Use of unsupported versions of operating system software."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 27, descripcion: "Use of old database system."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 28, descripcion: "Intrusion of malware on critical operational servers."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 28, descripcion: "Regular infection of laptops with malware."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 29, descripcion: "Virus attack"},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 29, descripcion: "Unauthorised users trying to break into systems."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 29, descripcion: "Denial-of-service attack"},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 29, descripcion: "Web site defacing."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 29, descripcion: "Industrial espionage."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 30, descripcion: "Loss of backup media."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 30, descripcion: "Loss/disclosure of portable media (e.g., CD, universal serial bus [USB] drives, portable disks) containing sensitive data."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 30, descripcion: "Accidental disclosure of sensitive information due to failure to follow information handling guidelines."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 31, descripcion: "Intermittent utilities (e.g., telecom, electricity) failure."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 31, descripcion: "Regular, extended utilities failures."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 32, descripcion: "Inaccessible facilities and building due to labour union strike."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 32, descripcion: "Unavailable key staff due to industrial action."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 33, descripcion: "Intentional modification of data (e.g., accounting, security-related data, sales figures)."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 33, descripcion: "Database (e.g., client or transactions database) corruption."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 34, descripcion: "Users circumventing logical access rights."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 34, descripcion: "Users obtaining access to unauthorised information."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 34, descripcion: "Users stealing sensitive data."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 35, descripcion: "Operator errors during backup, upgrades of systems or maintenance of systems."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 35, descripcion: "Incorrect information input."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 36, descripcion: "Non-compliance with software licence agreements (e.g., use and/or distribution of unlicenced software)."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 36, descripcion: "Contractual obligations as service provider with customers/clients not met."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 37, descripcion: "Use of equipment that is not environmentally friendly (e.g., high level of power consumption, packaging)."},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 38, descripcion: "Earthquake"},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 38, descripcion: "Tsunami"},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 38, descripcion: "Major storm/hurricane"},
		{nivel: RISK_TYPE_GENERIC, risk_category_id: 38, descripcion: "Major wildfire"}
		])
    end

		

	# ES: Carga las categorias y escenarios de riesgo genericos:
	# EN: Load the categories and generic risk scenarios:
	categories = RiskCategory.create([
	{description: 'Benefit/value enablement risk'},
	{description: 'Programme/project delivery risk'},
	{description: 'Service delivery/IT operations risk'}
	])

	escenarios = RiskCategory.create([
	{description: 'IT programme selection', id_padre: 1},
	{description: 'New technologies', id_padre: 1},
	{description: 'IT investment decision making', id_padre: 1},
	{description: 'Accountability over IT', id_padre: 1},
	{description: 'IT project termination', id_padre: 1},
	{description: 'IT project economics', id_padre: 1},
	{description: 'Architectural agility and flexibility', id_padre: 2},
	{description: 'Integration of IT within business processes', id_padre: 2},
	{description: 'Software implementation', id_padre: 2},
	{description: 'Project delivery', id_padre: 2},
	{description: 'Project quality', id_padre: 2},
	{description: 'State of infrastructure technology', id_padre: 3},
	{description: 'Ageing of application software', id_padre: 3},
	{description: 'Regulatory compliance', id_padre: 3},
	{description: 'Selection/performance of third-party suppliers', id_padre: 3},
	{description: 'Infrastructure theft', id_padre: 3},
	{description: 'Destruction of infrastructure', id_padre: 3},
	{description: 'IT staff', id_padre: 3},
	{description: 'IT expertise and skills', id_padre: 3},
	{description: 'Software integrity', id_padre: 3},
	{description: 'Infrastructure (hardware)', id_padre: 3},
	{description: 'Software performance', id_padre: 3},
	{description: 'System capacity', id_padre: 3},
	{description: 'Ageing of infrastructural software', id_padre: 3},
	{description: 'Malware', id_padre: 3},
	{description: 'Logical attacks', id_padre: 3},
	{description: 'Information media', id_padre: 3},
	{description: 'Utilities performance', id_padre: 3},
	{description: 'Industrial action', id_padre: 3},
	{description: 'Data(base) integrity', id_padre: 3},
	{description: 'Logical trespassing', id_padre: 3},
	{description: 'Operational IT errors', id_padre: 3},
	{description: 'Contractual compliance', id_padre: 3},
	{description: 'Environmental', id_padre: 3},
	{description: 'Acts of nature', id_padre: 3}
	])

end




# ES: Carga los objetivos de negocio:
# EN: Load the business goals:

bGoals = Escenarios::Goal.create([
{description: 'Stakeholder value of business investments', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: FINANCIAL},
{description: 'Portfolio of competitive products and services', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: FINANCIAL},
{description: 'Managed business risk (safeguarding of assets)', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: FINANCIAL},
{description: 'Compliance with external laws and regulations', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: FINANCIAL},
{description: 'Financial transparency', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: FINANCIAL},
{description: 'Customer-oriented service culture', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: CUSTOMER},
{description: 'Business service continuity and availability', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: CUSTOMER},
{description: 'Agile responses to a changing business environment', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: CUSTOMER},
{description: 'Information-based strategic decision making', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: CUSTOMER},
{description: 'Optimisation of service delivery costs', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: CUSTOMER},
{description: 'Optimisation of business process functionality', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: INTERNAL},
{description: 'Optimisation of business process costs', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: INTERNAL},
{description: 'Managed business change programmes', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: INTERNAL},
{description: 'Operational and staff productivity', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: INTERNAL},
{description: 'Compliance with internal policies', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: INTERNAL},
{description: 'Skilled and motivated people', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: L_AND_G},
{description: 'Product and business innovation culture', goal_type: GENERIC_TYPE, scope: B_GOAL, dimension: L_AND_G}
])

# ES: Carga los objetivos de TI:
# EN: Load the IT goals:

ITGoals = Escenarios::Goal.create([
{description: 'Alignment of IT and business strategy', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: FINANCIAL},
{description: 'IT compliance and support for business compliance with external laws and regulations', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: FINANCIAL},
{description: 'Commitment of executive management for making IT-related decisions', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: FINANCIAL},
{description: 'Managed IT-related business risk', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: FINANCIAL},
{description: 'Realised benefits from IT-enabled investments and services portfolio', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: FINANCIAL},
{description: 'Transparency of IT costs, benefits and risk', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: FINANCIAL},
{description: 'Delivery of IT services in line with business requirements', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: CUSTOMER},
{description: 'Adequate use of applications, information and technology solutions', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: CUSTOMER},
{description: 'IT agility', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: INTERNAL},
{description: 'Security of information, processing infrastructure and applications', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: INTERNAL},
{description: 'Optimisation of IT assets, resources and capabilities', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: INTERNAL},
{description: 'Enablement and support of business processes by integrating applications and technology into business processes', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension:INTERNAL },
{description: 'Delivery of programmes delivering benefits, on time, on budget, and meeting requirements and quality standards', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: INTERNAL},
{description: 'Availability of reliable and useful information for decision making', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: INTERNAL},
{description: 'IT compliance with internal policies', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: INTERNAL},
{description: 'Competent and motivated business and IT personnel', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: L_AND_G},
{description: 'Knowledge, expertise and initiatives for business innovation', goal_type: GENERIC_TYPE, scope: IT_GOAL, dimension: L_AND_G}
])

# ES: Carga los procesos de TI:
# EN: Load the IT Processes

myProcs =  Escenarios::ItProcess.create([
{description: 'Ensure Governance Framework Setting and Maintenance', domain: PROCESS_D_EDM, fuente: COBIT, id_fuente: 'EDM01'},
{description: 'Ensure Benefits Delivery', domain: PROCESS_D_EDM, fuente: COBIT, id_fuente: 'EDM02'},
{description: 'Ensure Risk Optimisation', domain: PROCESS_D_EDM, fuente: COBIT, id_fuente: 'EDM03'},
{description: 'Ensure Resource Optimisation', domain: PROCESS_D_EDM, fuente: COBIT, id_fuente: 'EDM04'},
{description: 'Ensure Stakeholder Transparency', domain: PROCESS_D_EDM, fuente: COBIT, id_fuente: 'EDM05'},
{description: 'Manage the IT Management Framework', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO01'},
{description: 'Manage Strategy', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO02'},
{description: 'Manage Enterprise Architecture', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO03'},
{description: 'Manage Innovation', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO04'},
{description: 'Manage Portfolio', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO05'},
{description: 'Manage Budget and Costs', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO06'},
{description: 'Manage Human Resources', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO07'},
{description: 'Manage Relationships', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO08'},
{description: 'Manage Service Agreements', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO09'},
{description: 'Manage Suppliers', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO10'},
{description: 'Manage Quality', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO11'},
{description: 'Manage Risk', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO12'},
{description: 'Manage Security', domain: PROCESS_D_APO, fuente: COBIT, id_fuente: 'APO13'},
{description: 'Manage Programmes and Projects', domain: PROCESS_D_BAI, fuente: COBIT, id_fuente: 'BAI01'},
{description: 'Manage Requirements Definition', domain: PROCESS_D_BAI, fuente: COBIT, id_fuente: 'BAI02'},
{description: 'Manage Solutions Identification and Build', domain: PROCESS_D_BAI, fuente: COBIT, id_fuente: 'BAI03'},
{description: 'Manage Availability and Capacity', domain: PROCESS_D_BAI, fuente: COBIT, id_fuente: 'BAI04'},
{description: 'Manage Organizational Change Enablement', domain: PROCESS_D_BAI, fuente: COBIT, id_fuente: 'BAI05'},
{description: 'Manage Changes', domain: PROCESS_D_BAI, fuente: COBIT, id_fuente: 'BAI06'},
{description: 'Manage Change Acceptance and Transitioning', domain: PROCESS_D_BAI, fuente: COBIT, id_fuente: 'BAI07'},
{description: 'Manage Knowledge', domain: PROCESS_D_BAI, fuente: COBIT, id_fuente: 'BAI08'},
{description: 'Manage Assets', domain: PROCESS_D_BAI, fuente: COBIT, id_fuente: 'BAI09'},
{description: 'Manage Configuration', domain: PROCESS_D_BAI, fuente: COBIT, id_fuente: 'BAI10'},
{description: 'Manage Operations', domain: PROCESS_D_DSS, fuente: COBIT, id_fuente: 'DSS01'},
{description: 'Manage Service Requests and Incidents', domain: PROCESS_D_DSS, fuente: COBIT, id_fuente: 'DSS02'},
{description: 'Manage Problems', domain: PROCESS_D_DSS, fuente: COBIT, id_fuente: 'DSS03'},
{description: 'Manage Continuity', domain: PROCESS_D_DSS, fuente: COBIT, id_fuente: 'DSS04'},
{description: 'Manage Security Services', domain: PROCESS_D_DSS, fuente: COBIT, id_fuente: 'DSS05'},
{description: 'Manage Business Process Controls', domain: PROCESS_D_DSS, fuente: COBIT, id_fuente: 'DSS06'},
{description: 'Monitor, Evaluate and Assess Performance and Conformance', domain: PROCESS_D_MEA, fuente: COBIT, id_fuente: 'MEA01'},
{description: 'Monitor, Evaluate and Assess the System of Internal Control', domain: PROCESS_D_MEA, fuente: COBIT, id_fuente: 'MEA02'},
{description: 'Monitor, Evaluate and Assess Compliance with External Requirements', domain: PROCESS_D_MEA, fuente: COBIT, id_fuente: 'MEA03'}
])


# ES:
# Carga la matriz de relacion Riesgos VS Procesos:
# PRE: Las categorías de riesgo deben estar cargadas en orden:

# EN:
# Load the relationship matrix Risks VS Processes
# PRE: The risk categories must be previously loaded in the next order:

# 1: Benefit/value enablement risk
# 10: Architectural agility and flexibility
# 20: Destruction of infrastructure
# 30: Information media
# 38: Acts of nature

matrixRisks = Escenarios::RiskProcessMatrix.create([
{risk_category_id: 4,  related_processes: 'APO02|APO03|APO04|APO05|BAI01'},
{risk_category_id: 5,  related_processes: 'EDM04|APO02|APO03|APO04|BAI02|BAI03'},
{risk_category_id: 6,  related_processes: 'EDM02|APO02|APO03|APO05|APO06|APO08|BAI01'},
{risk_category_id: 7,  related_processes: 'EDM01|EDM02|EDM03|EDM04|EDM05|APO01|APO09|APO10|BAI05'},
{risk_category_id: 8,  related_processes: 'EDM01|EDM02|EDM04|BAI01|APO05|APO06|MEA01'},
{risk_category_id: 9,  related_processes: 'EDM01|EDM02|EDM04|APO06|BAI01'},
{risk_category_id: 10, related_processes: 'APO01|EDM04|APO02|APO03|APO04|APO05|BAI02|BAI03|APO13'},
{risk_category_id: 11, related_processes: 'EDM01|APO01|APO02|APO03|APO08|BAI02|BAI03|BAI05'},
{risk_category_id: 12, related_processes: 'APO11|BAI01|BAI02|BAI03|BAI05|BAI06|BAI07|BAI08'},
{risk_category_id: 13, related_processes: 'EDM01|EDM02|APO06|BAI01'},
{risk_category_id: 14, related_processes: 'APO03|APO11|BAI01'},
{risk_category_id: 15, related_processes: 'EDM04|APO02|APO03|APO04|BAI03|BAI04|BAI09'},
{risk_category_id: 16, related_processes: 'EDM04|APO02|APO03|APO04|BAI03|BAI09|DSS06'},
{risk_category_id: 17, related_processes: 'EDM01|APO01|APO02|BAI02|MEA03'},
{risk_category_id: 18, related_processes: 'APO10|BAI03'},
{risk_category_id: 19, related_processes: 'APO01|APO07|BAI03|DSS05'},
{risk_category_id: 20, related_processes: 'DSS01|DSS05'},
{risk_category_id: 21, related_processes: 'APO07|BAI08'},
{risk_category_id: 22, related_processes: 'APO07|BAI08'},
{risk_category_id: 23, related_processes: 'BAI02|BAI06|BAI07|BAI10|DSS05|DSS06'},
{risk_category_id: 24, related_processes: 'BAI03|BAI10|DSS05'},
{risk_category_id: 25, related_processes: 'BAI03|BAI04|DSS03'},
{risk_category_id: 26, related_processes: 'APO03|BAI03|BAI04'},
{risk_category_id: 27, related_processes: 'EDM04|APO02|APO03|APO04|BAI03|DSS08'},
{risk_category_id: 28, related_processes: 'APO01|DSS05'},
{risk_category_id: 29, related_processes: 'APO01|BAI03|DSS05'},
{risk_category_id: 30, related_processes: 'APO01|DSS05|DSS06'},
{risk_category_id: 31, related_processes: 'APO08|DSS01'},
{risk_category_id: 32, related_processes: 'APO07|BAI08'},
{risk_category_id: 33, related_processes: 'APO03|BAI03|BAI06|DSS01|DSS05'},
{risk_category_id: 34, related_processes: 'APO01|DSS05|APO07'},
{risk_category_id: 35, related_processes: 'APO07|DSS01|DSS06'},
{risk_category_id: 36, related_processes: 'APO09|APO10|DSS02|MEA03'},
{risk_category_id: 37, related_processes: 'APO03|BAI03|DSS01'},
{risk_category_id: 38, related_processes: 'DSS01|DSS04|DSS05'}
])


# ES:
# Carga la matriz de relacion Objetivos de Negocio VS Objetivos de TI:
# PRE: Los objetivos deben estar cargados en orden (y por bloques):

# EN:
# Load the relationship matrix Business Goals VS IT Goals:
# PRE: The goals must be loaded in order (and by blocks)

# 1-5: Business/Financial
# 6-10: Business/Customer
# 11-15: Business/Internal
# 16-17: Business/Learning and Growth
# 18-23: IT/Financial
# 24-25: IT/Customer
# 26-32: IT/Internal
# 33-34: IT/Learning and Growth

matrixBus = Escenarios::BusinessGoalItMatrix.create([
{it_goal_id: 18, business_goal_id: 1,  value: 'P'},
{it_goal_id: 18, business_goal_id: 2,  value: 'P'},
{it_goal_id: 18, business_goal_id: 3,  value: 'S'},
{it_goal_id: 18, business_goal_id: 4,  value: 'N'},
{it_goal_id: 18, business_goal_id: 5,  value: 'N'},
{it_goal_id: 18, business_goal_id: 6,  value: 'P'},
{it_goal_id: 18, business_goal_id: 7,  value: 'S'},
{it_goal_id: 18, business_goal_id: 8,  value: 'P'},
{it_goal_id: 18, business_goal_id: 9,  value: 'P'},
{it_goal_id: 18, business_goal_id: 10, value: 'S'},
{it_goal_id: 18, business_goal_id: 11, value: 'P'},
{it_goal_id: 18, business_goal_id: 12, value: 'S'},
{it_goal_id: 18, business_goal_id: 13, value: 'P'},
{it_goal_id: 18, business_goal_id: 14, value: 'N'},
{it_goal_id: 18, business_goal_id: 15, value: 'N'},
{it_goal_id: 18, business_goal_id: 16, value: 'S'},
{it_goal_id: 18, business_goal_id: 17, value: 'S'},
{it_goal_id: 19, business_goal_id: 1,  value: 'N'},
{it_goal_id: 19, business_goal_id: 2,  value: 'N'},
{it_goal_id: 19, business_goal_id: 3,  value: 'S'},
{it_goal_id: 19, business_goal_id: 4,  value: 'P'},
{it_goal_id: 19, business_goal_id: 5,  value: 'N'},
{it_goal_id: 19, business_goal_id: 6,  value: 'N'},
{it_goal_id: 19, business_goal_id: 7,  value: 'N'},
{it_goal_id: 19, business_goal_id: 8,  value: 'N'},
{it_goal_id: 19, business_goal_id: 9,  value: 'N'},
{it_goal_id: 19, business_goal_id: 10, value: 'N'},
{it_goal_id: 19, business_goal_id: 11, value: 'N'},
{it_goal_id: 19, business_goal_id: 12, value: 'N'},
{it_goal_id: 19, business_goal_id: 13, value: 'N'},
{it_goal_id: 19, business_goal_id: 14, value: 'N'},
{it_goal_id: 19, business_goal_id: 15, value: 'P'},
{it_goal_id: 19, business_goal_id: 16, value: 'N'},
{it_goal_id: 19, business_goal_id: 17, value: 'N'},
{it_goal_id: 20, business_goal_id: 1,  value: 'P'},
{it_goal_id: 20, business_goal_id: 2,  value: 'S'},
{it_goal_id: 20, business_goal_id: 3,  value: 'S'},
{it_goal_id: 20, business_goal_id: 4,  value: 'N'},
{it_goal_id: 20, business_goal_id: 5,  value: 'N'},
{it_goal_id: 20, business_goal_id: 6,  value: 'N'},
{it_goal_id: 20, business_goal_id: 7,  value: 'N'},
{it_goal_id: 20, business_goal_id: 8,  value: 'S'},
{it_goal_id: 20, business_goal_id: 9,  value: 'S'},
{it_goal_id: 20, business_goal_id: 10, value: 'N'},
{it_goal_id: 20, business_goal_id: 11, value: 'S'},
{it_goal_id: 20, business_goal_id: 12, value: 'N'},
{it_goal_id: 20, business_goal_id: 13, value: 'P'},
{it_goal_id: 20, business_goal_id: 14, value: 'N'},
{it_goal_id: 20, business_goal_id: 15, value: 'N'},
{it_goal_id: 20, business_goal_id: 16, value: 'S'},
{it_goal_id: 20, business_goal_id: 17, value: 'S'},
{it_goal_id: 21, business_goal_id: 1,  value: 'N'},
{it_goal_id: 21, business_goal_id: 2,  value: 'N'},
{it_goal_id: 21, business_goal_id: 3,  value: 'P'},
{it_goal_id: 21, business_goal_id: 4,  value: 'S'},
{it_goal_id: 21, business_goal_id: 5,  value: 'N'},
{it_goal_id: 21, business_goal_id: 6,  value: 'N'},
{it_goal_id: 21, business_goal_id: 7,  value: 'P'},
{it_goal_id: 21, business_goal_id: 8,  value: 'S'},
{it_goal_id: 21, business_goal_id: 9,  value: 'N'},
{it_goal_id: 21, business_goal_id: 10, value: 'P'},
{it_goal_id: 21, business_goal_id: 11, value: 'N'},
{it_goal_id: 21, business_goal_id: 12, value: 'N'},
{it_goal_id: 21, business_goal_id: 13, value: 'S'},
{it_goal_id: 21, business_goal_id: 14, value: 'N'},
{it_goal_id: 21, business_goal_id: 15, value: 'S'},
{it_goal_id: 21, business_goal_id: 16, value: 'S'},
{it_goal_id: 21, business_goal_id: 17, value: 'N'},
{it_goal_id: 22, business_goal_id: 1,  value: 'P'},
{it_goal_id: 22, business_goal_id: 2,  value: 'P'},
{it_goal_id: 22, business_goal_id: 3,  value: 'N'},
{it_goal_id: 22, business_goal_id: 4,  value: 'N'},
{it_goal_id: 22, business_goal_id: 5,  value: 'N'},
{it_goal_id: 22, business_goal_id: 6,  value: 'S'},
{it_goal_id: 22, business_goal_id: 7,  value: 'N'},
{it_goal_id: 22, business_goal_id: 8,  value: 'S'},
{it_goal_id: 22, business_goal_id: 9,  value: 'N'},
{it_goal_id: 22, business_goal_id: 10, value: 'S'},
{it_goal_id: 22, business_goal_id: 11, value: 'S'},
{it_goal_id: 22, business_goal_id: 12, value: 'P'},
{it_goal_id: 22, business_goal_id: 13, value: 'S'},
{it_goal_id: 22, business_goal_id: 14, value: 'S'},
{it_goal_id: 22, business_goal_id: 15, value: 'N'},
{it_goal_id: 22, business_goal_id: 16, value: 'N'},
{it_goal_id: 22, business_goal_id: 17, value: 'S'},
{it_goal_id: 23, business_goal_id: 1,  value: 'S'},
{it_goal_id: 23, business_goal_id: 2,  value: 'N'},
{it_goal_id: 23, business_goal_id: 3,  value: 'S'},
{it_goal_id: 23, business_goal_id: 4,  value: 'N'},
{it_goal_id: 23, business_goal_id: 5,  value: 'P'},
{it_goal_id: 23, business_goal_id: 6,  value: 'N'},
{it_goal_id: 23, business_goal_id: 7,  value: 'N'},
{it_goal_id: 23, business_goal_id: 8,  value: 'N'},
{it_goal_id: 23, business_goal_id: 9,  value: 'S'},
{it_goal_id: 23, business_goal_id: 10, value: 'P'},
{it_goal_id: 23, business_goal_id: 11, value: 'N'},
{it_goal_id: 23, business_goal_id: 12, value: 'P'},
{it_goal_id: 23, business_goal_id: 13, value: 'N'},
{it_goal_id: 23, business_goal_id: 14, value: 'N'},
{it_goal_id: 23, business_goal_id: 15, value: 'N'},
{it_goal_id: 23, business_goal_id: 16, value: 'N'},
{it_goal_id: 23, business_goal_id: 17, value: 'N'},
{it_goal_id: 24, business_goal_id: 1,  value: 'P'},
{it_goal_id: 24, business_goal_id: 2,  value: 'P'},
{it_goal_id: 24, business_goal_id: 3,  value: 'S'},
{it_goal_id: 24, business_goal_id: 4,  value: 'S'},
{it_goal_id: 24, business_goal_id: 5,  value: 'N'},
{it_goal_id: 24, business_goal_id: 6,  value: 'P'},
{it_goal_id: 24, business_goal_id: 7,  value: 'S'},
{it_goal_id: 24, business_goal_id: 8,  value: 'P'},
{it_goal_id: 24, business_goal_id: 9,  value: 'S'},
{it_goal_id: 24, business_goal_id: 10, value: 'N'},
{it_goal_id: 24, business_goal_id: 11, value: 'P'},
{it_goal_id: 24, business_goal_id: 12, value: 'S'},
{it_goal_id: 24, business_goal_id: 13, value: 'S'},
{it_goal_id: 24, business_goal_id: 14, value: 'N'},
{it_goal_id: 24, business_goal_id: 15, value: 'N'},
{it_goal_id: 24, business_goal_id: 16, value: 'S'},
{it_goal_id: 24, business_goal_id: 17, value: 'S'},
{it_goal_id: 25, business_goal_id: 1,  value: 'S'},
{it_goal_id: 25, business_goal_id: 2,  value: 'S'},
{it_goal_id: 25, business_goal_id: 3,  value: 'S'},
{it_goal_id: 25, business_goal_id: 4,  value: 'N'},
{it_goal_id: 25, business_goal_id: 5,  value: 'N'},
{it_goal_id: 25, business_goal_id: 6,  value: 'S'},
{it_goal_id: 25, business_goal_id: 7,  value: 'S'},
{it_goal_id: 25, business_goal_id: 8,  value: 'N'},
{it_goal_id: 25, business_goal_id: 9,  value: 'S'},
{it_goal_id: 25, business_goal_id: 10, value: 'S'},
{it_goal_id: 25, business_goal_id: 11, value: 'P'},
{it_goal_id: 25, business_goal_id: 12, value: 'S'},
{it_goal_id: 25, business_goal_id: 13, value: 'N'},
{it_goal_id: 25, business_goal_id: 14, value: 'P'},
{it_goal_id: 25, business_goal_id: 15, value: 'N'},
{it_goal_id: 25, business_goal_id: 16, value: 'S'},
{it_goal_id: 25, business_goal_id: 17, value: 'S'},
{it_goal_id: 26, business_goal_id: 1,  value: 'S'},
{it_goal_id: 26, business_goal_id: 2,  value: 'P'},
{it_goal_id: 26, business_goal_id: 3,  value: 'S'},
{it_goal_id: 26, business_goal_id: 4,  value: 'N'},
{it_goal_id: 26, business_goal_id: 5,  value: 'N'},
{it_goal_id: 26, business_goal_id: 6,  value: 'S'},
{it_goal_id: 26, business_goal_id: 7,  value: 'N'},
{it_goal_id: 26, business_goal_id: 8,  value: 'P'},
{it_goal_id: 26, business_goal_id: 9,  value: 'N'},
{it_goal_id: 26, business_goal_id: 10, value: 'N'},
{it_goal_id: 26, business_goal_id: 11, value: 'P'},
{it_goal_id: 26, business_goal_id: 12, value: 'N'},
{it_goal_id: 26, business_goal_id: 13, value: 'N'},
{it_goal_id: 26, business_goal_id: 14, value: 'N'},
{it_goal_id: 26, business_goal_id: 15, value: 'N'},
{it_goal_id: 26, business_goal_id: 16, value: 'S'},
{it_goal_id: 26, business_goal_id: 17, value: 'P'},
{it_goal_id: 27, business_goal_id: 1,  value: 'N'},
{it_goal_id: 27, business_goal_id: 2,  value: 'N'},
{it_goal_id: 27, business_goal_id: 3,  value: 'P'},
{it_goal_id: 27, business_goal_id: 4,  value: 'P'},
{it_goal_id: 27, business_goal_id: 5,  value: 'N'},
{it_goal_id: 27, business_goal_id: 6,  value: 'N'},
{it_goal_id: 27, business_goal_id: 7,  value: 'P'},
{it_goal_id: 27, business_goal_id: 8,  value: 'N'},
{it_goal_id: 27, business_goal_id: 9,  value: 'N'},
{it_goal_id: 27, business_goal_id: 10, value: 'N'},
{it_goal_id: 27, business_goal_id: 11, value: 'N'},
{it_goal_id: 27, business_goal_id: 12, value: 'N'},
{it_goal_id: 27, business_goal_id: 13, value: 'N'},
{it_goal_id: 27, business_goal_id: 14, value: 'N'},
{it_goal_id: 27, business_goal_id: 15, value: 'P'},
{it_goal_id: 27, business_goal_id: 16, value: 'N'},
{it_goal_id: 27, business_goal_id: 17, value: 'N'},
{it_goal_id: 28, business_goal_id: 1,  value: 'P'},
{it_goal_id: 28, business_goal_id: 2,  value: 'S'},
{it_goal_id: 28, business_goal_id: 3,  value: 'N'},
{it_goal_id: 28, business_goal_id: 4,  value: 'N'},
{it_goal_id: 28, business_goal_id: 5,  value: 'N'},
{it_goal_id: 28, business_goal_id: 6,  value: 'N'},
{it_goal_id: 28, business_goal_id: 7,  value: 'N'},
{it_goal_id: 28, business_goal_id: 8,  value: 'S'},
{it_goal_id: 28, business_goal_id: 9,  value: 'N'},
{it_goal_id: 28, business_goal_id: 10, value: 'P'},
{it_goal_id: 28, business_goal_id: 11, value: 'S'},
{it_goal_id: 28, business_goal_id: 12, value: 'P'},
{it_goal_id: 28, business_goal_id: 13, value: 'S'},
{it_goal_id: 28, business_goal_id: 14, value: 'S'},
{it_goal_id: 28, business_goal_id: 15, value: 'N'},
{it_goal_id: 28, business_goal_id: 16, value: 'N'},
{it_goal_id: 28, business_goal_id: 17, value: 'S'},
{it_goal_id: 29, business_goal_id: 1,  value: 'S'},
{it_goal_id: 29, business_goal_id: 2,  value: 'P'},
{it_goal_id: 29, business_goal_id: 3,  value: 'S'},
{it_goal_id: 29, business_goal_id: 4,  value: 'N'},
{it_goal_id: 29, business_goal_id: 5,  value: 'N'},
{it_goal_id: 29, business_goal_id: 6,  value: 'S'},
{it_goal_id: 29, business_goal_id: 7,  value: 'N'},
{it_goal_id: 29, business_goal_id: 8,  value: 'S'},
{it_goal_id: 29, business_goal_id: 9,  value: 'N'},
{it_goal_id: 29, business_goal_id: 10, value: 'S'},
{it_goal_id: 29, business_goal_id: 11, value: 'P'},
{it_goal_id: 29, business_goal_id: 12, value: 'S'},
{it_goal_id: 29, business_goal_id: 13, value: 'S'},
{it_goal_id: 29, business_goal_id: 14, value: 'S'},
{it_goal_id: 29, business_goal_id: 15, value: 'N'},
{it_goal_id: 29, business_goal_id: 16, value: 'N'},
{it_goal_id: 29, business_goal_id: 17, value: 'S'},
{it_goal_id: 30, business_goal_id: 1,  value: 'P'},
{it_goal_id: 30, business_goal_id: 2,  value: 'S'},
{it_goal_id: 30, business_goal_id: 3,  value: 'S'},
{it_goal_id: 30, business_goal_id: 4,  value: 'N'},
{it_goal_id: 30, business_goal_id: 5,  value: 'N'},
{it_goal_id: 30, business_goal_id: 6,  value: 'S'},
{it_goal_id: 30, business_goal_id: 7,  value: 'N'},
{it_goal_id: 30, business_goal_id: 8,  value: 'N'},
{it_goal_id: 30, business_goal_id: 9,  value: 'N'},
{it_goal_id: 30, business_goal_id: 10, value: 'S'},
{it_goal_id: 30, business_goal_id: 11, value: 'N'},
{it_goal_id: 30, business_goal_id: 12, value: 'S'},
{it_goal_id: 30, business_goal_id: 13, value: 'P'},
{it_goal_id: 30, business_goal_id: 14, value: 'N'},
{it_goal_id: 30, business_goal_id: 15, value: 'N'},
{it_goal_id: 30, business_goal_id: 16, value: 'N'},
{it_goal_id: 30, business_goal_id: 17, value: 'N'},
{it_goal_id: 31, business_goal_id: 1,  value: 'S'},
{it_goal_id: 31, business_goal_id: 2,  value: 'S'},
{it_goal_id: 31, business_goal_id: 3,  value: 'S'},
{it_goal_id: 31, business_goal_id: 4,  value: 'S'},
{it_goal_id: 31, business_goal_id: 5,  value: 'N'},
{it_goal_id: 31, business_goal_id: 6,  value: 'N'},
{it_goal_id: 31, business_goal_id: 7,  value: 'P'},
{it_goal_id: 31, business_goal_id: 8,  value: 'N'},
{it_goal_id: 31, business_goal_id: 9,  value: 'P'},
{it_goal_id: 31, business_goal_id: 10, value: 'N'},
{it_goal_id: 31, business_goal_id: 11, value: 'S'},
{it_goal_id: 31, business_goal_id: 12, value: 'N'},
{it_goal_id: 31, business_goal_id: 13, value: 'N'},
{it_goal_id: 31, business_goal_id: 14, value: 'N'},
{it_goal_id: 31, business_goal_id: 15, value: 'N'},
{it_goal_id: 31, business_goal_id: 16, value: 'N'},
{it_goal_id: 31, business_goal_id: 17, value: 'N'},
{it_goal_id: 32, business_goal_id: 1,  value: 'N'},
{it_goal_id: 32, business_goal_id: 2,  value: 'N'},
{it_goal_id: 32, business_goal_id: 3,  value: 'S'},
{it_goal_id: 32, business_goal_id: 4,  value: 'S'},
{it_goal_id: 32, business_goal_id: 5,  value: 'N'},
{it_goal_id: 32, business_goal_id: 6,  value: 'N'},
{it_goal_id: 32, business_goal_id: 7,  value: 'N'},
{it_goal_id: 32, business_goal_id: 8,  value: 'N'},
{it_goal_id: 32, business_goal_id: 9,  value: 'N'},
{it_goal_id: 32, business_goal_id: 10, value: 'N'},
{it_goal_id: 32, business_goal_id: 11, value: 'N'},
{it_goal_id: 32, business_goal_id: 12, value: 'N'},
{it_goal_id: 32, business_goal_id: 13, value: 'N'},
{it_goal_id: 32, business_goal_id: 14, value: 'N'},
{it_goal_id: 32, business_goal_id: 15, value: 'P'},
{it_goal_id: 32, business_goal_id: 16, value: 'N'},
{it_goal_id: 32, business_goal_id: 17, value: 'N'},
{it_goal_id: 33, business_goal_id: 1,  value: 'S'},
{it_goal_id: 33, business_goal_id: 2,  value: 'S'},
{it_goal_id: 33, business_goal_id: 3,  value: 'P'},
{it_goal_id: 33, business_goal_id: 4,  value: 'N'},
{it_goal_id: 33, business_goal_id: 5,  value: 'N'},
{it_goal_id: 33, business_goal_id: 6,  value: 'S'},
{it_goal_id: 33, business_goal_id: 7,  value: 'N'},
{it_goal_id: 33, business_goal_id: 8,  value: 'S'},
{it_goal_id: 33, business_goal_id: 9,  value: 'N'},
{it_goal_id: 33, business_goal_id: 10, value: 'N'},
{it_goal_id: 33, business_goal_id: 11, value: 'N'},
{it_goal_id: 33, business_goal_id: 12, value: 'N'},
{it_goal_id: 33, business_goal_id: 13, value: 'N'},
{it_goal_id: 33, business_goal_id: 14, value: 'P'},
{it_goal_id: 33, business_goal_id: 15, value: 'N'},
{it_goal_id: 33, business_goal_id: 16, value: 'P'},
{it_goal_id: 33, business_goal_id: 17, value: 'S'},
{it_goal_id: 34, business_goal_id: 1,  value: 'S'},
{it_goal_id: 34, business_goal_id: 2,  value: 'P'},
{it_goal_id: 34, business_goal_id: 3,  value: 'N'},
{it_goal_id: 34, business_goal_id: 4,  value: 'N'},
{it_goal_id: 34, business_goal_id: 5,  value: 'N'},
{it_goal_id: 34, business_goal_id: 6,  value: 'S'},
{it_goal_id: 34, business_goal_id: 7,  value: 'N'},
{it_goal_id: 34, business_goal_id: 8,  value: 'P'},
{it_goal_id: 34, business_goal_id: 9,  value: 'S'},
{it_goal_id: 34, business_goal_id: 10, value: 'N'},
{it_goal_id: 34, business_goal_id: 11, value: 'S'},
{it_goal_id: 34, business_goal_id: 12, value: 'N'},
{it_goal_id: 34, business_goal_id: 13, value: 'S'},
{it_goal_id: 34, business_goal_id: 14, value: 'N'},
{it_goal_id: 34, business_goal_id: 15, value: 'N'},
{it_goal_id: 34, business_goal_id: 16, value: 'S'},
{it_goal_id: 34, business_goal_id: 17, value: 'P'}
])


# ES:
# Carga la matriz de relacion Objetivos de TI VS Procesos:
# PRE: Los procesos deben estar cargados en orden (1-37):

# EN: 
# Load the relationship matrix IT Goals VS Processes
# PRE: The processes must be loaded and ordered (1-37)


# ES: Un ciclo por cada proceso:
# EN: A cycle for each process

# Process 1:
line = 'P|S|P|S|S|S|P|N|S|S|S|S|S|S|S|S|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 1, it_goal_id: i, value: partes[i-18])
end

# Process 2:
line = 'P|N|S|N|P|P|P|S|N|N|S|S|S|S|N|S|P'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 2, it_goal_id: i, value: partes[i-18])
end

# Process 3:
line = 'S|S|S|P|N|P|S|S|N|P|N|N|S|S|P|S|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 3, it_goal_id: i, value: partes[i-18])
end


# Process 4:
line = 'S|N|S|S|S|S|S|S|P|N|P|N|S|N|N|P|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 4, it_goal_id: i, value: partes[i-18])
end


# Process 5:
line = 'S|S|P|N|N|P|P|N|N|N|N|N|S|S|S|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 5, it_goal_id: i, value: partes[i-18])
end


# Process 6:
line = 'P|P|S|S|N|N|S|N|P|S|P|S|S|S|N|N|N'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 6, it_goal_id: i, value: partes[i-18])
end


# Process 7:
line = 'P|N|S|S|S|N|P|S|S|N|S|S|S|S|P|P|P'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 7, it_goal_id: i, value: partes[i-18])
end


# Process 8:
line = 'P|N|S|S|S|S|S|S|P|S|P|S|N|S|S|S|P'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 8, it_goal_id: i, value: partes[i-18])
end


# Process 9:
line = 'S|N|N|S|P|N|N|P|P|N|P|S|N|S|N|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 9, it_goal_id: i, value: partes[i-18])
end


# Process 10:
line = 'P|N|S|S|P|S|S|S|S|N|S|N|P|N|N|N|P'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 10, it_goal_id: i, value: partes[i-18])
end


# Process 11:
line = 'S|N|S|S|P|P|S|S|N|N|S|N|S|N|N|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 11, it_goal_id: i, value: partes[i-18])
end


# Process 12:
line = 'P|S|S|S|N|N|S|S|S|S|P|N|P|N|N|N|N'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 12, it_goal_id: i, value: partes[i-18])
end


# Process 13:
line = 'P|N|S|S|S|S|P|S|N|N|S|P|S|N|S|P|P'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 13, it_goal_id: i, value: partes[i-18])
end


# Process 14:
line = 'S|N|N|S|S|S|P|S|S|S|S|N|S|P|S|S|P'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 14, it_goal_id: i, value: partes[i-18])
end


# Process 15:
line = 'N|S|N|P|S|S|P|S|P|S|S|N|S|S|S|N|N'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 15, it_goal_id: i, value: partes[i-18])
end


# Process 16:
line = 'S|S|N|S|P|N|P|S|S|N|S|N|P|S|S|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 16, it_goal_id: i, value: partes[i-18])
end


# Process 17:
line = 'N|P|N|P|N|P|S|S|S|P|N|N|P|S|S|S|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 17, it_goal_id: i, value: partes[i-18])
end


# Process 18:
line = 'N|P|N|P|N|P|S|S|N|P|N|N|N|P|S|S|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 18, it_goal_id: i, value: partes[i-18])
end


# Process 19:
line = 'P|N|S|P|P|S|S|S|N|N|S|N|P|N|N|S|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 19, it_goal_id: i, value: partes[i-18])
end


# Process 20:
line = 'P|S|S|S|S|N|P|S|S|S|S|P|S|S|N|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 20, it_goal_id: i, value: partes[i-18])
end


# Process 21:
line = 'S|N|N|S|S|N|P|S|N|N|S|S|S|S|N|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 21, it_goal_id: i, value: partes[i-18])
end


# Process 22:
line = 'N|N|N|S|S|N|P|S|S|N|P|N|S|P|N|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 22, it_goal_id: i, value: partes[i-18])
end


# Process 23:
line = 'S|N|S|N|S|N|S|P|S|N|S|N|P|N|N|N|P'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 23, it_goal_id: i, value: partes[i-18])
end


# Process 24:
line = 'N|N|S|P|S|N|P|S|S|P|S|N|S|S|S|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 24, it_goal_id: i, value: partes[i-18])
end


# Process 25:
line = 'N|N|N|S|S|N|S|P|S|N|N|N|S|S|S|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 25, it_goal_id: i, value: partes[i-18])
end


# Process 26:
line = 'S|N|N|N|S|N|S|S|P|S|S|N|N|S|N|S|P'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 26, it_goal_id: i, value: partes[i-18])
end


# Process 27:
line = 'N|S|N|S|N|P|S|N|S|S|P|N|N|S|S|N|N'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 27, it_goal_id: i, value: partes[i-18])
end


# Process 28:
line = 'N|P|N|S|N|S|N|S|S|S|P|N|N|P|S|N|N'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 28, it_goal_id: i, value: partes[i-18])
end


# Process 29:
line = 'N|S|N|P|S|N|P|S|S|S|P|N|N|S|S|S|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 29, it_goal_id: i, value: partes[i-18])
end


# Process 30:
line = 'N|N|N|P|N|N|P|S|N|S|N|N|N|S|S|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 30, it_goal_id: i, value: partes[i-18])
end


# Process 31:
line = 'N|S|N|P|S|N|P|S|S|N|P|S|N|P|S|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 31, it_goal_id: i, value: partes[i-18])
end


# Process 32:
line = 'S|S|N|P|S|N|P|S|S|S|S|S|N|P|S|S|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 32, it_goal_id: i, value: partes[i-18])
end


# Process 33:
line = 'S|P|N|P|N|N|S|S|N|P|S|S|N|S|S|N|N'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 33, it_goal_id: i, value: partes[i-18])
end


# Process 34:
line = 'N|S|N|P|N|N|P|S|N|S|S|S|N|S|S|S|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 34, it_goal_id: i, value: partes[i-18])
end


# Process 35:
line = 'S|S|S|P|S|S|P|S|S|S|P|N|S|S|P|S|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 35, it_goal_id: i, value: partes[i-18])
end


# Process 36:
line = 'N|P|N|P|N|S|S|S|N|S|N|N|N|S|P|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 36, it_goal_id: i, value: partes[i-18])
end


# Process 37:
line = 'N|P|N|P|S|N|S|N|N|S|N|N|N|N|S|N|S'
partes = line.split('|')
for i in 18..34
	registro = Escenarios::ItGoalsProcessesMatrix.create(process_id: 37, it_goal_id: i, value: partes[i-18])
end


