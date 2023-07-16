-- 权限管理
--grant create table to hrtest; --授予权限
--revoke select on dmhr.employee from hrtest; -- 回收权限
--revoke create table from hrtest;
--grant select (employee_id, employee_name) on dmhr.employee to hrtest; -- 授予权限，精确到列
--select * from dba_sys_privs t where t.GRANTEE= 'HRTEST'; --查看用户有什么权限
--select * from dba_role_privs t where t.GRANTEE= 'HRTEST'; --查看角色有什么权限
-- grant select any table to hrtest;
--select * from v$parameter t where name like '%ENABLE_DDL_ANY_PRIV%';

--普通用户导出其他模式下表导出权限
--grant select on dmhr.city to dmtest; --普通用户导出其他模式下表，需要有此表的 select 和 select for dump 权限。
--grant select for dump on dmhr.city to dmtest; --普通用户导出其他模式下表，需要有此表的 select 和 select for dump 权限。

--库管理
--select name from v$database;

--用户管理
--select username  from dba_users;  --查看有哪些用户
--select user; --查看当前用户
--create user hrtest IDENTIFIED by Dameng123; --创建用户
--create user hr IDENTIFIED by Dameng123 DEFAULT TABLESPACE TBSTEST; --创建用户
--drop user if EXISTS hr; --删除用户
--alter user hrtest IDENTIFIED by "Dameng@123"; --修改密码
--select sys_context('USERENV','CURRENT_USER'); --查看当前模式和当前用户
--select * from SYSOBJECTS t where t."SUBTYPE$" ='USER'; --查看用户
--alter user hr LIMIT FAILED_LOGIN_ATTEMPS 5, PASSWORD_LOCK_TIME 3; --限制用户登陆次数及密码锁定次数


--模式管理（仅对当前会话生效）
--set SCHEMA hrtest;  --切换模式
--select * from SYSOBJECTS t where t."TYPE$" ='SCH'; --查看模式
--select sys_context('USERENV','CURRENT_SCHEMA');--查看当前模式和当前用户
--create schema hrtest01 AUTHORIZATION HRTEST; --创建模式
--create table hrtest01.t_test(id int, name varchar(20));--在模式下创建表
--select a.id scheid, a.name schename, b.id userid, b.name username from SYS.SYSOBJECTS a, SYS.SYSOBJECTS b where a."TYPE$" = 'SCH' and a.pid = b.id;-- 查看模式用户对应关系

-- 表空间管理
--create tablespace tbs DATAFILE 'TBS01.DBF' size 32;
--select * from dba_tablespaces; --查看有哪些表空间
--select * from DBA_DATA_FILES; --查看数据文件
--select * from v$tablespace; 
--select * from v$datafile;
--select * from DBA_FREE_SPACE; 
--select file_name  from dba_data_files;  --查看有哪些数据文件
--alter user hr DEFAULT TABLESPACE dmtbs; -- 修改默认表空间
--select  *  from dba_tables;  --查看库中所有表的信息，包括所有者和表名

-------------------------------------------------------------------- 表管理 --------------------------------------------------------------------
--create table hrtest.t_testpid(pid int,pname varchar(20),sex bit,logtime datetime) TABLESPACE tbs; --创建表
--alter table hrtest.t_testpid add column (salary varchar(20));--添加字段：
--alter table hrtest.t_testpid modify email varchar(50);--修改字段类型：
--alter table hrtest.t_testpid drop logtime;--删除字段
--alter table hrtest.t_testpid add column logtime datetime default sysdate;--对字段添加默认值（大表不建议添加字段时给默认值，耗时很长）：
--alter table t_testpid rename to t_testoa;--重命名表：
--alter table t_testoa rename column id to pid;--重命名字段：
--select * from dba_tables t where t.owner='LJBDDB';  -- 查询固定模式下表
--select * from dba_tab_columns t where t.owner='HRTEST'; -- 查询固定模式下所有表的所有列
--select t.TABLE_NAME, t.TABLESPACE_NAME from user_tables t;
--select t.TABLE_NAME, t.COLUMN_NAME, t.NULLABLE from USER_TAB_COLS t;
--alter table hrtest.T_TESTPID move tablespace main;--修改表的表空间（DM 会自动重建该表上的索引）
--select * from dba_tables t where t.TABLE_NAME like 'T_TEST%';--修改表的表空间（DM 会自动重建该表上的索引）
--insert into hrtest.t_testpid(pid, pname, sex, email, salary) values(3, 'test', 0, 'test@qq.com', 2300); --插入内容
--delete from hrtest.t_testpid where pid = '1';  --删除表中的行

--select * from hrtest.T_testPID;  --查表内容
--select table_name,owner from all_tables; -- 查看表和模式/拥有者对应关系
--select * from dba_tables t where t.owner='LJBDDB';  -- 查询固定模式下表
--select * from dba_tab_columns t where t.owner='HRTEST'; -- 查询固定模式下所有表的所有列
--select t.TABLE_NAME, t.TABLESPACE_NAME from user_tables t;
--select t.TABLE_NAME, t.COLUMN_NAME, t.NULLABLE from USER_TAB_COLS t;



--数据导入及控制
--start /dm8/backup/dts/t_department.sql;--数据的导入
--`/dm8/backup/dts/t_department.sql;--数据的导入
--set TIMING off;--可以关闭回显以提高导入效率：
--set feedback off;--可以关闭回显以提高导入效率：
--set echo off;--可以关闭回显以提高导入效率：


--管理约束
--alter table hrtest.t_testpid modify pname not null;--非空约束
--alter table hrtest.t_testpid add CONSTRAINT uk_testpid_email unique (email);--唯一约束
--alter table hrtest.t_testpid ADD CONSTRAINT pk_testpid_pid PRIMARY KEY(pid);--主键约束
--alter table hrtest.t_testpid add salary number(10,2);--检验约束
--alter table hrtest.t_testpid ADD CONSTRAINT ck_testpid_salary CHECK (salary>=2100);
--alter table hrtest.t_test add CONSTRAINT fk_test_id FOREIGN KEY(id) REFERENCES hrtest.t_testpid(pid); --外键约束（外键引用两一张表的主键或者唯一键）
--alter table hrtest.t_test disable CONSTRAINT fk_test_id;--约束的禁用和启用、删除
--alter table hrtest.t_test enable CONSTRAINT fk_test_id;--约束的禁用和启用、删除
--alter table hrtest.t_test drop CONSTRAINT fk_test_id;--约束的禁用和启用、删除
--select * from dba_constraints t where t.owner='HRTEST'; --约束字典
--select * from DBA_CONS_COLUMNS t where t.owner='HRTEST';--约束字典

--视图管理
--create view hrtest.v_emp as select a.EMPLOYEE_ID, a.EMPLOYEE_NAME, a.EMAIL, a.PHONE_NUM  from hrtest.t_testpid a where a.DEPARTMENT_ID = 1001; --创建视图
--create view hrtest.v_emp as select a.pid, a.EMAIL, a.sex  from hrtest.t_testpid a; --创建视图
--select * from hrtest.v_emp;--查询视图

--系统字典
--SELECT * FROM SYSOBJECTS; --系统中所有对象的
--SELECT * FROM SYSINDEXES; --系统中所有索引定义信息
--SELECT * FROM SYSCOLUMNS; --系统中所有列定义的信息
--SELECT * FROM V$PROCESS; --显示当前进程、线程信息
--SELECT * FROM V$threads; --显示当前进程、线程信息

--查询事务等待：
--select * from v$trxwait;
--select * from v$lock t where t.blocked =1;


--数据库备份
--backup database; --全量备份
--backup database increment; --增量备份
--backup database full to ONLINEBAK_01 backupset '/dm8/backup/full/ONLINEBAK_01';
--backup database increment BASE ON BACKUPSET '/dm8/backup/full/ONLINEBAK_01' to ONLINEBAKINCR_01 backupset '/dm8/backup/incr/ONLINEBAK_01' ;
--backup database increment with BACKUPDIR '/dm8/backup/full/' to ONLINEBAKINCR_02 backupset '/dm8/backup/incr/ONLINEBAK_02' ;


--备份集管理
--select * from v$backupset;
--select * from v$ifun t where t.name like 'SF_BAKSET%';  --备份集相关函数
--SF_BAKSET_BACKUP_DIR_ADD('DISK','/dm8/backup/full/');--添加备份集目录（针对当前会话生效）
--SF_BAKSET_BACKUP_DIR_ADD('DISK','/dm8/backup/incr/');
--select SF_BAKSET_CHECK('DISK','/dm8/backup/incr/ONLINEBAK_02');--校验备份集

--表空间备份
--backup tablespace dmtbs;
--backup tablespace dmtbs INCREMENT with BACKUPDIR '/dm8/backup/full/' to DMTBSINCR_01 backupset '/dm8/backup/incr/DMTBSINCR_01' ;

--表和归档的备份
--backup table dmhr.employee; --表的备份
--backup archivelog all; --归档备份


--逻辑备份
--dexp 逻辑导出、dimp 逻辑导入四个级别：
--全库（full=y）
--按用户（owner=XXX）
--按模式（schemas=XXX）
--按表（tables=XX）

--逻辑导出
--dexp userid=sysdba/Dameng123:5236 directory=/dm8/backup/dexp file=full.dmp     log=full.log full=y; --全库导出
--dexp userid=sysdba/Dameng123:5236 directory=/dm8/backup/dexp file=HRTEST.dmp   log=HRTEST.log owner=HRTEST; --按用户导出
--dexp userid=sysdba/Dameng123:5236 directory=/dm8/backup/dexp file=DMHR.dmp     log=DMHR.log schemas=DMHR --按模式导出：
--dexp userid=sysdba/Dameng123:5236 directory=/dm8/backup/dexp file=EMPLOYEE.dmp log=EMPLOYEE.log tables=DMHR.EMPLOYEE; --按表导出

--逻辑导入
--dimp userid=sysdba/Dameng123:5238 directory=/dm8/backup/dexp file=full.dmp log=impfull.log full=y; --全库导入
--dimp userid=sysdba/Dameng123:5238 directory=/dm8/backup/dexp file=DMHR.dmp log=impDMHR.log REMAP_SCHEMA=DMHR:DMTEST; --按模式导入（将 A 模式导入到 B 模式，使用 REMAP_SCHEMA 参数）：


