use [TSQL]
go


/*
1. Yo necesito crear un proceso automático que haga las siguientes tareas:
• Obtener la Cantidad de Ordenes y la suma Total del monto de todas sus Ordenes
por cliente y por año, todo debe ser leído por el parametro @CodigoCliente.
• Tablas: Sales.Orders y Sales.OrderDetails
• ***Pasos:***
• 1° Voy a crear una tabla con la siguiente estructura:
• CustID, Año, Conteo_Ord, Suma_VentaTotal
• 2° Insertar los registros a esa tabla cada vez que ejecuto mi procedimiento

*/

create table Tabla
(
	CustID int,
	Anio int,
	Conteo_Ord int,
	Suma_VentaTotal float
)
go

create procedure sp_pregunta1(@CodigoCliente int)
as
begin
	insert into Tabla(CustID, Anio, Conteo_Ord, Suma_VentaTotal)
	select 
		o.custid, 
		year(o.orderdate)			as	anio,
		COUNT(distinct(o.orderid))	as	conteo_ord,
		SUM(c.unitprice*c.qty)		as suma_Total
	from Sales.Orders as o 
	inner join Sales.OrderDetails as c on o.orderid = c.orderid
	where o.custid = @CodigoCliente
end
go

exec sp_pregunta1 10
go

select * from Tabla
go

/*
2. Convierte la siguiente consulta (tablas derivadas) a una consulta con CTEs (USE TSQL):

SELECT año_orden, COUNT(DISTINCT Cod_Cliente) AS cant_clientes
FROM (SELECT YEAR(orderdate) AS año_orden ,custid AS Cod_Cliente
FROM Sales.Orders) AS tablita
GROUP BY año_orden
HAVING COUNT(DISTINCT Cod_Cliente) > 70;

*/

with CTE_tablita
as (
	SELECT YEAR(orderdate)	as año_orden,
			custid			as Cod_Cliente
	FROM Sales.Orders)

select	año_orden, 
		COUNT(DISTINCT Cod_Cliente) AS cant_clientes
from CTE_tablita as CTE
group by año_orden
having COUNT(DISTINCT Cod_Cliente) > 70

/*
3. El área de programación necesita una query para consultar las ventas a través del
parámetro: nombre del país, crea un procedimiento almacenado que ayude a este
requerimiento. (usar tabla de Orders y Customers en TSQL)
*/

create procedure sp_pregunta3(@pais varchar(15))
as
begin
	select 
		o.orderid,
		o.orderdate,
		c.custid,
		c.contactname
	from Sales.Orders as o
	inner join Sales.Customers as c on o.custid = c.custid
	where c.country = @pais
end
go

exec sp_pregunta3 'Brazil'
go

/*
4. -Caso: Obtener la cantidad de productos que hay por categoryid y obtener las categorías
que tengan más de 12 productos. (USE TSQL; [Production].[Products])
*/

select 
	c.categoryid,
	c.categoryname,
	COUNT(p.productid) as [Cant. Productos]
from Production.Products as p 
inner join Production.Categories as c on p.categoryid = c.categoryid
group by c.categoryid,categoryname
having COUNT(p.productid) > 12
go
