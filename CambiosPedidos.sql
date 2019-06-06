select * from catalogo.Cliente
select * from movimiento.CabezeraP
select * from movimiento.DetalleP
go
-- Se prevee la actualizacion de registros de la tabla DetalleP que hace referencia 
-- la clave primaria codped 
-- Se supone la alteracion del campo codped de la tabla DetalleP como extra a las 
-- Alter tabla Cliente

ALTER TABLE [catalogo.Cliente]
ALTER COLUMN [codcli] varchar(6) NOT NULL
GO
ALTER TABLE [movimiento.CabezeraP]
ALTER COLUMN [codcli] varchar(6) NOT NULL
GO
ALTER TABLE [movimiento.DetalleP]
ALTER COLUMN [codped] varchar(10) NOT NULL
GO
ALTER TABLE [movimiento.CabezeraP]
ALTER COLUMN [codped] varchar(10) NOT NULL
GO

-- Procedimiento Almacenado para la actualizacion de claves primarias
CREATE PROCEDURE pa_uCamposCliente AS
SELECT  codcli 
FROM catalogo.Cliente
UPDATE catalogo.Cliente
SET codcli = 
RETURN
GO
SELECT  codcli 
FROM catalogo.Cliente

select * from catalogo.Cliente