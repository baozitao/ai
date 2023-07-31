-- 安装 DM 数据库后，在/etc/rc.d/init.d 中有名称为 DmService 开头的文件，文件全名为 DmService+实例名（例：如果实例名为 DMSERVER，则相对应的服务文件为DmServiceDMSERVER ） 。 以 实 例 名 为 DMSERVER 为 例 ， 在 终 端 输入./DmServiceDMSERVER start 或者 service DmServiceDMSERVER start 即可启动 DM 数据库。

-- 系统表查询
-- select name,type$,subtype$ from sysobjects where name like '%TABLE%' and subtype$ in 'STAB'; 查询系统内名称包含TABLE的子类为STAB的系统对象名称

-- 查看数据库版本
-- select * from V$VERSION;
-- select * from V$DATABASE;
--select * from V$INSTANCE;
--select * from V$TABLESPACE;
--select * from V$LICENSE;
-- select * from V$DATAFILE;



-- 权限管理
--grant create table to hrtest; --授予权限
--revoke select on dmhr.employee from hrtest; -- 回收权限
--revoke create table from hrtest;
--grant select (employee_id, employee_name) on dmhr.employee to hrtest; -- 授予权限，精确到列
--select * from dba_sys_privs t where t.GRANTEE= 'HRTEST'; --查看用户有什么权限
--select * from dba_role_privs t where t.GRANTEE= 'HRTEST'; --查看角色有什么权限
-- grant select any table to hrtest;
--select * from v$parameter t where name like '%ENABLE_DDL_ANY_PRIV%';

-- # 设置用户名为hrtest的用户，最大连接数为3
-- alter user hrtest limit SESSION_PER_USER 3;

-- 添加查询权限
-- grant select on 模式名.表名 to 用户名;
-- grant select on dmhr.department to hrtest;
-- 添加修改、删除权限
-- grant select on 模式名.表名 to 用户名;
-- grant update on 模式名.表名 to 用户名;
-- grant delete on 模式名.表名 to 用户名;
-- 回收权限
-- revoke 角色名 from 用户名;
-- revoke 具体权限 from 用户名;
-- revoke r1 from dmtest;
-- revoke create table from dmtest;

-- 查询指定用户所有用的权限
-- select * from DBA_SYS_PRIVS where grantee = '用户名';
-- select * from dba_tab_privs where grantee = '用户名';
-- select * from dba_role_privs where grantee = '用户名';
-- select * from dba_col_privs where grantee = '用户名';



--普通用户导出其他模式下表导出权限
--grant select on dmhr.city to dmtest; --普通用户导出其他模式下表，需要有此表的 select 和 select for dump 权限。
--grant select for dump on dmhr.city to dmtest; --普通用户导出其他模式下表，需要有此表的 select 和 select for dump 权限。

--库管理
--select name from v$database;

--用户管理
--SELECT USER_USED_SPACE('TEST_USER'); -- 查看用户占用的空间
--select username  from dba_users;  --查看有哪些用户
--select user; --查看当前用户
--create user hrtest IDENTIFIED by Dameng123; --创建用户
--create user hr IDENTIFIED by Dameng123 DEFAULT TABLESPACE TBSTEST; --创建用户
-- create user 用户名 identified by 密码 default tablespace 表空间名;
-- create user hrtest identified by "Dmeng123";
-- 设置密码的时候，需要查询下密码策略是什么
-- select * from v$parameter where name = 'PWD_POLICY';
-- 如果想调整密码策略
-- alter system set 'PWD_POLICY' = 下图策略相加 both;
    -- 0 : 无策略
    -- 1： 禁止与用户名相同
    -- 2： 口令长度不小于9
    -- 4：至少包含一个大写字母
    -- 8： 至少包含一个数字
    -- 16：至少包含一个标点符号（英文输入法下除双引号和空格外所有符号）
    -- 口令策略可以I单独应用，也可以组合，组合时，把数字相加即可

-- # 将密码输错锁定次数改为5次，锁定时间为3分钟
-- alter user 用户名 limit FAILED_LOGIN_ATTEMPS 5,PASSWORD_LOCK_TIME 3;

-- 手动锁定或解锁账号
-- # 手动解锁
-- alter user 用户名 account unlock;
-- # 手动锁定
-- alter user 用户名 account lock;

--drop user if EXISTS hr; --删除用户
--alter user hrtest IDENTIFIED by "Dameng@123"; --修改密码
--select sys_context('USERENV','CURRENT_USER'); --查看当前模式和当前用户
--select * from SYSOBJECTS t where t."SUBTYPE$" ='USER'; --查看用户
--alter user hr LIMIT FAILED_LOGIN_ATTEMPS 5, PASSWORD_LOCK_TIME 3; --限制用户登陆次数及密码锁定次数


--模式管理（仅对当前会话生效）
--set SCHEMA hrtest;  --切换模式
--select * from SYSOBJECTS t where t."TYPE$" ='SCH'; --查询系统中所有模式
--select * from dba_tables t where t.owner='LJBDDB';  -- 查询模式下表
--select sys_context('USERENV','CURRENT_SCHEMA');--查看当前模式和当前用户
--create schema hrtest01 AUTHORIZATION HRTEST; --创建模式
--create table hrtest01.t_test(id int, name varchar(20));--在模式下创建表
--select a.id scheid, a.name schename, b.id userid, b.name username from SYS.SYSOBJECTS a, SYS.SYSOBJECTS b where a."TYPE$" = 'SCH' and a.pid = b.id;-- 查看模式用户对应关系

-- # 创建模式
-- create schema 模式名 authorization 用户名; --注意：如果在disql中执行此语句，空行后需要加上/再回车
-- /
-- # 授予用户创建模式权限
-- grant create schema to 用户名;
-- 查询模式和所属用户
-- select a.id scheid, a.name schename, b.id userid, b.name username
-- from SYS.SYSOBJECTS a, SYS.SYSOBJECTS b
-- where a."TYPE$" = 'SCH' and a.pid = b.id;

-- 查询当前模式
-- select sys_context('USERENV','CURRENT_SCHEMA');

-- 查询当前用户，两种都可以
-- select user;
-- select sys_context('USERENV','CURRENT_USER');

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
--# 修改表空间大小
--alter tablespace 表空间名 resize datafile '数据文件路径' to 数据文件大小(单位为mb);
--alter tablespace dmtbs resize datafile 'DMTBS01.DBF' to 64;
--# 修改表空间开启自动增长，增长步长，最大表空间
--alter tablespace 表空间名 datafile '数据文件路径' autoextend on next 增长步长 maxsize 文件最大值
--alter tablespace dmtbs datafile 'DMTBS01.DBF' autoextend on next 2 maxsize 10240;

--删除表空间
--drop tablesapce 表空间名;
--drop tablespace dmtest;

--增加表空间下的数据文件
--alter tablespace 表空间名 add datafile '数据文件路径' size 数据文件大小(单位为mb);
--alter tablespace dmtbs add datafile 'DMTBS02.DBF' size 64;
--修改表空间名称
--alter tablespace 修改前表空间名 rename to 修改后表空间名;
--alter tablespace dmtbs rename to dmtest;


------------------------------------------ 重做日志 -------------------------------------
-- ## 当前正在使用的联机日志
-- select * from v$rlog;
-- select * from v$logfile;
-- 创建连接日志、修改连接日志大小（达梦只支持往大了改）
-- alter database add logfile '日志名称' size 日志大小(单位MB);
-- alter database add logfile 'DAMENG03.log' size 128

-- alter database resize logfile '日志路径' to 日志大小(单位MB);
-- alter database resize logfile '/dm8/data/DAMENG/DAMENG03.log' to 256;

-- 重做日志迁移
-- # 将数据库状态设置为mount状态
-- alter database mount;
-- alter database rename logfile '原日志路径' to '迁移到的日志路径';
-- # 将数据库状态设置为open状态
-- alter database open;
-- alter database mount;
-- alter database rename logfile '/dm8/data/DAMENG/DAMENG01.log' to '/dm8/data/DAMENG/REDO/DAMENG01.log';
-- alter database rename logfile '/dm8/data/DAMENG/DAMENG02.log' to '/dm8/data/DAMENG/REDO/DAMENG02.log';
-- alter database rename logfile '/dm8/data/DAMENG/DAMENG03.log' to '/dm8/data/DAMENG/REDO/DAMENG03.log';
-- alter database open;
-------------------------------------------------------------------- 归档管理 ------------------------------------------------------------
-- # 将数据库状态设置为mount
-- alter database mount;
-- # 打开归档
-- alter database archivelog;
-- # 归档配置，配置归档路径，归档文件大小（超过就新建一个文件），归档文件总的大小（超过限制，就会删除老的）
-- alter database add archivelog 'type=local,dest=/dm8/arch,file_size=64,space_limit=10240';
-- # 将数据库状态设置为open
-- alter database open;

-- # 查询归档状态
-- select arch_mode from v$database;
-- # 查看归档文件
-- select * from SYS."V$ARCH_FILE";
-- # 查询归档配置
-- select * from v$dm_arch_ini;

-- 关闭归档
-- alter database mount;
-- # 关闭归档
-- alter database noarchivelog;
-- # 删除归档文件
-- alter database delete archivelog 'type=local,dest=/dm8/arch';
-- # 将数据库状态设置为open
-- alter database open;

-- # 查询归档状态
-- select arch_mode from v$database;


--------------------------------------------------------------------- 索引管理 --------------------------------------------------------------------
-- 创建索引
-- create index idx_表名_字段名 ON 表名 (字段名,字段名);




--------------------------------------------------------------------- 表管理 --------------------------------------------------------------------
--SELECT TABLE_USED_SPACE('SYSDBA', 'TEST'); -- 查看表占用空间
--SELECT TABLE_USED_PAGES('SYSDBA', 'TEST'); -- 查看表使用的页数
--SELECT INDEX_USED_SPACE(33555463); -- 查看索引占用的空间
--SELECT INDEX_USED_PAGES(33555463); -- 查看索引使用的页数
--CREATE TABLE NEW_EMP AS SELECT * FROM EMPLOYEE; -- 查询建表
--SELECT * FROM TT INTERSECT SELECT * FROM KK; --使用 INTERSECT 查询 TT 表中和 KK 表中都有的数据。
--SELECT * FROM TT MINUS SELECT * FROM KK; --使用 MINUS 或 EXCEPT 查询 tt 表中有的，kk 表中没有的数据。

--创建表
--create table hrtest.t_testpid(pid int,pname varchar(20),sex bit,logtime datetime) TABLESPACE tbs; --创建表
-- create table dmtest.t_testpid(
-- 	pid int,
-- 	pname varchar(10),
-- 	logtime datetime DEFAULT sysdate,
-- 	sex bit
-- ) tablespace HRTBS;

-- 从别的表复制
-- # 只复制表结构（不带约束信息）
-- create table t_emp03 as select * from dmhr.employee where 1=0;

-- # 复制表结构+表数据
-- create table t_emp01 as select * from dmhr.employee;
-- create table t_emp02 like dmhr.employee;

-- 调整字段
-- # 添加字段
-- alter table dmtest.t_testpid add email varchar(20);
-- # 修改字段
-- alter table dmtest.t_testpid modify email varchar(30);
-- # 删除字段
-- alter table dmtest.t_testpid drop email;



--alter table hrtest.t_testpid add column (salary varchar(20));--添加字段：
--alter table hrtest.t_testpid modify email varchar(50);--修改字段类型：
--alter table hrtest.t_testpid drop logtime;--删除字段
--alter table hrtest.t_testpid add column logtime datetime default sysdate;--对字段添加默认值（大表不建议添加字段时给默认值，耗时很长）：
--alter table t_testpid rename to t_testoa;--重命名表：
--SELECT NAME, AUTHOR, PUBLISHER, NOWPRICE FROM PRODUCTION.PRODUCT WHERE NOWPRICE BETWEEN 10 AND 20; -- 范围筛选查询
--SELECT NAME, AUTHOR FROM PRODUCTION.PRODUCT WHERE PUBLISHER IN ('中华书局', '人民文学出版社'); --IN查询
--SELECT ADDRESSID, ADDRESS1, CITY, POSTALCODE FROM PERSON.ADDRESS WHERE ADDRESS1 LIKE '___关山%202';--使用 LIKE 谓词的查询
--UPDATE PRODUCTION.PRODUCT SET NOWPRICE = NOWPRICE - 2.0000 WHERE PUBLISHER = '中华书局'; --将出版社为中华书局的图书的现在销售价格增加 1 元。
--alter table t_testoa rename column id to pid;--重命名字段：
--select * from dba_tables t where t.owner='LJBDDB';  -- 查询模式下表
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
-- 约束类型
-- NOT NULL：非空约束
-- UNIQUE：唯一约束，可以为空，简写为UK_表名_字段名
-- PRIMARY KEY：主键约束（唯一约束+非空约束），简写为PK_表名_字段名
-- FOREIGN KEY：外键引用约束，引用的是另一张表（父表）的主键或唯一键。简写为FK_表名_字段名
-- CHECK：检验约束，用户校验数据的准确性，简写为CK_表名_字段名
-- 主键约束和唯一约束的区别：一张表只能有一个主键，但是可以有多个唯一约束。

-- 添加约束
-- 注意：字段如果为小写需要小写并且加上双引号，字段为大写不需要加双引号

-- # 添加主键约束
-- alter table dmtest.t_testpid add CONSTRAINT pk_testpid_pid PRIMARY key("pid");
-- # 添加外键约束，注意REFERENCES表里的字段必须是主键或者是添加了唯一索引的字段
-- alter table dmtest.t_testchild add CONSTRAINT fk_testchild_pid FOREIGN key("pid") REFERENCES dmtest.t_testpid("pid");
-- # 添加校验约束
-- alter table dmtest.t_testchild add CONSTRAINT ck_testchild_salary CHECK ("salary">=3000);

-- 禁用
-- alter table 模式名.表名 disable constraint "约束名"
-- 启用
-- alter table 模式名.表名 enable constraint "约束名"


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


--------------------------------------------------------------------- 视图管理 --------------------------------------------------------------------

--create view hrtest.v_emp as select a.EMPLOYEE_ID, a.EMPLOYEE_NAME, a.EMAIL, a.PHONE_NUM  from hrtest.t_testpid a where a.DEPARTMENT_ID = 1001; --创建视图
--create view hrtest.v_emp as select a.pid, a.EMAIL, a.sex  from hrtest.t_testpid a; --创建视图
--select * from hrtest.v_emp;--查询视图

-- create or replace view 视图名称 as select * from aaa where age > 10



--系统字典
--SELECT * FROM SYSOBJECTS; --系统中所有对象的
--SELECT * FROM SYSINDEXES; --系统中所有索引定义信息
--SELECT * FROM SYSCOLUMNS; --系统中所有列定义的信息
--SELECT * FROM V$PROCESS; --显示当前进程、线程信息
--SELECT * FROM V$threads; --显示当前进程、线程信息

--查询事务等待：
--select * from v$trxwait;
--select * from v$lock t where t.blocked =1;

--------------------------------------------------------------------- 数据库备份 --------------------------------------------------------------------
-- 物理备份
--     完全备份
--         包含指定数据库和表空间所有数据
--     增量备份
--         基于一次完全备份或上一次增量备份后，往后每次备份只备份与前一次相比有差异的的数据文件
-- 逻辑备份
--     冷备
--         数据库停止运行时的备份
--     热备
--         数据库启动状态下的备份


-- 联机备份
-- # 全库备份到默认路径下
-- backup database

-- # 全库备份到指定路径下(备份目录不带文件名)
-- backup database full backupset '备份目录';

-- # 基于基础备份集的增量备份，并备份到指定目录
-- backup database increment to incrbak01 backupset '/dm8/backup/incr/incrbak01';

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

--------------------------------------------------------------------- 数据库逻辑备份 --------------------------------------------------------------------

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


--------------------------------------------------------------------- sql导入 --------------------------------------------------------------------
-- start sql文件路径