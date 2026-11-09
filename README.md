# Liger Coffee Shop ☕

> **Borrador de documentación — proyecto en desarrollo.**  
> Este repositorio se plantea como un proyecto de portafolio para mostrar un flujo de trabajo de análisis de datos y machine learning aplicado a una cafetería. La documentación y la arquitectura se irán ajustando a medida que se implemente el proyecto.

## Objetivo

Construir un caso práctico de principio a fin que integre datos de una cafetería con herramientas de ingeniería y análisis de datos. El proyecto busca demostrar conocimientos de:

- **PostgreSQL** para diseñar, almacenar y consultar datos.
- **Neon** como servicio de PostgreSQL en la nube.
- **dbt** para transformar datos y organizar modelos analíticos verificables.
- **Python** para exploración, preparación de datos y machine learning.
- **Power BI** para comunicar resultados mediante un dashboard.

El caso de uso, las preguntas de negocio y el modelo predictivo concreto están **por definir**; no se deben interpretar como funcionalidades ya implementadas.

## Caso de uso (por definir)

La idea es modelar información de ventas y operación de una cafetería y convertirla en análisis útiles para el negocio. Algunas preguntas que podrían orientar el proyecto:

- ¿Qué productos y categorías generan más ventas e ingresos?
- ¿Cómo cambian las ventas por fecha, hora o día de la semana?
- ¿Qué patrones pueden apoyar la planificación de inventario o personal?
- ¿Es posible estimar la demanda futura a partir del histórico disponible?

Estas preguntas son propuestas iniciales y se concretarán después de revisar los datos y su calidad.

## Arquitectura propuesta

```text
Datos de origen
      ↓
PostgreSQL en Neon
      ↓
Transformaciones y pruebas con dbt
      ├──→ Modelos analíticos para Power BI
      └──→ Datos preparados para análisis y machine learning con Python
```

La arquitectura es una propuesta para guiar el desarrollo. Las conexiones y los flujos entre herramientas se documentarán cuando estén implementados.

## Tecnologías

| Tecnología | Uso previsto |
| --- | --- |
| PostgreSQL | Base de datos relacional y consultas SQL. |
| Neon | Alojamiento de la base de datos PostgreSQL. |
| dbt | Transformación, documentación y pruebas de datos. |
| Python | Análisis exploratorio, preparación de datos y experimentación con modelos de machine learning. |
| Power BI | Dashboard de indicadores y comunicación de hallazgos. |
| Jupyter Notebook | Exploración y documentación de experimentos. |

## Estructura actual del repositorio

```text
.
├── data/                 # Directorio para datos del proyecto
├── dbt_coffee/           # Proyecto dbt (scaffold inicial)
├── notebook.ipynb        # Notebook de exploración/experimentos
├── sql/                  # Scripts SQL y estructura de datos
├── main.py               # Archivo Python inicial
└── README.md
```

La estructura puede cambiar conforme avance el trabajo. El proyecto dbt contiene actualmente la estructura inicial de un proyecto; los modelos, pruebas y documentación específicos del caso se completarán durante el desarrollo.

## Estado del proyecto

- [x] Crear la estructura inicial del repositorio.
- [x] Añadir un notebook y directorios iniciales para SQL, datos y dbt.
- [ ] Describir el origen, licencia y diccionario de los datos.
- [ ] Definir el esquema relacional y documentar las decisiones de diseño.
- [ ] Configurar la conexión a Neon mediante variables de entorno.
- [ ] Implementar transformaciones, modelos y pruebas con dbt.
- [ ] Realizar análisis exploratorio y establecer una línea base de machine learning.
- [ ] Evaluar el modelo con métricas adecuadas al problema elegido.
- [ ] Crear y publicar un dashboard de Power BI.
- [ ] Documentar resultados, limitaciones y próximos pasos.

## Requisitos y puesta en marcha

Las instrucciones definitivas se añadirán cuando se establezcan las versiones y dependencias del proyecto. Como preparación, se espera necesitar:

- Python y un entorno virtual.
- PostgreSQL o una base de datos Neon.
- dbt con el adaptador de PostgreSQL correspondiente.
- Power BI Desktop para abrir el archivo del dashboard, cuando se incorpore.

### Configuración segura de Neon

Cuando se implemente la conexión, guardar la cadena de conexión en una variable de entorno local (por ejemplo, `DATABASE_URL`) y no incluir credenciales en el repositorio. Si se usa un archivo `.env`, debe quedar excluido mediante `.gitignore`.

> No hay que copiar credenciales reales a notebooks, archivos SQL, capturas ni documentación pública.

### Comandos dbt (pendientes de configurar)

Desde el directorio `dbt_coffee/`, los comandos habituales para ejecutar un proyecto dbt configurado son:

```bash
dbt debug
dbt build
```

Estos comandos son orientativos: requieren configurar el perfil y las credenciales de conexión antes de ejecutarlos correctamente.

## Datos

La fuente de datos, su licencia, el período cubierto y la descripción de las columnas todavía deben documentarse. Antes de publicar datos, verificar que su licencia permita la redistribución y retirar cualquier información sensible.

## Resultados y entregables (por completar)

- **Análisis:** preguntas de negocio, exploración y principales hallazgos.
- **Datos:** esquema, transformaciones dbt, pruebas y documentación.
- **Machine learning:** objetivo, variables, estrategia de validación, métricas y limitaciones.
- **Dashboard:** enlace o archivo de Power BI e instrucciones para visualizarlo.
- **Demostración:** capturas o breve explicación del flujo completo.

No se presentan resultados ni métricas en este borrador porque aún deben generarse y validarse.

## Próximos pasos

1. Elegir y documentar un conjunto de datos apropiado para el caso de cafetería.
2. Definir preguntas de negocio y el esquema de PostgreSQL.
3. Cargar y validar los datos en Neon.
4. Crear modelos y pruebas en dbt.
5. Explorar los datos y seleccionar un problema de machine learning medible.
6. Construir el dashboard en Power BI y documentar cómo se conecta a los datos.
7. Añadir resultados reproducibles, imágenes y conclusiones a este README.

## Licencia y contacto

- **Licencia:** pendiente de definir.
- **Autor:** Luis (`@sirlluis`).

---

*Documento de trabajo: actualizar las secciones marcadas como pendientes conforme se implementen y verifiquen las funcionalidades.*
