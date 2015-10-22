USE master
GO
DROP DATABASE MCITPSC
GO
CREATE DATABASE MCITPSC
GO
USE MCITPSC
GO
CREATE TABLE MEMBROS
(
	[MATRICULA] [INT] IDENTITY(1,1) NOT NULL,
	[NOME] [VARCHAR](200) NULL,
	[CPF] [VARCHAR](11),
	[DATACADASTRO] DATETIME DEFAULT GETDATE()
)
INSERT MEMBROS ( NOME, CPF ) VALUES  ( 'JOSE', '12345678912') 
GO
SELECT * FROM dbo.MEMBROS
--BKP FULL
USE master
GO
BACKUP DATABASE [MCITPSC] TO  DISK = 
N'C:\BKP\MCITPSC.bak' WITH NOFORMAT, INIT,  
NAME = N'MCITPSC-Full Database Backup', SKIP, 
NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO
DROP DATABASE MCITPSC
GO
--RESTORE FULL
USE [master]
RESTORE DATABASE [MCITPSC] FROM  
DISK = N'C:\BKP\MCITPSC.bak' WITH  FILE = 1,  
NOUNLOAD,  REPLACE,  STATS = 5
GO
USE MCITPSC
GO
SELECT * FROM MEMBROS
GO
--BKP DIFF
INSERT MEMBROS ( NOME, CPF ) VALUES  ( 'PEDRO', '12345678912') 
GO
BACKUP DATABASE [MCITPSC] 
TO  DISK = N'C:\BKP\MCITPSC_1.DIFF' 
WITH  DIFFERENTIAL , NOFORMAT, INIT,  
NAME = N'MCITPSC-Differential Database Backup', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO
USE master
GO
ALTER DATABASE MCITPSC SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE
GO
DROP DATABASE MCITPSC
GO
--RESTORE FULL + DIFF
USE [master]

RESTORE DATABASE [MCITPSC] 
FROM  DISK = N'C:\BKP\MCITPSC.bak' WITH  FILE = 1,  
NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5

RESTORE DATABASE [MCITPSC] FROM  
DISK = N'C:\BKP\MCITPSC_1.DIFF' WITH  FILE = 1,  
NOUNLOAD,  STATS = 5
GO
USE MCITPSC
GO
SELECT * FROM MEMBROS
GO
--BKP FULL + DIFF + LOG
INSERT MEMBROS ( NOME, CPF ) VALUES  ( 'ANDRE', '12345678913') 
GO
USE MASTER
GO
BACKUP LOG [MCITPSC] TO  DISK = N'c:\bkp\mcitpsc_log1.trn' 
WITH NOFORMAT, INIT,  NAME = N'MCITPSC-Transaction Log  Backup', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10
GO
USE master
GO
ALTER DATABASE MCITPSC SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
DROP DATABASE MCITPSC
GO
RESTORE DATABASE [MCITPSC] 
FROM  DISK = N'C:\BKP\MCITPSC.bak' WITH  FILE = 1,  
NORECOVERY,  NOUNLOAD,  REPLACE,  STATS = 5

RESTORE DATABASE [MCITPSC] FROM  
DISK = N'C:\BKP\MCITPSC_1.DIFF' WITH  FILE = 1,  
NORECOVERY, NOUNLOAD,  STATS = 5
GO
RESTORE LOG [MCITPSC] FROM  
DISK = N'c:\bkp\mcitpsc_log1.trn' 
WITH  FILE = 1,  NOUNLOAD,  STATS = 10
GO
USE MCITPSC
GO
SELECT * FROM MEMBROS
GO



