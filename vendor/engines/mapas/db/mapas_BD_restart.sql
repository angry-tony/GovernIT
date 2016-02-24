------------------ ES: MÓDULO DE MAPAS DE DECISIÓN ---------------------------
------------------ EN: DECISION MAPS ENGINE ---------------------------


-- ES: Borrado de toda la información de las 6 tablas del módulo de Mapas de Decisión --
-- EN: Deleting of all information from the 6 tables of the engine: Decision Maps --
delete from mapas_complementary_mechanisms;
delete from mapas_decision_archetypes;
delete from mapas_decision_maps;
delete from mapas_findings;
delete from mapas_governance_decisions;
delete from mapas_map_details;

-- ES: Reinicio de secuencias de las tablas del módulo de Mapas de Decisión --
-- EN: Restart of the sequences from the tables of the engine: Decision Maps --
alter sequence mapas_complementary_mechanisms_id_seq restart with 1;
alter sequence mapas_decision_archetypes_id_seq restart with 1;
alter sequence mapas_decision_maps_id_seq restart with 1;
alter sequence mapas_findings_id_seq restart with 1;
alter sequence mapas_governance_decisions_id_seq restart with 1;
alter sequence mapas_map_details_id_seq restart with 1;