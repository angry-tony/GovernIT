# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151005204125) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "configuracions", force: true do |t|
    t.string  "riskmap"
    t.integer "enterprise_id"
  end

  create_table "enterprises", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "escenarios_business_goal_it_matrices", id: false, force: true do |t|
    t.integer "it_goal_id"
    t.integer "business_goal_id"
    t.string  "value"
  end

  create_table "escenarios_goal_califications", force: true do |t|
    t.integer "goal_id"
    t.integer "importance"
    t.integer "performance"
    t.integer "goal_escenario_id"
  end

  create_table "escenarios_goal_escenarios", force: true do |t|
    t.string  "name"
    t.integer "governance_structure_id"
    t.integer "enterprise_id"
  end

  create_table "escenarios_goals", force: true do |t|
    t.text    "description"
    t.string  "goal_type"
    t.string  "scope"
    t.string  "dimension"
    t.integer "parent_id"
    t.integer "enterprise_id"
  end

  create_table "escenarios_it_goals_processes_matrices", id: false, force: true do |t|
    t.integer "process_id"
    t.integer "it_goal_id"
    t.string  "value"
  end

  create_table "escenarios_it_processes", force: true do |t|
    t.string "description"
    t.string "domain"
    t.string "fuente"
    t.string "id_fuente"
  end

  create_table "escenarios_priorization_escenarios", force: true do |t|
    t.string  "name"
    t.integer "risksWeight"
    t.integer "goalsWeight"
    t.integer "enterprise_id"
    t.integer "risk_escenario_id"
    t.integer "goal_escenario_id"
    t.date    "fecha_ejecucion"
    t.text    "stats"
  end

  create_table "escenarios_risk_califications", force: true do |t|
    t.integer "risk_id"
    t.integer "valor"
    t.integer "cantidad"
    t.string  "risk_type"
    t.text    "evidence"
    t.integer "risk_escenario_id"
  end

  create_table "escenarios_risk_escenarios", force: true do |t|
    t.string  "name"
    t.integer "governance_structure_id"
    t.integer "enterprise_id"
    t.text    "consolidate_info"
    t.integer "decision_map_id"
  end

  create_table "escenarios_risk_process_matrices", id: false, force: true do |t|
    t.integer "risk_category_id"
    t.text    "related_processes"
  end

  create_table "governance_responsabilities", force: true do |t|
    t.string "name"
  end

  create_table "governance_responsabilities_structures", id: false, force: true do |t|
    t.integer "governance_responsability_id"
    t.integer "governance_structure_id"
  end

  create_table "governance_structures", force: true do |t|
    t.string  "name"
    t.string  "structure_type"
    t.integer "enterprise_id"
    t.integer "parent_id"
    t.string  "global_type"
    t.string  "profile"
  end

  create_table "mapas_complementary_mechanisms", force: true do |t|
    t.string  "description"
    t.integer "enterprise_id"
  end

  create_table "mapas_decision_archetypes", force: true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "mapas_decision_maps", force: true do |t|
    t.string  "name"
    t.string  "description"
    t.string  "map_type"
    t.integer "governance_structure_id"
    t.integer "enterprise_id"
  end

  create_table "mapas_findings", force: true do |t|
    t.text    "description"
    t.string  "parsed_risks"
    t.text    "proposed_updates"
    t.integer "decision_map_id"
    t.integer "governance_decision_id"
  end

  create_table "mapas_governance_decisions", force: true do |t|
    t.text    "description"
    t.string  "dimension"
    t.string  "decision_type"
    t.integer "parent_id"
    t.integer "enterprise_id"
  end

  create_table "mapas_map_details", force: true do |t|
    t.integer "governance_structure_id"
    t.integer "governance_decision_id"
    t.integer "decision_map_id"
    t.integer "decision_archetype_id"
    t.string  "responsability_type"
    t.text    "complementary_mechanisms"
  end

  create_table "risk_categories", force: true do |t|
    t.string  "description"
    t.integer "id_padre"
  end

  create_table "risks", force: true do |t|
    t.text    "descripcion"
    t.string  "nivel"
    t.integer "riesgo_padre_id"
    t.integer "risk_category_id"
    t.integer "enterprise_id"
  end

end
