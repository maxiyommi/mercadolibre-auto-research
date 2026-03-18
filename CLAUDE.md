# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Que es este repo

Skill standalone para Claude (Claude.ai Projects y Claude Code) que investiga publicaciones activas en **Mercado Libre Argentina** para determinar el precio optimo de venta de un auto usado. Es un prompt estructurado en Markdown que Claude usa como instrucciones especializadas.

## Estructura del repo

- **`SKILL.md`** — La skill completa: datos de entrada, flujo de investigacion (8 pasos), logica de analisis, formato de informe y guia de fotos.
- **`README.md`** — Documentacion para el usuario: instalacion, uso, ejemplos, contribuciones.
- **`mercadolibre-auto-research.skill`** — Archivo compilado (ZIP con SKILL.md adentro) para subir directamente a Claude.ai Projects. Se regenera con `./build.sh`.
- **`build.sh`** — Regenera el `.skill` desde `SKILL.md`. Ejecutar siempre despues de modificar SKILL.md.

## Flujo de ejecucion

1. La skill se activa cuando el usuario menciona vender un auto, consultar precios o publicar en Mercado Libre.
2. Claude confirma los datos del vehiculo (marca, modelo, año, km, version, etc.).
3. Navega a `autos.mercadolibre.com.ar`, aplica filtros y extrae datos via JSON-LD.
4. Entra a cada publicacion individual para obtener "publicado hace X dias".
5. Clasifica publicaciones (recientes, en evaluacion, estancadas), calcula rangos y recomienda precio.
6. Genera informe completo: tabla de relevamiento, analisis, precio sugerido, descripcion para ML y guia de 12 fotos.

## Sincronizacion SKILL.md <-> .skill

Un **pre-commit hook** regenera automaticamente `mercadolibre-auto-research.skill` cada vez que `SKILL.md` esta en staging. No hace falta correr `build.sh` manualmente — el hook lo ejecuta y agrega el `.skill` actualizado al commit.

Si se necesita regenerar sin commitear: `./build.sh`

## Dependencias externas

- Fuente de datos: Mercado Libre Argentina (`https://autos.mercadolibre.com.ar/`)
- Tipo de cambio: BNA oficial vendedor (`https://www.bna.com.ar/Personas`)
