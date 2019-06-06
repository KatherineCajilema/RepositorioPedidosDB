
select * from catalogo.Cliente
select * from movimiento.CabezeraP
select * from movimiento.DetalleP
go
-- Se prevee la actualizacion de registros de la tabla DetalleP que hace referencia 
-- la clave primaria codped 
-- Se eliminan los constrains de clave referencial de la base de datos Pedidos para las tablas Cliente, CabezeraP y DetalleP
Alter table movimiento.DetalleP drop Constraint [tienedetalle];
go
Alter table movimiento.CabezeraP drop Constraint [Solicita];
go
Alter table catalogo.Cliente drop Constraint [debetener]; 
go
Alter table catalogo.Cliente drop Constraint [pk_Cliente];
go
Alter table movimiento.DetalleP drop Constraint [pk_DetalleP];
go
Alter table movimiento.CabezeraP drop Constraint [pk_CabezeraP];
go

-- Alter tablas Cliente, DetalleP, CabezeraP

ALTER TABLE catalogo.Cliente
ALTER COLUMN [codcli] varchar(6) NOT NULL
GO
ALTER TABLE movimiento.CabezeraP
ALTER COLUMN [codcli] varchar(6) NOT NULL
GO
ALTER TABLE movimiento.DetalleP
ALTER COLUMN codped varchar(10) NOT NULL
GO
ALTER TABLE movimiento.CabezeraP
ALTER COLUMN [codped] varchar(10) NOT NULL
GO

-- Procedimiento Almacenado para la actualizacion de codcli de la tabla Cliente
CREATE TABLE #rowidcliente (numrow int, codcli int)
go
CREATE PROCEDURE pa_uCamposCliente AS
declare @contador int, @totalrow int 
set @contador = 1
set @totalrow = (select COUNT(*) from catalogo.Cliente)
select ROW_NUMBER() OVER (ORDER BY codcli) AS numrow, CAST(SUBSTRING(codcli,2,2) AS INT) 
as codcli into #rowidcliente from catalogo.Cliente
while @contador < @totalrow
BEGIN
declare @numcliente int 
set @numcliente = (select codcli from #rowidcliente WHERE numrow = @contador)
if (@numcliente < 10)
begin
UPDATE catalogo.Cliente
set codcli = 'C0000' +  @numcliente
where codcli = 'C0' + @numcliente
end
else
begin
UPDATE catalogo.Cliente
set codcli = 'C000' +  @numcliente
WHERE codcli = 'C' + @numcliente
end
set @contador = @contador + 1;
END
GO
---Prueba SP
exec pa_uCamposCliente
go
select * from catalogo.Cliente
GO
--Procedimiento Almacenado para la actualizacion de las clave primaria codPed y codcli de la tabla CabezeraP
CREATE PROCEDURE pa_uCamposCabezeraP AS
declare @contador int, @totalrow int 
set @contador = 1
set @totalrow = (select COUNT(*) from movimiento.CabezeraP)
CREATE TABLE #rowidped (numrow int, codped int, codcli int)
select ROW_NUMBER() OVER (ORDER BY codped, codcli) AS numrow, CAST(SUBSTRING(codped,2,2) AS INT) as codped, CAST(SUBSTRING(codcli,2,2) AS INT)  
as codcli into #rowidped from movimiento.CabezeraP
while @contador < @totalrow
BEGIN
declare @numpedido int, @numcliente int 
set @numpedido = (select codped from #rowidped WHERE numrow = @contador)
set @numcliente = (select codcli from #rowidped WHERE numrow = @contador)
--Codigo de Pedido
if (@numpedido < 10)
begin
UPDATE movimiento.CabezeraP
set codped = 'PE0000000' +  CAST(@numpedido AS varchar)
where codped = 'R0' + CAST (@numpedido AS varchar)
end
else
begin
UPDATE movimiento.CabezeraP
set codped = 'PE000000' +  @numpedido
WHERE codped = 'R' + @numpedido
end
--Codigo de Cliente
if (@numcliente < 10)
begin
UPDATE movimiento.CabezeraP
set codcli = 'C0000' +  @numcliente
where codcli = 'C0' + @numcliente
end
else
begin
UPDATE movimiento.CabezeraP
set codcli = 'C000' +  @numcliente
WHERE codcli = 'C' + @numcliente
end
set @contador = @contador + 1;
END
GO
--Procedimiento Almacenado para la actualizacion de las clave primaria codPed de la tabla DetalleP
CREATE PROCEDURE pa_uCamposDetalleP AS
declare @contador int, @totalrow int 
set @contador = 1
set @totalrow = (select COUNT(*) from movimiento.DetalleP)
CREATE TABLE #rowidet (numrow int, codped int)
select ROW_NUMBER() OVER (ORDER BY codped) AS numrow, CAST(SUBSTRING(codped,2,2) AS INT) as codped  
into #rowidet from movimiento.DetalleP
while @contador < @totalrow
BEGIN
declare @numpedido int
set @numpedido = (select codped from #rowidet WHERE numrow = @contador)
--Codigo de Pedido
if (@numpedido < 10)
begin
UPDATE movimiento.DetalleP
set codped = 'PE0000000' +  @numpedido
where codped = 'R0' + @numpedido
end
else
begin
UPDATE movimiento.DetalleP
set codped = 'PE000000' +  @numpedido
WHERE codped = 'R' + @numpedido
end
set @contador = @contador + 1;
END

--Pruebas
select ROW_NUMBER() OVER (ORDER BY codcli) AS numrow, CAST(SUBSTRING(codcli,2,2) AS INT) 
as codcli from movimiento.CabezeraP
select * from movimiento.CabezeraP
select ROW_NUMBER() OVER (ORDER BY codped, codcli) AS numrow,
CAST(SUBSTRING(codped,2,2) AS INT) as codped, 
CAST(SUBSTRING(codcli,2,2) AS INT) as codcli  from movimiento.CabezeraP