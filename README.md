# mercadolibre-auto-research

Skill para Claude que investiga publicaciones activas en **Mercado Libre Argentina** para determinar el precio optimo de venta de un auto usado.

## Instalacion

### Via skills.sh (Claude Code, Cursor, Windsurf)

```bash
npx skills add maxiyommi/mercadolibre-auto-research
```

### Via Claude.ai Projects

1. Descargar `mercadolibre-auto-research.skill` desde [Releases](https://github.com/maxiyommi/mercadolibre-auto-research/releases)
2. En Claude.ai, abrir tu proyecto y hacer clic en **"+ Add skill"**
3. Subir el archivo `.skill` descargado

### Manual

```bash
git clone https://github.com/maxiyommi/mercadolibre-auto-research.git
```

Copiar el contenido de `SKILL.md` como skill en tu proyecto de Claude.ai.

## Uso

La skill se activa **automaticamente** cuando Claude detecta pedidos relacionados:

```
"Quiero vender mi auto"
-> Activa: mercadolibre-auto-research

"¿Cuanto vale mi Volkswagen Fox 2013?"
-> Activa: mercadolibre-auto-research

"Investiga el mercado para mi auto"
-> Activa: mercadolibre-auto-research
```

### Datos que Claude va a pedirte

| Dato | Ejemplo |
|------|---------|
| Marca y modelo | Volkswagen Fox |
| Version/motorizacion | 1.6 Comfortline |
| Año | 2013 |
| Kilometros | 95.000 |
| Cantidad de puertas | 5 |
| Combustible | Nafta |
| Estado general | Muy bueno |
| Tipo de vendedor | Dueño directo |
| Cantidad de dueños | 1era mano |
| Extras relevantes | GNC instalado |
| Moneda del informe | ARS y USD (default) |

### Output del informe

1. Tabla de relevamiento con precio, km, tiempo publicado y señal de competitividad
2. Analisis de publicaciones estancadas (+30 dias) y por que no se venden
3. Analisis de publicaciones competitivas y por que funcionan
4. Recomendacion de precio + estrategia de ajuste temporal
5. Tips de publicacion y diferenciadores
6. Descripcion lista para copiar en MercadoLibre
7. Guia de 12 fotos con descripcion de encuadre

## Estructura

```
mercadolibre-auto-research/
├── SKILL.md                              <- Skill completa: flujo, analisis, formato de informe
├── README.md                             <- Documentacion de uso e instalacion
├── CLAUDE.md                             <- Guia para Claude Code sobre el repo
├── mercadolibre-auto-research.skill      <- Archivo compilado para Claude.ai Projects
├── build.sh                              <- Regenera .skill desde SKILL.md
└── .gitignore
```

## Como funciona

1. Claude confirma los datos del vehiculo con el usuario.
2. Navega a `autos.mercadolibre.com.ar` con filtros (marca, modelo, año, combustible, puertas).
3. Extrae datos estructurados (JSON-LD) del listado general.
4. Entra a cada publicacion individual para obtener "publicado hace X dias".
5. Clasifica publicaciones por antiguedad (recientes, en evaluacion, estancadas).
6. Calcula rangos de precio y genera recomendacion con margen de negociacion.
7. Entrega informe completo con descripcion para ML y guia de 12 fotos.

## Sincronizacion SKILL.md <-> .skill

El archivo `.skill` es un ZIP que contiene `SKILL.md`. Un **pre-commit hook** lo regenera automaticamente cada vez que `SKILL.md` se incluye en un commit — no hace falta hacer nada manual.

Para regenerar sin commitear:

```bash
./build.sh
```

## Notas tecnicas

- **Fuente exclusiva:** Mercado Libre Argentina (`https://autos.mercadolibre.com.ar/`)
- **Tipo de cambio:** BNA oficial vendedor (`https://www.bna.com.ar/Personas`) para conversiones ARS/USD
- **Extraccion de datos:** JSON-LD en pagina de resultados + `find` en publicaciones individuales para timestamp

## Contribuciones

1. Forkear este repositorio
2. Crear una rama: `git checkout -b mejora/nombre-de-la-mejora`
3. Hacer cambios en `SKILL.md`
4. Commitear: `git commit -m "feat: descripcion de la mejora"`
5. Pushear: `git push origin mejora/nombre-de-la-mejora`
6. Abrir un Pull Request

### Ideas para contribuir

- [ ] Soporte para motos (`motos.mercadolibre.com.ar`)
- [ ] Soporte para camionetas y pickups con filtros adicionales
- [ ] Comparacion automatica con Autocosmos o Demotores
- [ ] Generacion del informe directo en Notion via MCP
- [ ] Exportar el relevamiento como tabla en Google Sheets

### Reportar issues

[Abrir un issue](https://github.com/maxiyommi/mercadolibre-auto-research/issues) con: descripcion del problema, marca/modelo usado, output obtenido y output esperado.

## Licencia

MIT

## Dependencias

- Mercado Libre Argentina: `https://autos.mercadolibre.com.ar/`
- BNA tipo de cambio: `https://www.bna.com.ar/Personas`
