#  Northwind Data Warehouse
# 👥 Integrantes del grupo

| Apellido y Nombre |
| :--- |
| Ayala Torrico Adriana Nicole |
| Poma Limache Alisson Daniela |
| Sotillo Sanchez Luis Antonio |
| Fuentes Rios Beatriz |
| Canaviri Yanahuaya Alexander Sergio | 

---

# 📋 Descripción del proyecto

Dominio de negocio: Ventas y distribución

El sistema gestiona el flujo transaccional completo de una empresa distribuidora mediante una base de datos en 3FN.
Permite administrar de forma centralizada catálogos de productos, carteras de clientes y redes de empleados por territorios , su diseño está optimizado para asegurar la integridad de los datos en procesos complejos de facturación y despacho.

Componentes principales:

✅ OLTP (NorthWindOLTP)
✅ DW (NorthWindDW)
✅ ETL (NorthWindETL)
✅ DACPAC


---
## 📊 Modelo de Datos

A continuación, se presentan los diagramas que representan la estructura técnica del proyecto, desde su origen transaccional hasta su destino analítico.

### 📑Diagrama ER
<img width="976" height="791" alt="image" src="https://github.com/user-attachments/assets/05747896-6d8f-44df-b044-a35efcbd2f77" />


### 📊 Modelo Dimensional (Data Warehouse)

Esta sección detalla la estructura del Almacén de Datos, organizada en una tabla de hechos central y sus dimensiones correspondientes.

## 🗺️ Arquitectura de la Solución

Se implementó un **Modelo Estrella ** orientado al análisis de ventas.

#### 📈 Tabla de Hechos: `FactOrders`
| Campo | Descripción | Tipo |
| :--- | :--- | :---: |
| 📦 `Quantity` | Cantidad de productos vendidos | Métrica |
| 💰 `UnitPrice` | Precio unitario del producto | Métrica |
| 📉 `Discount` | Descuento aplicado a la venta | Métrica |
| 💵 `LineTotal` | Total de la venta (Calculado) | Métrica |

#### 🖇️ Tablas de Dimensión
| Dimensión | Contenido Detallado | Enfoque |
| :--- | :--- | :--- |
| 👥 `DimCustomer` | Información completa y segmentación de **Clientes**. | Atributos |
| 👔 `DimEmployee` | Perfiles de **Empleados y Vendedores** por región. | Atributos |
| 🍎 `DimProduct` | Catálogo de **Productos, Categorías y Proveedores**. | Atributos |
| 🚚 `DimShipper` | Datos de las **Empresas de Envío** y logística. | Atributos |
| 📅 `DimDate` | Eje temporal para análisis (Año, Mes, Día, etc.). | Tiempo |

---
### ⚙️ Flujo del Proceso ETL (Extract, Transform, Load)

El movimiento y refinamiento de los datos se gestionó mediante scripts avanzados de **SQL Server**, siguiendo estas etapas:

| Fase | Acción | Descripción |
| :--- | :--- | :--- |
| 📥 **Extracción** | `Source: OLTP` | Obtención de datos crudos desde la base original **Northwind**. |
| 🔄 **Transformación** | `Data Cleaning` | Limpieza de registros, normalización y conversión de tipos de datos. |
| 📤 **Carga** | `Target: DW` | Inserción optimizada de la información en el **Data Warehouse**. |

---

### 🛠️ Especificaciones Técnicas de Implementación

Para asegurar la calidad de la información analítica, se aplicaron las siguientes reglas de ingeniería:

* **Consistencia Temporal:** Se implementaron funciones de conversión `CAST` y `CONVERT` para alinear todas las fechas con la dimensión de tiempo.
* **Integridad de Datos:** Uso estratégico de `JOINs` complejos entre tablas del OLTP para consolidar métricas precisas en la tabla de hechos.
* **Garantía de Calidad:** Validación de integridad referencial para asegurar que cada hecho (Fact) esté correctamente vinculado a sus dimensiones.
  
---

##  Modelo OLTP

### 🗄️ Diccionario de Entidades (NorthWind OLTP)

| Entidad | Propósito Principal | Campos Clave |
| :--- | :--- | :--- |
| 👥 **Customers** | Almacena la información de contacto y ubicación de los **clientes**. | `CustomerID`, `CompanyName` |
| 👔 **Employees** | Registro del **personal de ventas** y su jerarquía operativa. | `EmployeeID`, `LastName`, `FirstName` |
| 📦 **Products** | Catálogo detallado de **artículos**, precios y niveles de stock. | `ProductID`, `ProductName` |
| 📑 **Orders** | Encabezados de **pedidos** que vinculan clientes, empleados y fechas. | `OrderID`, `OrderDate`, `CustomerID` |
| 🚚 **Shippers** | Listado de **empresas logísticas** encargadas de las entregas. | `ShipperID`, `CompanyName` |

---

### ⚡ Objetos de Control y Lógica (Stored Procedures)

| Objeto Técnico | Función en el Proyecto |
| :--- | :--- |
| 🔄 **RowVersionControl** | Utiliza `timestamp` para detectar qué datos han cambiado desde la última carga. |
| ⚙️ **GetChanges Procedures** | Procedimientos específicos (`GetCustomerChanges`, etc.) para la extracción incremental. |

Normalizacion Aplicada

1FN: Valores atómicos, sin grupos repetidos, clave primaria definida en cada tabla.

2FN: Todos los atributos dependen de la totalidad de la clave primaria. En OrderDetails, Quantity, UnitPrice y Discount dependen del par OrderID + ProductID.

3FN: Sin dependencias transitivas. CategoryName vive en Categories (no en Products); datos del proveedor en Suppliers (no en Products).

##  Data Warehouse (DW)

Contiene el modelo estrella y scripts de carga:

---

### 📊 Especificaciones del Data Warehouse (NorthwindDW)

Esta sección detalla la configuración técnica y la arquitectura dimensional del repositorio analítico diseñado para **Business Intelligence**.

#### 🚀 Características Principales
| Aspecto | Detalle |
| :--- | :--- |
| 🏗️ **Modelo** | Esquema estrella (**Star Schema**) optimizado para consultas analíticas. |
| 🎯 **Grano** | Una fila por cada línea de detalle de pedido (`OrderID` + `ItemID`). |
| 📋 **Tablas** | 8 tablas totales (1 Fact + 6 Dimensiones + 1 Config). |
| 🔢 **Registros FactOrders** | ~2,155 registros procesados con éxito. |
| 💾 **Base de datos** | `NorthwindDW` |
| 📜 **Script de creación** | `scripts/02_DW_Schema_final.sql` |

---

#### 🏛️ Estructura de Tablas — `NorthwindDW/dbo/Tables/`

| Archivo | Tabla | Tipo | Descripción |
| :--- | :--- | :--- | :--- |
| 📈 `FactOrders.sql` | **FactOrders** | **Hecho** | Métricas clave: `Quantity`, `UnitPrice`, `Discount`, `GrossAmount`, `NetAmount`. |
| 👥 `DimCustomer.sql` | **DimCustomer** | **Dimensión** | Perfiles de clientes: `CompanyName`, `City`, `Country`, `Region`. |
| 📅 `DimDate.sql` | **DimDate** | **Dimensión** | Eje temporal: `Day`, `Month`, `Quarter`, `Year` (Histórico 1996–1998). |
| 👔 `DimEmployee.sql` | **DimEmployee** | **Dimensión** | Staff de ventas: `FullName`, `Title` y jerarquía organizacional. |
| 🍎 `DimProduct.sql` | **DimProduct** | **Dimensión** | Catálogo: Productos, categorías y proveedores desnormalizados. |
| 🚚 `DimShipper.sql` | **DimShipper** | **Dimensión** | Logística: Empresas de transporte y datos de contacto. |
| ⚙️ `PackageConfig.sql` | **PackageConfig** | **Config** | Control técnico para la carga incremental (`LastRowVersion`). |

---

### ⚡ Lógica de Transformación y Carga (Stored Procedures)

Para garantizar la integridad y eficiencia del flujo de datos, se implementaron procesos automatizados:

* 🔄 **Sincronización (Merge):** Los procedimientos `DW_MergeDim...` gestionan la lógica de **SCD (Slowly Changing Dimensions)** para insertar nuevos registros y actualizar cambios.
* 📈 **Control Incremental:** Uso de `GetLastPackageRowVersion` para extraer únicamente los cambios nuevos del OLTP, optimizando el tiempo de ejecución.
* 🏗️ **Capa de Staging:** Implementación del esquema `[staging]` como zona de preparación y limpieza de datos (*Data Cleansing*) antes de la carga final.

Diagrama del Modelo Estrella
<img width="1082" height="881" alt="image" src="https://github.com/user-attachments/assets/92a964c4-e29c-46d9-a6a8-c24453e08d8e" />

---

### 2. Ejecutar ETL
---

## 🔄 Proceso ETL — NorthwindETL (SSIS)

El proyecto ETL fue desarrollado con **SQL Server Integration Services (SSIS)** y automatiza la extracción, transformación y carga de datos desde `NorthWindOLTP` hacia `NorthWindDW`.

### 📦 Paquetes SSIS

| Archivo | Tabla destino | Descripción |
| :--- | :--- | :--- |
| `Customer.dtsx` | `DimCustomer` | Carga clientes desde **Customers**. |
| `Employee.dtsx` | `DimEmployee` | Carga empleados desde **Employees**. |
| `Products.dtsx` | `DimProduct` | Carga productos con categoría y proveedor. |
| `Shipper.dtsx` | `DimShipper` | Carga transportistas desde **Shippers**. |
| `Sales.dtsx` | `FactOrders` | Carga hechos de ventas desde ** Orders**. |

 **Orden de ejecución obligatorio:** Las dimensiones deben cargarse antes que la tabla de hechos. `Orders.dtsx` debe ejecutarse siempre al final.

### 🛠️ Consideraciones técnicas:

* Se utilizó conversión de fechas (**CAST**) para asegurar consistencia con la dimensión tiempo.
* Se aplicaron **JOINs** entre tablas OLTP para poblar correctamente la tabla de hechos.
* Se garantizó la **integridad referencial** entre dimensiones y hechos.
---

## 🔄 Proceso ETL — NorthwindETL (SSIS)

El proyecto ETL automatiza la migración de datos desde el entorno transaccional hacia el analítico, asegurando la calidad y consistencia mediante paquetes de **SSIS**.

### 🗺️ Diagrama de Flujo de Datos (Mermaid)

---

## 🔄 Proceso ETL — NorthwindETL (SSIS)

El proceso de carga de datos se realizó mediante SQL Server Integration Services (SSIS), automatizando la extracción, transformación y carga desde **NorthWindOLTP** hacia **NorthWindDW**.

### 🗺️ Flujo de Datos (Arquitectura)

```text
 NorthWindOLTP (Fuente)
       │
       ├─── Customer.dtsx ────▶ DimCustomer
       ├─── Employee.dtsx ────▶ DimEmployee
       ├─── Products.dtsx ────▶ DimProduct
       ├─── Shipper.dtsx  ────▶ DimShipper
       │        └─ (DimDate se genera desde script SQL)
       │
       └─── Orders.dtsx ───────▶ FactOrders
                                   │
                            NorthWindDW (Destino)


```


---

##  Tecnologías Utilizadas
* SQL Server
* SQL Server Management Studio (SSMS)
* Visual Studio 2022 (SSDT)
* GitHub
