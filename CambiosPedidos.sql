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
declare @contador int, @totalrow int 
set @contador = 0
set @totalrow = (select COUNT(*) from catalogo.Cliente)
while @contador < @totalrow
begin
declare @numrow int
set @numrow = (select CAST(SUBSTRING(codcli,2,2) AS INT) from catalogo.Cliente)
end

SELECT  ROW_NUMBER() OVER (ORDER BY codcli) AS Q,codcli 
FROM catalogo.Cliente

select * from catalogo.Cliente
select CAST(SUBSTRING(codcli,2,2) AS INT) from catalogo.Cliente 
