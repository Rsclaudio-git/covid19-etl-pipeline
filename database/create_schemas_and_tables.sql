
--######################################
--  SUPPRESSIONS PREALABLES DES TABLES ET SEQUENCES DE LA BDD (cela nous permetra de vider la BDD d'un seul coup au bdesion)
--######################################
DROP TABLE IF EXISTS ods.ods_region;
DROP TABLE IF EXISTS ods.ods_departement;
DROP TABLE IF EXISTS ods.ods_etablissements_hospitaliers;
DROP TABLE IF EXISTS ods.ods_patients;
DROP TABLE IF EXISTS stg.stg_region;
DROP TABLE IF EXISTS stg.stg_departement;
DROP TABLE IF EXISTS stg.stg_etablissements_hospitaliers;
DROP TABLE IF EXISTS stg.stg_patients;
DROP TABLE IF EXISTS stg.stg_rejets;
DROP SEQUENCE IF EXISTS stg.seq_stg_rejets;
DROP TABLE IF EXISTS dwh.dwh_region;
DROP SEQUENCE IF EXISTS dwh.seq_dwh_region;
DROP TABLE IF EXISTS dwh.dwh_departement;
DROP SEQUENCE IF EXISTS dwh.seq_dwh_departement;
DROP TABLE IF EXISTS dwh.dwh_etablissements_hospitaliers;
DROP SEQUENCE IF EXISTS dwh.seq_dwh_etablissements_hospitaliers;
DROP TABLE IF EXISTS dwh.dwh_patients;
DROP SEQUENCE IF EXISTS dwh.seq_dwh_patients;
DROP TABLE IF EXISTS dwh.stats;
DROP TABLE IF EXISTS dwh.logs;
DROP TABLE IF EXISTS dwh.flowcatcher;
DROP TABLE IF EXISTS dtm.patients_par_region;
DROP SEQUENCE IF EXISTS dtm.seq_patients_par_region;
DROP TABLE IF EXISTS dtm.patients_par_axes;
DROP SEQUENCE IF EXISTS dtm.seq_patients_par_axes;



--######################################
-- 1. CREATION DES SCHEMAS DE LA BDD
--######################################

-- SCHEMA: ODS (Operational Data Store)
DROP SCHEMA IF EXISTS ods ;

CREATE SCHEMA ods AUTHORIZATION postgres;

-- SCHEMA: STG (Staging Area)
DROP SCHEMA IF EXISTS stg ;

CREATE SCHEMA stg AUTHORIZATION postgres;

-- SCHEMA: DWH (Data Warehouse)
DROP SCHEMA IF EXISTS dwh ;

CREATE SCHEMA dwh AUTHORIZATION postgres;
 
-- SCHEMA: DTM (Datamart)
DROP SCHEMA IF EXISTS dtm ;

CREATE SCHEMA dtm AUTHORIZATION postgres;


--######################################
-- 2. CREATION DES TABLES STG
--######################################
 
-- Table: stg.stg_region

CREATE TABLE stg.stg_region
(
 code_region varchar(2),
 chef_lieu varchar(5),
 type_nome_clair varchar(1),
 libelle_en_majuscule varchar(100),
 nom_en_clair varchar(100),
 libelle_en_minuscule varchar(100)
);

-- Table: stg.stg_departement

CREATE TABLE stg.stg_departement
(
 code_departement varchar(3),
 code_region varchar(2),
 chef_lieu varchar(5),
 type_nom_clair varchar(1),
 libelle_en_majuscule varchar(100),
 nom_en_clair varchar(100),
 libelle_en_minuscule varchar(100)
);

-- Table: stg.stg_etablissements_hospitaliers

CREATE TABLE stg.stg_etablissements_hospitaliers
( 
 code_etablissement varchar(9),
 nom_etablissement varchar(200),
 adresse varchar(200),
 complement_adresse varchar(200),
 code_dept varchar(3),
 libelle_dept varchar(100),
 num_tel varchar(15),
 num_fax varchar(15),
 num_cat_etablissement varchar(3),
 categorie_etablissement varchar(200),
 num_type_etablissement varchar(4),
 type_etablissement varchar(200),
 code_tarif varchar(2),
 lib_tarification varchar(200),
 code_psph varchar(1),
 part_sp_hospitalier varchar(200),
 date_ouverture date,
 lat varchar(10),
 lng varchar(10)
);
 
-- Table: stg.stg_patients

CREATE TABLE stg.stg_patients
( 
 code_patient varchar(20),
 code_etab_hospitalier varchar(9),
 departement_etab varchar(3),
 region_etab varchar(2),
 annee_hosp varchar(4),
 mois_hosp varchar(2),
 date_debut_hosp varchar(8),
 date_fin_hosp varchar(8),
 etat_patient varchar(8),
 duree_traitement varchar(20)
);


--######################################
-- 3. CREATION DES TABLES ODS
--######################################


-- Table: ods.ods_region

CREATE TABLE ods.ods_region
(
 code_region varchar(2) NOT NULL,
 libelle_en_majuscule varchar(100),
 libelle_en_minuscule varchar(100)
);

-- Table: ods.ods_departement

CREATE TABLE ods.ods_departement
(
 code_departement varchar(3) NOT NULL,
 code_region varchar(2),
 libelle_en_majuscule varchar(100),
 libelle_en_minuscule varchar(100)
);

-- Table: ods.ods_etablissements_hospitaliers

CREATE TABLE ods.ods_etablissements_hospitaliers
( 
 code_etablissement varchar(9) NOT NULL,
 nom_etablissement varchar(200),
 adresse varchar(200),
 complement_adresse varchar(200),
 code_dept varchar(3),
 libelle_dept varchar(100),
 num_tel varchar(15),
 num_fax varchar(15),
 num_cat_etablissement varchar(3),
 categorie_etablissement varchar(200),
 num_type_etablissement varchar(4),
 type_etablissement varchar(200),
 code_tarif varchar(2),
 lib_tarification varchar(200),
 code_psph varchar(1),
 part_sp_hospitalier varchar(200),
 date_ouverture date,
 lat numeric(9,7),
 lng numeric(8,7)
);
 
-- Table: ods.ods_patients

CREATE TABLE ods.ods_patients
( 
 code_patient varchar(20) NOT NULL,
 id_etab_hospitalier integer,
 code_etab_hospitalier varchar(9),
 id_departement_etab integer,
 departement_etab varchar(3),
 id_region_etab integer,
 region_etab varchar(2),
 annee_hosp varchar(4),
 mois_hosp varchar(2),
 date_debut_hosp varchar(8) NOT NULL,
 date_fin_hosp varchar(8),
 etat_patient varchar(8),
 duree_traitement varchar(20)
);

-- Table: ods.ods_rejets

CREATE TABLE ods.ods_rejets 
(
 ID_REJET INT NOT NULL,
 NOM_JOB varchar(200),
 CAUSE_REJET varchar(200),
 TABLE_SOURCE varchar(200),
 CHAMP_SOURCE varchar(200),
 date_TRAITEMENT date NOT NULL,
 CONSTRAINT PK_stg_rejets PRIMARY KEY (ID_REJET)
);

-- SEQUENCE: ods.seq_ods_rejets

CREATE SEQUENCE ods.seq_ods_rejets 
 INCREMENT 1
 START 1
 MINVALUE 1
 MAXVALUE 9999999
 CACHE 1;
 
 
--######################################
-- 4. CREATION DES TABLES DWH
--###################################### 


-- Table: dwh.dwh_region

CREATE TABLE dwh.dwh_region
(
 id_region integer,
 code_region varchar(2) NOT NULL,
 libelle_en_majuscule varchar(100),
 libelle_en_minuscule varchar(100),
 date_insertion date,
 date_maj date,
 CONSTRAINT pk_dwh_region PRIMARY KEY (code_region)
);

-- SEQUENCE: dwh.seq_dwh_region

CREATE SEQUENCE dwh.seq_dwh_region
 INCREMENT 1
 START 1
 MINVALUE 1
 MAXVALUE 9999999
 CACHE 1;
 
-- Insertion d'une ligne par defaut pour les codes inconnu 
INSERT INTO dwh.dwh_region(id_region, code_region,libelle_en_majuscule,libelle_en_minuscule, date_insertion, date_maj)
VALUES (0,'00','REGION INCONNU', 'Region Inconnu', CURRENT_DATE, CURRENT_DATE);
 
----------------------------------------------------------------- 
 
-- Table: dwh.dwh_departement

CREATE TABLE dwh.dwh_departement
(
 id_departement integer,
 code_departement varchar(3) NOT NULL,
 code_region varchar(2),
 libelle_en_majuscule varchar(100),
 libelle_en_minuscule varchar(100),
 date_insertion date,
 date_maj date,
 CONSTRAINT pk_dwh_departement PRIMARY KEY (code_departement)
);

-- SEQUENCE: dwh.seq_dwh_departement

CREATE SEQUENCE dwh.seq_dwh_departement
 INCREMENT 1
 START 1
 MINVALUE 1
 MAXVALUE 9999999
 CACHE 1;
 
-- Insertion d'une ligne par defaut pour les codes inconnu
INSERT INTO dwh.dwh_departement(id_departement, code_departement, code_region,libelle_en_majuscule,libelle_en_minuscule, date_insertion, date_maj)
VALUES (0,'00','00','DEPARTEMENT INCONNU','Departement Inconnu', CURRENT_DATE, CURRENT_DATE);

------------------------------------------------------------


-- Table: dwh.dwh_etablissements_hospitaliers

CREATE TABLE dwh.dwh_etablissements_hospitaliers
( 
 id_etab_hospitalier integer, 
 code_etablissement varchar(9) NOT NULL,
 nom_etablissement varchar(200),
 adresse varchar(200),
 complement_adresse varchar(200),
 code_dept varchar(3),
 libelle_dept varchar(100),
 num_tel varchar(15),
 num_fax varchar(15),
 num_cat_etablissement varchar(3),
 categorie_etablissement varchar(200),
 num_type_etablissement varchar(4),
 type_etablissement varchar(200),
 code_tarif varchar(2),
 lib_tarification varchar(200),
 code_psph varchar(1),
 part_sp_hospitalier varchar(200),
 date_ouverture date,
 lat numeric(9,7),
 lng numeric(8,7),
 date_insertion date,
 date_maj date,
 CONSTRAINT pk_dwh_etablissements_hospitaliers PRIMARY KEY (code_etablissement)
);

-- SEQUENCE: dwh.seq_dwh_etablissements_hospitaliers

CREATE SEQUENCE dwh.seq_dwh_etablissements_hospitaliers
 INCREMENT 1
 START 1
 MINVALUE 1
 MAXVALUE 9999999
 CACHE 1;
 
------------------------------------------------------------ 
 
 
-- Table: dwh.dwh_patients

CREATE TABLE dwh.dwh_patients
( 
 id_patients integer,
 code_patient varchar(20) NOT NULL,
 id_etab_hospitalier integer,
 code_etab_hospitalier varchar(9),
 id_departement_etab integer,
 departement_etab varchar(3),
 id_region_etab integer,
 region_etab varchar(2),
 annee_hosp varchar(4),
 mois_hosp varchar(2),
 date_debut_hosp varchar(8) NOT NULL,
 date_fin_hosp varchar(8),
 etat_patient varchar(8),
 duree_traitement varchar(20), 
 date_insertion date,
 date_maj date,
 CONSTRAINT pk_dwh_patients PRIMARY KEY (code_patient)
);

-- SEQUENCE: dwh.seq_dwh_patients

CREATE SEQUENCE dwh.seq_dwh_patients
 INCREMENT 1
 START 1
 MINVALUE 1
 MAXVALUE 9999999
 CACHE 1; 

----------------------------------------------------------------- 
 
-- Table: dwh.stats

create table dwh.stats
(
 MOMENT date,
 PID varchar(50),
 FATHER_PID varchar(50),
 ROOT_PID varchar(50),
 SYSTEM_PID numeric(10),
 PROJECT varchar(50),
 JOB varchar(255),
 JOB_REPOSITORY_ID varchar(255),
 JOB_VERSION varchar(255),
 CONTEXT varchar(50),
 ORIGIN varchar(255),
 MESSAGE_TYPE varchar(255),
 MESSAGE varchar(255),
 DURATION numeric(10)
);

----------------------------------------------------------------- 
 
-- Table: dwh.logs

create table dwh.logs
(
 MOMENT date,
 PID varchar(50),
 ROOT_PID varchar(50),
 FATHER_PID varchar(50),
 PROJECT varchar(50),
 JOB varchar(255),
 CONTEXT varchar(50),
 PRIORITY numeric(10),
 TYPE varchar(255),
 ORIGIN varchar(255),
 MESSAGE varchar(255),
 CODE numeric(10)
);

----------------------------------------------------------------- 
 
-- Table: dwh.dwh_flowcatcher

create table dwh.flowcatcher
(
 MOMENT date,
 PID varchar(50),
 FATHER_PID varchar(50),
 ROOT_PID varchar(50),
 SYSTEM_PID numeric(10),
 PROJECT varchar(50),
 JOB varchar(255),
 JOB_REPOSITORY_ID varchar(255),
 JOB_VERSION varchar(255),
 CONTEXT varchar(50),
 ORIGIN varchar(255),
 LABEL varchar(255),
 COUNT numeric(10),
 REFERENCE numeric(10),
 THRESHOLDS varchar(255)
);


--######################################
-- 4. CREATION DES TABLES DTM
--######################################


-- Table: dtm.patients_par_region

CREATE TABLE dtm.patients_par_region
(
 identifiant integer,
 region varchar(100),
 annee varchar(4),
 nbre_patients_admis integer,
 nbre_patients_gueri integer,
 nbre_patients_decede integer,
 nbre_patients_en_hosp integer,
 duree_moyenne_traitement numeric(10,2),
 date_insertion date,
 date_maj date,
 CONSTRAINT pk_patients_par_region PRIMARY KEY (identifiant)
);

-- SEQUENCE: dwh.seq_patients_par_region

CREATE SEQUENCE dtm.seq_patients_par_region
 INCREMENT 1
 START 1
 MINVALUE 1
 MAXVALUE 9999999
 CACHE 1;


-- Table: dtm.patients_par_axes

CREATE TABLE dtm.patients_par_axes
(
 identifiant integer,
 region varchar(100),
 departement varchar(100),
 hopital varchar(100),
 annee varchar(4),
 mois varchar(20),
 nbre_patients_admis integer,
 nbre_patients_gueri integer,
 nbre_patients_decede integer,
 nbre_patients_en_hosp integer,
 duree_moyenne_traitement numeric(10,2),
 date_insertion date,
 date_maj date,
 CONSTRAINT pk_patients_par_axes PRIMARY KEY (identifiant)
);

-- SEQUENCE: dwh.seq_patients_par_axes

CREATE SEQUENCE dtm.seq_patients_par_axes
 INCREMENT 1
 START 1
 MINVALUE 1
 MAXVALUE 9999999
 CACHE 1;
 