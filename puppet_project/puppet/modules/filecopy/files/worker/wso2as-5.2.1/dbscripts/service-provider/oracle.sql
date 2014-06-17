CREATE TABLE IDP_BASE_TABLE (
            NAME VARCHAR2 (20),
            PRIMARY KEY (NAME))
/
INSERT INTO IDP_BASE_TABLE values ('IdP')
/
CREATE TABLE UM_TENANT_IDP (
			UM_ID INTEGER,
			UM_TENANT_ID INTEGER,
			UM_TENANT_IDP_NAME VARCHAR(512),
			UM_TENANT_IDP_ISSUER VARCHAR(512),
            		UM_TENANT_IDP_URL VARCHAR(2048),
			UM_TENANT_IDP_THUMBPRINT VARCHAR(2048),
			UM_TENANT_IDP_PRIMARY CHAR(1) NOT NULL,
			UM_TENANT_IDP_AUDIENCE VARCHAR(2048),
			UM_TENANT_IDP_TOKEN_EP_ALIAS VARCHAR(2048),
			PRIMARY KEY (UM_ID),
			CONSTRAINT CON_IDP_KEY UNIQUE (UM_TENANT_ID, UM_TENANT_IDP_NAME))
/

CREATE SEQUENCE IDP_SEQUENCE START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER IDP_TRIGGER
                    BEFORE INSERT
                    ON UM_TENANT_IDP
                    REFERENCING NEW AS NEW
                    FOR EACH ROW
                     BEGIN
                       SELECT IDP_SEQUENCE.nextval INTO :NEW.UM_ID FROM dual;
 			   END;
/
CREATE TABLE UM_TENANT_IDP_ROLES (
			UM_ID INTEGER,
			UM_TENANT_IDP_ID INTEGER,
			UM_TENANT_IDP_ROLE VARCHAR(512),
			PRIMARY KEY (UM_ID),
			CONSTRAINT CON_ROLES_KEY UNIQUE (UM_TENANT_IDP_ID, UM_TENANT_IDP_ROLE),
			FOREIGN KEY (UM_TENANT_IDP_ID) REFERENCES UM_TENANT_IDP(UM_ID) ON DELETE CASCADE)
/
CREATE SEQUENCE IDP_ROLES_SEQUENCE START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER IDP_ROLES_TRIGGER
                    BEFORE INSERT
                    ON UM_TENANT_IDP_ROLES
                    REFERENCING NEW AS NEW
                    FOR EACH ROW
                     BEGIN
                       SELECT IDP_ROLES_SEQUENCE.nextval INTO :NEW.UM_ID FROM dual;
 			   END;
/
CREATE TABLE UM_TENANT_IDP_ROLE_MAPPINGS (
			UM_ID INTEGER,
			UM_TENANT_IDP_ROLE_ID INTEGER,
			UM_TENANT_ID INTEGER,
			UM_TENANT_ROLE VARCHAR(512),	
			PRIMARY KEY (UM_ID),
			CONSTRAINT CON_ROLE_MAPPINGS_KEY UNIQUE (UM_TENANT_IDP_ROLE_ID, UM_TENANT_ID, UM_TENANT_ROLE),
			FOREIGN KEY (UM_TENANT_IDP_ROLE_ID) REFERENCES UM_TENANT_IDP_ROLES(UM_ID) ON DELETE CASCADE)
/

CREATE SEQUENCE IDP_ROLE_MAPPINGS_SEQUENCE START WITH 1 INCREMENT BY 1 NOCACHE
/
CREATE OR REPLACE TRIGGER IDP_ROLE_MAPPINGS_TRIGGER
                    BEFORE INSERT
                    ON UM_TENANT_IDP_ROLE_MAPPINGS
                    REFERENCING NEW AS NEW
                    FOR EACH ROW
                     BEGIN
                       SELECT IDP_ROLE_MAPPINGS_SEQUENCE.nextval INTO :NEW.UM_ID FROM dual;
 			   END;
/
