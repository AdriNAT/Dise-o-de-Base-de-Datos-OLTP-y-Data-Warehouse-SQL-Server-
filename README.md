# Diseño-de-Base-de-Datos-OLTP-y-Data-Warehouse-SQL-Server-

Proyecto OLTP y Data Warehouse basado en Northwind (SQL Server)

\# Proyecto: Data Warehouse de Ventas (Northwind)



Este repositorio contiene el diseño, desarrollo e implementación de un modelo analítico (Data Warehouse) basado en la base de datos transaccional (OLTP) de Northwind. 



\*\*Dominio del negocio seleccionado:\*\* Ventas.



\---



\##  1. Modelo Transaccional (OLTP)

El modelo de origen está diseñado para soportar la operativa diaria de la empresa (procesamiento de transacciones).

\* \*\*Dominio:\*\* Gestión de ventas, clientes, empleados, inventarios de productos y envíos.

\* \*\*Reglas de negocio básicas:\*\* 

&#x20; - Un Cliente puede realizar muchos pedidos.

&#x20; - Cada pedido es procesado por un Empleado y enviado por un Transportista (Shipper).

&#x20; - Un pedido puede contener múltiples detalles de productos.



\*(El diagrama y los scripts de origen se encuentran en la carpeta `1\_OLTP`)\*.



\---



\##  2. Modelo Analítico (Data Warehouse - DW)

Para facilitar el análisis de toma de decisiones, se diseñó un modelo dimensional basado en un \*\*Esquema de Estrella\*\*.



\* \*\*Tabla de Hechos (Fact Table):\*\* `FactSales`

\* \*\*Métricas Principales (Facts):\*\* 

&#x20; - Cantidad (`Quantity`)

&#x20; - Precio Unitario (`UnitPrice`)

&#x20; - Descuento (`Discount`)

&#x20; - Total de Línea (`LineTotal` - Persistido como tipo `MONEY`).

\* \*\*Dimensiones (Dimensions):\*\*

&#x20; - `DimCustomer`: Datos del cliente.

&#x20; - `DimEmployee`: Datos del vendedor.

&#x20; - `DimProduct`: Detalles del catálogo de productos y proveedores.

&#x20; - `DimShipper`: Datos de la empresa de transporte.

&#x20; - `DimDate`: Dimensión de tiempo para análisis por fechas.



\*(El diagrama de estrella y el script de carga ETL se encuentran en la carpeta `2\_DW`)\*.



\---



\##  3. Proyecto DACPAC (SQL Server Data Tools)

La estructura del Data Warehouse fue modelada utilizando un proyecto de Visual Studio (SSDT). Esto permite el control de versiones del esquema y despliegues estandarizados.



La carpeta `NorthWind\_Project` contiene la solución compilada.

\*\*Ubicación del empaquetado:\*\* `NorthWind\_Project/bin/Debug/NorthWind\_Project.dacpac`



\---



\##  Instrucciones de Despliegue



\### Despliegue de Esquema vía DACPAC 

1\. Abrir SQL Server Management Studio (SSMS).

2\. Hacer clic derecho sobre "Bases de datos" > \*\*Implementar aplicación de capa de datos...\*\*

3\. Cargar el archivo `NorthWind\_Project.dacpac` y seguir el asistente.

4\. Una vez generada la estructura, ejecutar el script de inserción (ETL) ubicado en `2\_DW/Script\_Poblar\_DW.sql`.

