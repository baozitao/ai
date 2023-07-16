--select file_name  from dba_data_files;  --查看有哪些数据文件
--select username  from dba_users;  --�查看有哪些用户
--select user; --查看当前用户
--select tablespace_name from dba_tablespaces; --查看有哪些表空间
--select * from SYSOBJECTS t where t."TYPE$" ='SCH'; --查看有哪些模式
--select  *  from dba_tables;  --查看库中所有表的信息，包括所有者和表名
--create user hr IDENTIFIED by dameng123; --创建用户
--alter user hr DEFAULT TABLESPACE dmtbs; -- 修改默认表空间
--alter user hrtest IDENTIFIED by "Dameng@123";
--create user hr IDENTIFIED by Dameng123 DEFAULT TABLESPACE TBSTEST; --创建用户
--drop user if EXISTS hr; --删除用户
--alter user hr LIMIT FAILED_LOGIN_ATTEMPS 5, PASSWORD_LOCK_TIME 3; --限制用户登陆次数及密码锁定次数

-- 权限管理
--grant create table to hrtest; --授予权限
--revoke select on dmhr.employee from hrtest; -- 回收权限
--revoke create table from hrtest;
--grant select (employee_id, employee_name) on dmhr.employee to hrtest; -- 授予权限，精确到列


-- 权限查询
--select * from dba_sys_privs t where t.GRANTEE= 'HRTEST'; --查看用户有什么权限
--select * from dba_role_privs t where t.GRANTEE= 'HRTEST'; --查看角色有什么权限
-- grant select any table to hrtest;
--select * from v$parameter t where name like '%ENABLE_DDL_ANY_PRIV%';


--查看当前模式和当前用户
--select sys_context('USERENV','CURRENT_SCHEMA');
--select sys_context('USERENV','CURRENT_USER'); 
--select user;

--切换模式（仅对当前会话生效）
--set SCHEMA dmhr;
-- 查看模式用户对应关系
/*select a.id scheid, a.name schename, b.id userid, b.name username
 from SYS.SYSOBJECTS a, SYS.SYSOBJECTS b
where a."TYPE$" = 'SCH' and a.pid = b.id;*/


--创建模式
create schema hrtest01 AUTHORIZATION HRTEST;