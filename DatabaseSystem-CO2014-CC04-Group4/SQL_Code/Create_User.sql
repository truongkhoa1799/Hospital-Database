-- ----------------------------- SET UP USER -----------------------------
-- Create Login
create login KHUONG WITH PASSWORD='group5@123';
create login DANG WITH PASSWORD='group5@123';
create login THUCQUYEN WITH PASSWORD='group5@123';
create login PHUONG WITH PASSWORD='group5@123';

-- Create Login
create login manager_1 WITH PASSWORD='group5@123';

-- Create account for read and write as well as execute functions/stored procedures
create user manager_1 for LOGIN manager_1 with DEFAULT_schema=[hospital];
EXEC sp_addrolemember 'db_datareader', 'manager_1';
EXEC sp_addrolemember 'db_datawriter', 'manager_1';
GRANT EXECUTE on SCHEMA ::hospital to manager_1;

-- Create schema hospital
CREATE SCHEMA hospital;

-- Create user according to login
create user KHUONG for LOGIN KHUONG with DEFAULT_schema=[hospital];
EXEC sp_addrolemember 'db_datareader', 'KHUONG';
EXEC sp_addrolemember 'db_datawriter', 'KHUONG';
EXEC sp_addrolemember 'db_owner', 'KHUONG';
GRANT EXECUTE on SCHEMA ::hospital to KHUONG;

create user DANG for LOGIN DANG with DEFAULT_schema=[hospital];
EXEC sp_addrolemember 'db_datareader', 'DANG';
EXEC sp_addrolemember 'db_datawriter', 'DANG';
EXEC sp_addrolemember 'db_owner', 'DANG';
GRANT EXECUTE on SCHEMA ::hospital to DANG;

create user THUCQUYEN for LOGIN THUCQUYEN with DEFAULT_schema=[hospital];
EXEC sp_addrolemember 'db_datareader', 'THUCQUYEN';
EXEC sp_addrolemember 'db_datawriter', 'THUCQUYEN';
EXEC sp_addrolemember 'db_owner', 'THUCQUYEN';
GRANT EXECUTE on SCHEMA ::hospital to THUCQUYEN;

create user PHUONG for LOGIN PHUONG with DEFAULT_schema=[hospital];
EXEC sp_addrolemember 'db_datareader', 'PHUONG';
EXEC sp_addrolemember 'db_datawriter', 'PHUONG';
EXEC sp_addrolemember 'db_owner', 'PHUONG';
GRANT EXECUTE on SCHEMA ::hospital to PHUONG;