create user pdb_adm identified by pdb_adm
default tablespace system
temporary tablespace temp;

grant connect, resource to pdb_adm;

alter user pdb_adm quota unlimited on system;
