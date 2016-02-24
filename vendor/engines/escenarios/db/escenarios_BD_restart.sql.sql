------------------ ENGINE: ASSESSMENT SCENARIOS ----------------------

-- ES: Borrado de toda la información de las 10 tablas del módulo de Escenarios de Evaluación --
-- EN: Script to delete all the information of the 10 tables that conform the Engine: Assessment Scenarios --

delete from escenarios_business_goal_it_matrices
delete from escenarios_goal_califications
delete from escenarios_goal_escenarios
delete from escenarios_goals
delete from escenarios_it_goals_processes_matrices
delete from escenarios_it_processes
delete from escenarios_priorization_escenarios
delete from escenarios_risk_califications
delete from escenarios_risk_escenarios
delete from escenarios_process_matrices


-- ES: Reinicio de secuencias de las tablas del módulo de Escenarios de Evaluación --
-- EN: Restart the sequences of the tables that conforms the Engine: Assessment Scenarios --
alter sequence escenarios_goal_califications_id_seq restart with 1;
alter sequence escenarios_goal_escenarios_id_seq restart with 1;
alter sequence escenarios_goals_id_seq restart with 1;
alter sequence escenarios_it_processes_id_seq restart with 1;
alter sequence escenarios_priorization_escenarios_id_seq restart with 1;
alter sequence escenarios_risk_califications_id_seq restart with 1;
alter sequence escenarios_risk_escenarios_id_seq restart with 1;











