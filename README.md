# 🚗 mercadolibre-auto-research

**Skill para Claude** que investiga publicaciones activas en Mercado Libre Argentina para determinar el precio óptimo de venta de un auto usado.

## ¿Qué hace esta skill?

Cuando le decís a Claude que querés vender tu auto, esta skill lo convierte en un asesor de mercado que:

- 🔍 **Investiga** todas las publicaciones activas en MercadoLibre Argentina para tu marca/modelo
- 📊 **Analiza** qué publicaciones están estancadas (más de 30 días) vs. las que sí se venden
- 💰 **Recomienda** un precio de publicación con margen de negociación y un precio piso
- 📝 **Genera** una descripción lista para copiar directamente en ML
- 📸 **Guía** de 12 fotos con encuadres, iluminación y consejos de presentación

### Output del informe

1. Tabla de relevamiento con precio, km, tiempo publicado y señal de competitividad
2. Análisis de publicaciones estancadas (+30 días) y por qué no se venden
3. Análisis de publicaciones competitivas y por qué funcionan
4. Recomendación de precio + estrategia de ajuste temporal
5. Tips de publicación y diferenciadores
6. Descripción lista para copiar en MercadoLibre
7. Guía de 12 fotos con descripción de encuadre

---

## Instalación

### Requisitos previos

- Cuenta en [Claude.ai](https://claude.ai) con acceso a **Projects**
- Acceso a la sección **Skills** dentro de tu proyecto

### Pasos

1. **Descargá** el archivo `mercadolibre-auto-research.skill` desde la sección [Releases](https://github.com/maxiyommi/mercadolibre-auto-research/releases) de este repositorio.

2. **Abrí Claude.ai** y navegá a tu proyecto (o creá uno nuevo).

3. En la barra lateral del proyecto, hacé clic en **"+ Add skill"** o el ícono de skills.

4. **Subí** el archivo `.skill` descargado.

5. ✅ La skill queda activa automáticamente. Claude la va a usar cada vez que detecte una intención de venta de auto.

### Instalación vía skills.sh (para Claude Code y otros agentes)

Si usás Claude Code, Cursor, Windsurf u otro agente compatible:

```bash
npx skills add maxiyommi/mercadolibre-auto-research
```

La skill queda disponible en: [skills.sh/maxiyommi/mercadolibre-auto-research](https://skills.sh/maxiyommi/mercadolibre-auto-research/mercadolibre-auto-research)

### Instalación manual (desde el archivo SKILL.md)

Si preferís instalar la skill manualmente:

1. Cloná este repositorio:
   ```bash
   git clone https://github.com/maxiyommi/mercadolibre-auto-research.git
   ```

2. Dentro de tu proyecto en Claude.ai, creá una nueva skill y pegá el contenido de `mercadolibre-auto-research/SKILL.md`.

---

## Uso

### Activación automática

La skill se activa sola cuando Claude detecta frases como:

- *"Quiero vender mi auto"*
- *"¿Cuánto vale mi [marca/modelo]?"*
- *"¿A qué precio publico mi [auto]?"*
- *"Investigá el mercado para mi auto"*
- *"¿Está bien el precio que le puse?"*
- *"Ayudame a publicar mi auto"*
- Cualquier combinación de **Mercado Libre + auto + precio**

### Datos que Claude va a pedirte

Antes de arrancar la investigación, Claude te va a confirmar:

| Dato | Ejemplo |
|------|---------|
| Marca y modelo | Volkswagen Fox |
| Versión/motorización | 1.6 Comfortline |
| Año | 2013 |
| Kilómetros | 95.000 |
| Cantidad de puertas | 5 |
| Combustible | Nafta |
| Estado general | Muy bueno |
| Tipo de vendedor | Dueño directo |
| Cantidad de dueños | 1era mano |
| Extras relevantes | GNC instalado |
| Moneda del informe | ARS y USD (default) |

### Ejemplo de uso

```
Vos: "Quiero vender mi Volkswagen Fox 2013, 1.6 Comfortline, 95.000 km, nafta, 5 puertas. 
      Soy el primer y único dueño. ¿A qué precio lo publico?"

Claude: [activa la skill, navega MercadoLibre, analiza publicaciones y entrega el informe completo]
```

---

## Notas técnicas

- **Fuente exclusiva:** MercadoLibre Argentina (`https://autos.mercadolibre.com.ar/`). No se usan otras plataformas.
- **Tipo de cambio:** si el informe incluye ambas monedas (ARS + USD), Claude consulta el tipo de cambio oficial BNA vendedor en tiempo real desde `https://www.bna.com.ar/Personas`.
- **Navegación:** Claude recorre el listado general para extraer datos estructurados (JSON-LD) y luego entra a cada publicación individual para obtener el dato "publicado hace X días".

---

## Contribuciones

¡Las contribuciones son bienvenidas! Si querés mejorar la skill:

1. **Forkeá** este repositorio
2. **Creá** una rama para tu feature: `git checkout -b mejora/nombre-de-la-mejora`
3. **Hacé tus cambios** en `mercadolibre-auto-research/SKILL.md`
4. **Commiteá:** `git commit -m "feat: descripción de la mejora"`
5. **Pusheá:** `git push origin mejora/nombre-de-la-mejora`
6. **Abrí un Pull Request** describiendo qué cambiaste y por qué

### Ideas para contribuir

- [ ] Soporte para motos (`motos.mercadolibre.com.ar`)
- [ ] Soporte para camionetas y pickups con filtros adicionales (tracción, largo de caja)
- [ ] Comparación automática con Autocosmos o Demotores como referencia secundaria
- [ ] Generación del informe directo en Notion vía MCP
- [ ] Exportar el relevamiento como tabla en Google Sheets

### Reportar issues

Si encontrás un bug o tenés una sugerencia, [abrí un issue](https://github.com/maxiyommi/mercadolibre-auto-research/issues) con:
- Descripción del problema
- Marca/modelo que usaste para la prueba
- El output que obtuvo Claude
- El output esperado

---

## Licencia

MIT — libre para usar, modificar y distribuir. Si lo usás en tus proyectos, una mención es siempre bienvenida. 🙌

---

Hecho con ❤️ por [Cumbre IA](https://cumbre.cloud) · Buenos Aires, Argentina