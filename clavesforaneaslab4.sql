
Alter table catalogo.Cliente add Constraint [Ubicado] foreign key([codciu]) references catalogo.Ciudad ([codciu])  on update no action on delete no action 
go
Alter table movimiento.CabezeraP add Constraint [Solicita] foreign key([codcli]) references catalogo.Cliente ([codcli])  on update no action on delete no action 
go
Alter table catalogo.Cliente add Constraint [debetener] foreign key([garante]) references catalogo.Cliente ([codcli])  on update no action on delete no action 
go
Alter table movimiento.DetalleP add Constraint [tienedetalle] foreign key([codped]) references movimiento.CabezeraP ([codped])  on update no action on delete no action 
go
Alter table movimiento.DetalleP add Constraint [perteneceproducto] foreign key([codpro]) references catalogo.Producto ([codpro])  on update no action on delete no action 
go
Alter table movimiento.Provee add Constraint [ProveeProducto] foreign key([codpro]) references catalogo.Producto ([codpro])  on update no action on delete no action 
go
Alter table movimiento.Provee add Constraint [ProveeProveedor] foreign key([codprov]) references catalogo.Proveedor ([codprov])  on update no action on delete no action 
go
Alter table catalogo.Telprov add Constraint [disponede] foreign key([codprov]) references catalogo.Proveedor ([codprov])  on update cascade on delete cascade 
go

