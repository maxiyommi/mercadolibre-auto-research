---
name: mercadolibre-auto-research
description: |
  Investiga publicaciones activas en Mercado Libre Argentina para determinar el precio óptimo de venta de un auto usado. Genera informe completo: tabla de relevamiento con tiempo publicado por publicación, análisis de estancadas vs competitivas, recomendación de precio con estrategia de negociación, tips de publicación, descripción lista para copiar en ML, y guía de 12 fotos.

  Activar SIEMPRE ante: "quiero vender mi auto", "¿cuánto vale mi [marca/modelo]?", "¿a qué precio publico?", "investigá el mercado para mi auto", "¿está bien el precio que le puse?", "ayudame a publicar mi auto", "research de precios de autos", o cualquier combinación de Mercado Libre + auto + precio.
---

# Research de Mercado en Mercado Libre para Venta de Auto Usado

## Objetivo
Investigar publicaciones activas en Mercado Libre Argentina para determinar el precio óptimo de venta de un auto usado. El output es un informe completo con datos del mercado, análisis de competitividad y recomendaciones para la publicación.

---

## Datos de entrada requeridos del usuario
Antes de comenzar, confirmar con el usuario:
- **Marca y modelo** (ej: Volkswagen Fox)
- **Versión/motorización** (ej: 1.6 Comfortline)
- **Año**
- **Kilómetros**
- **Cantidad de puertas**
- **Combustible** (nafta, diesel, GNC)
- **Estado general** (excelente, muy bueno, bueno, regular)
- **Tipo de vendedor** (dueño directo / agencia)
- **Cantidad de dueños** (1era mano, 2da mano, etc.)
- **Extras o modificaciones relevantes** (si aplica)
- **Moneda de preferencia para el informe** (pesos ARS / dólares USD / ambas — **por defecto: ambas**)
- **Moneda de las publicaciones a relevear** (pesos ARS / dólares USD / ambas — **por defecto: ambas**)

---

## Paso 1: Búsqueda inicial en Mercado Libre

> **Fuente exclusiva:** toda la investigación se realiza **únicamente en Mercado Libre Argentina** (`https://autos.mercadolibre.com.ar/`). No buscar ni referenciar precios de otras plataformas (OLX, Autocosmos, Demotores, concesionarias, etc.).

### Construcción de la URL de búsqueda
Navegar a `https://autos.mercadolibre.com.ar/` y aplicar filtros:
- Marca → modelo → año
- Combustible
- Cantidad de puertas
- Versión (si está disponible como filtro)
- Tipo de vendedor: "Dueño directo" (si aplica)

### Lectura de resultados
Usar `get_page_text` sobre la página de resultados. Los datos estructurados (JSON-LD `@type: Product`) dentro del HTML contienen:
- `name`: nombre de la publicación
- `offers.price`: precio
- `offers.priceCurrency`: moneda (ARS o USD)
- `offers.url`: link a la publicación

Extraer todos los resultados de la primera página. Si hay más de una página, navegar a las siguientes.

**Filtro por moneda:** según la preferencia del usuario:
- **Solo ARS:** ignorar publicaciones con `priceCurrency: USD`
- **Solo USD:** ignorar publicaciones con `priceCurrency: ARS`
- **Ambas (default):** incluir todas las publicaciones sin filtrar por moneda

**Dato clave:** registrar la cantidad total de publicaciones activas que arroja la búsqueda — indica el nivel de oferta/competencia para ese modelo.

---

## Paso 2: Relevamiento individual de cada publicación

Para cada publicación, navegar a la URL individual y extraer con `find` o `get_page_text`:

1. **Precio** (en ARS o USD)
2. **Kilómetros**
3. **"Publicado hace X días/meses/año"** — dato crítico, solo disponible dentro de cada publicación, no en el listado general
4. **Ubicación**
5. **Versión exacta** (Comfortline, Trendline, Pack, etc.)
6. **Detalles relevantes** de la descripción (único dueño, estado, extras)

### Cómo encontrar el dato de tiempo publicado
Usar `find` con query `"publicado hace días"` en cada publicación. El resultado tiene el formato: `"2012" (XXX.XXX km · Publicado hace X días/meses/año)`.

### Optimización de velocidad
- Navegar publicación por publicación reutilizando la misma pestaña (no abrir múltiples pestañas simultáneas).
- Usar `find` con query específico en vez de `get_page_text` completo — es más rápido y directo.
- Los datos de precio, km y ubicación ya están en el listado general (JSON-LD). El único dato que requiere entrar a cada publicación es **"publicado hace"**.

---

## Paso 3: Análisis de datos

### Clasificación por antigüedad de publicación

| Categoría | Tiempo publicado | Interpretación |
|-----------|-----------------|----------------|
| **Recientes** | 0–14 días | Aún no se puede evaluar si el precio funciona |
| **En evaluación** | 15–30 días | Si no se vendió, el precio podría estar un poco alto |
| **Estancadas** | +30 días | Precio claramente por encima del mercado, o problema con el auto/publicación |

### Identificar publicaciones comparables
Filtrar las publicaciones más similares al auto del usuario:
- Kilómetros (rango ±30.000 km)
- Versión exacta (misma o equivalente)
- Estado (si se puede inferir de la descripción/fotos)

### Detectar anomalías
- **Precios sospechosamente bajos:** posibles estafas, problemas legales/mecánicos, o errores de publicación.
- **Precios altos estancados:** confirman el techo de precio que el mercado no acepta.
- **Publicaciones en USD vs ARS:** si el informe incluye ambas monedas, obtener el tipo de cambio oficial BNA (tipo **vendedor**) en el momento del análisis desde https://www.bna.com.ar/Personas y usarlo para **todas** las conversiones del informe sin excepción. Indicar el valor exacto y la fecha de consulta en el encabezado del informe.

### Calcular rangos de precio
Si el informe incluye **ambas monedas**, presentar los rangos en las dos usando siempre el tipo de cambio oficial BNA (vendedor) consultado al inicio en https://www.bna.com.ar/Personas. Ej: "$12.000.000 ARS (≈ USD 9.200 al oficial BNA vendedor del [fecha])".
- **Precio mínimo real:** el precio más bajo razonable (excluyendo anomalías).
- **Precio promedio:** promedio de publicaciones comparables recientes (0–14 días).
- **Precio techo:** el precio más alto que algún vendedor pide con km similares — usualmente coincide con publicaciones estancadas.

---

## Paso 4: Recomendación de precio

### Fórmula de decisión
```
Precio sugerido = Promedio de publicaciones comparables recientes − 5% a 10% ajuste por "venta efectiva"
```

Si el usuario pidió **ambas monedas**, expresar **todos** los precios del informe (publicaciones, rangos, recomendación) en ARS con su equivalente en USD, usando siempre el mismo tipo de cambio oficial BNA (vendedor) consultado al inicio desde https://www.bna.com.ar/Personas. Ejemplo: "Publicar a $12.000.000 ARS (≈ USD 9.200 al oficial BNA vendedor del [fecha])".

### Factores que suman valor (justifican precio en el rango alto)
- 1era mano / único dueño
- Services en concesionario oficial con comprobantes
- Pocos km para la antigüedad
- Extras de equipamiento (cuero, techo, pantalla)
- VTV vigente, libre de deuda
- Cubiertas nuevas

### Factores que restan valor (justifican precio en el rango bajo)
- Varios dueños
- Km altos para la antigüedad
- Sin service comprobable
- Detalles de chapa/pintura
- Cubiertas gastadas
- Falta de equipamiento respecto a la versión estándar

### Estrategia de publicación
Siempre recomendar al usuario:
1. **Precio de publicación:** 5–8% por encima del precio objetivo real (margen de negociación).
2. **Precio piso de negociación:** el precio mínimo aceptable.
3. **Plan B:** si no hay consultas serias en 15–20 días, bajar al precio piso.

---

## Paso 5: Generación del informe

El informe final debe incluir las siguientes secciones en orden:

### 1. Encabezado
Marca, modelo, versión, año, km del auto del usuario. Fecha del análisis, fuente, filtros usados, cantidad de publicaciones encontradas.

### 2. Tabla de relevamiento
Todas las publicaciones con: precio, km, tiempo publicado, ubicación, señal (⚠️ ESTANCADA / Reciente / En juego / ⭐ MÁS COMPARABLE), y link a la publicación.

### 3. Análisis de publicaciones estancadas (+30 días)
Tabla con precio, km, tiempo y explicación de por qué no se venden.

### 4. Análisis de publicaciones competitivas
Tabla con precio, km, tiempo y por qué funcionan.

### 5. Recomendación de precio
- Precio sugerido de publicación
- Precio piso de negociación
- Estrategia de ajuste temporal (si no hay consultas en X días, bajar a Y)

### 6. Tips para la publicación
- Destacar diferenciadores (1era mano, service, estado)
- Fotos recomendadas (12 fotos: 5 exterior, 4 interior, 3 mecánica/detalles)
- Responder rápido las consultas
- Indicar si acepta permuta o es precio negociable

### 7. Descripción sugerida para ML
Texto modelo para copiar y pegar, adaptado al auto del usuario. Estructura:
- Título (Marca Modelo Versión — Año — Único dueño / N dueños)
- Datos principales (km, motor, caja, equipamiento)
- Estado general
- Documentación (papeles al día, VTV, deudas)
- Cierre (motivo de venta, apertura a ofertas, cómo contactar)

Presentar como texto corrido sin blockquotes, listo para copiar directamente.

### 8. Guía de fotos
12 fotos recomendadas con descripción de encuadre, además de tips de iluminación y presentación. Ver estructura detallada en la sección **Guía de fotos** más abajo.

---

## Guía de fotos (referencia para sección 8 del informe)

Mercado Libre permite hasta 12 fotos por publicación de autos. Usar las 12 con luz natural (al aire libre, de día, sin sol directo fuerte). Nunca fotos de noche ni en garajes oscuros.

**Exterior (5 fotos):**
1. **Frente ¾ (foto principal):** esquina delantera izquierda, frente + lateral conductor. Auto limpio, fondo despejado. Es la foto que "vende".
2. **Trasera ¾:** esquina trasera derecha, cola + lateral acompañante.
3. **Lateral conductor:** perfil completo lado izquierdo. Muestra estado de chapa y llantas.
4. **Lateral acompañante:** perfil completo lado derecho. Si hay algún detalle estético, mejor mostrarlo que ocultarlo.
5. **Frente directo:** de frente, mostrando ópticas, parrilla, paragolpes.

**Interior (4 fotos):**
6. **Tablero completo desde asiento trasero:** tablero, volante, consola central, asientos delanteros.
7. **Asientos traseros:** estado de la tapicería trasera.
8. **Consola central / radio:** detalle del equipamiento (radio, aire, levantavidrios).
9. **Kilometraje en el tablero:** foto nítida del odómetro con el auto encendido. Prueba de transparencia.

**Mecánica y detalles (3 fotos):**
10. **Motor:** capot abierto, foto general. Mejor si está limpio.
11. **Cubiertas:** al menos una cubierta donde se vea el dibujo del neumático.
12. **Baúl abierto:** espacio y estado del tapizado. Si tiene auxilio y herramienta, que se vean.

**Tips para las fotos:**
- Lavá el auto antes (interior aspirado, tablero limpio, vidrios sin marcas).
- Luz natural de mañana o tardecita. Nunca con flash ni en garaje oscuro.
- Fondo limpio: estacionamiento vacío o vereda despejada.
- Celular siempre horizontal (modo paisaje). Jamás vertical.
- Sin filtros. Foto real, sin editar colores.
- Si hay algún detalle (rayón, marca), mostrarlo. Ocultarlo genera desconfianza.

---

## Notas técnicas para el agente

### Navegación en Mercado Libre
- URL base de autos: `https://autos.mercadolibre.com.ar/`
- Los filtros se aplican como segmentos en la URL (marca/modelo/combustible/etc.)
- El filtro de dueño directo se accede desde los filtros laterales de la búsqueda
- Las publicaciones individuales están en `https://auto.mercadolibre.com.ar/MLA-XXXXXXXXX-...`

### Extracción de datos
- **Listado general:** los datos estructurados JSON-LD (`@graph` con `@type: Product`) contienen precio, moneda, nombre y URL. Permite extraer todo de una sola vez sin parsear el HTML visual.
- **Publicación individual:** el dato "publicado hace X" solo está disponible adentro de cada publicación. Usar `find` con query `"publicado hace días"` es el método más eficiente.
- El resultado de `find` tiene formato: `"AÑO" (XXX.XXX km · Publicado hace X días/meses/año)`.

### Eficiencia
1. Extraer todos los datos del listado general (precio, km, URL, ubicación) en una sola lectura.
2. Luego recorrer cada URL individual únicamente para obtener "publicado hace".
3. Reutilizar una sola pestaña para navegar publicación por publicación.
4. No abrir múltiples pestañas simultáneas (ineficiente, puede generar errores).

### Formato de salida
- Entregar el informe en **Markdown** en el chat.
- Si el usuario tiene una página de Notion, ofrecer subirlo allí.
- Los links a publicaciones deben ser funcionales y apuntar a la URL de ML.
- La descripción sugerida debe presentarse como texto corrido sin blockquotes — lista para copiar directamente a ML.
