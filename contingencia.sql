--Eliminar Los Procesos Almacenados

DROP PROCEDURE dbo.pa_uCamposClien, dbo.pa_uCamposCabezeraP, dbo.pa_uCamposDetalleP, dbo.pa_uCamposClientes;
--Se eliminan los constrains de clave referencial de la base de datos Pedidos para las tablas Cliente, CabezeraP y DetalleP
Alter table catalogo.Cliente drop Constraint [pk_Cliente];
go
Alter table movimiento.DetalleP drop Constraint [pk_DetalleP];
go
Alter table movimiento.CabezeraP drop Constraint [pk_CabezeraP];
go

Alter table movimiento.DetalleP drop Constraint [tienedetalle];
go
Alter table movimiento.CabezeraP drop Constraint [Solicita];
go
Alter table catalogo.Cliente drop Constraint [debetener]; 
go
Alter table catalogo.Cliente drop Constraint [Ubicado]; 
go
-- Procedimiento Almacenado para la actualizacion de codcli de la tabla Cliente
CREATE TABLE #rowidcliente (numrow int, codcli int)
go
CREATE PROCEDURE pa_uCamposClien AS
declare @contador int, @totalrow int 
set @contador = 1
set @totalrow = (select COUNT(*) from catalogo.Cliente)
select ROW_NUMBER() OVER (ORDER BY codcli) AS numrow, CAST(SUBSTRING(codcli,5,2) AS INT) 
as codcli into #rowidcliente from catalogo.Cliente
while @contador <= @totalrow
BEGIN
declare @numcliente int 
set @numcliente = (select codcli from #rowidcliente WHERE numrow = @contador)
if (@numcliente < 10)
begin
UPDATE catalogo.Cliente
set codcli = 'C0' + CAST(@numcliente AS varchar)
where codcli = 'C0000' +  CAST(@numcliente AS varchar)
end
else
begin
UPDATE catalogo.Cliente
set codcli = 'C' + CAST(@numcliente AS varchar)
WHERE codcli = 'C000' +  CAST(@numcliente AS varchar)
end
set @contador = @contador + 1;
END
GO
---Prueba SP
exec pa_uCamposClien
go
select * from catalogo.Cliente
GO

--Procedimiento Almacenado para la actualizacion de las clave primaria codPed y codcli de la tabla CabezeraP
CREATE TABLE #rowidped (numrow int, codped int, codcli int)
go
CREATE PROCEDURE pa_uCamposCabezeraP AS
declare @contador int, @totalrow int 
set @contador = 1
set @totalrow = (select COUNT(*) from movimiento.CabezeraP)
select ROW_NUMBER() OVER (ORDER BY codped, codcli) AS numrow, 
CAST(SUBSTRING(codped,10,2) AS INT) as codped, CAST(SUBSTRING(codcli,5,2) AS INT)  
as codcli into #rowidped from movimiento.CabezeraP
while @contador <= @totalrow
BEGIN
declare @numpedido int, @numcliente int 
set @numpedido = (select codped from #rowidped WHERE numrow = @contador)
set @numcliente = (select codcli from #rowidped WHERE numrow = @contador)
--Codigo de Pedido
if (@numpedido < 10)
begin
UPDATE movimiento.CabezeraP
set codped = 'R0' + CAST (@numpedido AS varchar)
where codped = 'PE0000000' +  CAST(@numpedido AS varchar)
end
else
begin
UPDATE movimiento.CabezeraP
set codped = 'R' + CAST (@numpedido AS varchar)
WHERE codped = 'PE000000' +  CAST (@numpedido AS varchar)
end
--Codigo de Cliente
if (@numcliente < 10)
begin
UPDATE movimiento.CabezeraP
set codcli = 'C0' + CAST (@numcliente AS varchar)
where codcli = 'C0000' +  CAST (@numcliente AS varchar)
end
else
begin
UPDATE movimiento.CabezeraP
set codcli = 'C' + CAST (@numcliente AS varchar)
WHERE codcli = 'C000' +  CAST (@numcliente AS varchar)
end
set @contador = @contador + 1;
END
GO

--- Prueba
exec pa_uCamposCabezeraP
Go
select * from movimiento.CabezeraP

--Procedimiento Almacenado para la actualizacion de las clave primaria codPed de la tabla DetalleP
CREATE TABLE #rowidet (numrow int, codped int)
GO
CREATE PROCEDURE pa_uCamposDetalleP AS
declare @contador int, @totalrow int 
set @contador = 1
set @totalrow = (select COUNT(*) from movimiento.DetalleP)
select ROW_NUMBER() OVER (ORDER BY codped) AS numrow, CAST(SUBSTRING(codped,10,2) AS INT) as codped  
into #rowidet from movimiento.DetalleP
while @contador <= @totalrow
BEGIN
declare @numpedido int
set @numpedido = (select codped from #rowidet WHERE numrow = @contador)
--Codigo de Pedido
if (@numpedido < 10)
begin
UPDATE movimiento.DetalleP
set codped = 'R0' + CAST (@numpedido AS varchar)
where codped = 'PE0000000' +  CAST (@numpedido AS varchar)
end
else
begin
UPDATE movimiento.DetalleP
set codped = 'R' + CAST (@numpedido AS varchar)
WHERE codped = 'PE000000' +  CAST (@numpedido AS varchar)
end
set @contador = @contador + 1;
END

--Prueba
exec pa_uCamposDetalleP
go
select * from movimiento.DetalleP
-- Procedimiento Almacenado para la actualizacion de garante y codcli de la tabla Cliente
CREATE TABLE #rowidclientes (numrow int, codcli int, garante int)
go
CREATE PROCEDURE pa_uCamposClientes AS
declare @contador int, @totalrow int 
set @contador = 1
set @totalrow = (select COUNT(*) from catalogo.Cliente)
select ROW_NUMBER() OVER (ORDER BY codcli) AS numrow, CAST(SUBSTRING(codcli,5,2) AS INT) 
as codcli, CAST(SUBSTRING(garante,5,2) AS INT) as garante into #rowidclientes from catalogo.Cliente
while @contador <= @totalrow
BEGIN
declare @numcliente int, @numgarante int
set @numgarante = (select garante from #rowidclientes WHERE numrow = @contador)
set @numcliente = (select codcli from #rowidclientes WHERE numrow = @contador)
if (@numcliente < 10)
begin
UPDATE catalogo.Cliente
set codcli = 'C0' + CAST(@numcliente AS varchar)
where codcli = 'C0000' +  CAST(@numcliente AS varchar)
end
else
begin
UPDATE catalogo.Cliente
set codcli = 'C' + CAST(@numcliente AS varchar)
WHERE codcli = 'C000' +  CAST(@numcliente AS varchar)
end

if (@numgarante < 10)
begin
UPDATE catalogo.Cliente
set garante = 'C0' + CAST(@numgarante AS varchar)
where garante = 'C0000' +  CAST(@numgarante AS varchar)
end
else
begin
UPDATE catalogo.Cliente
set garante = 'C' + CAST(@numgarante AS varchar)
WHERE garante = 'C000' +  CAST(@numgarante AS varchar)
end

set @contador = @contador + 1;
END
GO
---Prueba SP
exec pa_uCamposClientes
go
select * from catalogo.Cliente
GO
-- Alter tablas Cliente, DetalleP, CabezeraP

ALTER TABLE catalogo.Cliente
ALTER COLUMN [codcli] varchar(3) NOT NULL
GO
ALTER TABLE movimiento.CabezeraP
ALTER COLUMN [codcli] varchar(3) NOT NULL
GO
ALTER TABLE catalogo.Cliente
ALTER COLUMN [garante] varchar(3) NOT NULL
GO
ALTER TABLE movimiento.DetalleP
ALTER COLUMN codped varchar(3) NOT NULL
GO
ALTER TABLE movimiento.CabezeraP
ALTER COLUMN [codped] varchar(3) NOT NULL
GO

--Se procede a crear las claves primarias y foraneas nuevamente.

Alter table movimiento.CabezeraP add Constraint [Solicita] foreign key([codcli]) references catalogo.Cliente ([codcli]) 
 on update no action on delete no action 
go
Alter table catalogo.Cliente add Constraint [debetener] foreign key([garante]) references catalogo.Cliente ([codcli]) 
 on update no action on delete no action 
go
Alter table movimiento.DetalleP add Constraint [tienedetalle] foreign key([codped]) references movimiento.CabezeraP ([codped])  
on update no action on delete no action 
go

Alter table catalogo.Cliente add Constraint [pk_Cliente] primary key ([codcli]);
go
Alter table movimiento.DetalleP add Constraint [pk_DetalleP] primary key ([numlinea],[codped]);
go
Alter table movimiento.CabezeraP add Constraint [pk_CabezeraP] primary key ([codped]);
