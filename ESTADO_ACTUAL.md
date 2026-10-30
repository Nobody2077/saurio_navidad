# Estado actual: dónde nos quedamos

> **▶ EMPEZAR AQUÍ.** Última sesión: 2026-10-29. Próximo paso: Juan responde las
> 6 preguntas de abajo y empezamos la rama del **diciembre mágico**.

## Hecho (ya en `main` y en GitHub)

- Rive quitado.
- 16 sonidos propios sintetizados (`tool/gen_sounds.dart`). Juan los revisó y le
  parecieron bien. Se escuchan en Ajustes → Sonidos.
- `CLAUDE.md` con las reglas del proyecto y `BITACORA.md` con todos los cambios.
- Se dejaron de versionar los logs de Kotlin; `.gitignore` bloquea llaves de firma.
- Se revisó el historial: no hay datos personales en GitHub.

## Pendiente de hacer

1. **Diciembre mágico** (rama nueva, después de las respuestas).
2. Probar en el emulador Pixel_5 cambiando la fecha (1, 5, 10, 24, 25 y 31 de
   diciembre), con datos y sin datos. Los comandos están en `CLAUDE.md`.
3. Arreglar: el botón «+ Recuerdo» tapa parte del cofre.
4. Más adelante: animaciones (partículas + física + shader de brillo) y los dos
   videos de Juan para Nochebuena y Navidad (MP4 vertical 9:16, menos de 30 MB).

## Ya decidido por Juan

- En diciembre solo cuentan **los recuerdos de este año**.
- Cada día N de diciembre salen del cofre, con efecto, los recuerdos guardados un
  día N de cualquier mes (ej.: el 1 de diciembre salen los del 1 de mayo, 1 de julio...).
- Diciembre tiene 31 días, el calendario también.
- Si un día no tiene recuerdos: sale **contenido precargado** (una «reserva» que
  se sube antes); si no hay reserva, **una frase y un regalo** de Saurio.
- Los recuerdos **guardados en diciembre salen el 31** (gran final).
  Propuesta: al guardarlos en diciembre la esfera entra al cofre, no al árbol.
- Notificaciones de diciembre: **8:00** buenos días (cuántos recuerdos hay, invita
  a entrar) y **21:00** buenas noches solo si no abrió la app ese día.
- Los sonidos actuales se quedan; se irán mejorando o reemplazando.

## Preguntas abiertas (responder para empezar)

1. ¿Árbol **A** (se llena día a día) o **B** (lleno con destacados)? Recomendado: A.
2. ¿Días sin abrir **a** (se acumula), **b** (ya colgados) o **c** (esperan al 31)?
   Recomendado: a.
3. ¿Cápsulas se abren a las **00:00 del 25**?
4. ¿Enero **a** (álbum 2026 y árbol nuevo), **b** (se quedan colgadas) o
   **c** (se borran)? Recomendado: a.
5. ¿Quitar las **4 esferas de ejemplo** que trae la app (`starterMemories`)?
   Chocan con la regla de publicar sin recuerdos.
6. ¿La app es **para Juan o un regalo** para otra persona? (Cambia cómo se carga
   la reserva: escondida o no.) ¿Los avisos de diciembre **reemplazan** a los
   recordatorios de Ajustes en diciembre? Recomendado: reemplazan, y vuelven en enero.
   Extra: la frase «El árbol te extraña» de los recordatorios suena a culpa, ¿cambiarla?

---

## Explicación de las preguntas, con ejemplo

Recuerdos de ejemplo guardados en 2026:

| Guardado | Recuerdo |
|---|---|
| 5 de marzo | Cumple de mamá |
| 5 de mayo | Paseo al lago |
| 12 de julio | Primera foto juntos |
| 20 de septiembre | Nota de voz |
| 10 de diciembre | Cena de amigos (guardado en diciembre) |

### 1. Árbol lleno o llenándose

**A) Se llena día a día:** el árbol empieza casi sin esferas y crece.

| Día | Qué pasa | Árbol |
|---|---|---|
| 1 dic | Ningún recuerdo de día «1»: sale frase y regalo de Saurio | 0 esferas, solo luces y adornos |
| 5 dic | Salen «Cumple de mamá» y «Paseo al lago» ✨ | 2 esferas |
| 12 dic | Sale «Primera foto juntos» ✨ | 3 esferas |
| 20 dic | Sale «Nota de voz» ✨ | 4 esferas |
| 31 dic | Sale «Cena de amigos» ✨ | 5 esferas, árbol completo 🎉 |

**B) Árbol lleno con destacados:** las esferas están desde el 1, y cada día las
de ese número brillan más y Saurio las cuenta.

| Día | Qué pasa | Árbol |
|---|---|---|
| 1 dic | Frase y regalo de Saurio | 4 esferas desde el inicio |
| 5 dic | «Cumple de mamá» y «Paseo al lago» brillan y Saurio las cuenta | 4 esferas, 2 destacadas |
| 31 dic | Se suma «Cena de amigos» | 5 esferas |

En la A el árbol **crece**, como un calendario de adviento que se completa el 31.
En la B **siempre está lleno** y la sorpresa es el brillo del día. Recomendado: A,
con luces y adornos desde el 1 para que no se vea pelado y un contador tipo
«3 de 20 recuerdos ya salieron del cofre».

### 2. Días sin abrir la app

Juan abre la app el 4 de diciembre, no la abre el 5 ni el 6, y vuelve el 7. El 5
tenía 2 recuerdos para salir.

- **a) Se acumula (recomendado):** Saurio dice «¡Mientras no estabas, el cofre
  guardó sorpresas para ti!». Salen uno tras otro con su efecto: los 2 del 5, el
  regalo del 6 y lo del 7, con botón «saltar». No se pierde nada.
- **b) Ya están colgados:** las esferas del 5 están en el árbol, pero no se vio
  cómo salían. Ese momento se perdió.
- **c) Se esperan:** lo del 5 y el 6 se queda en el cofre hasta el 31.

### 3. Hora de las cápsulas

Una cápsula guardada en junio, «Abrir en Navidad»:

| Momento | Hoy (código actual) | Propuesta |
|---|---|---|
| 24 dic, 00:00 (madrugada) | 🔓 Ya se abre, un día antes, cuando todos duermen | 🔒 Cerrada |
| 24 dic, 20:00 | Abierta desde hace horas | 🔒 Cerrada; se reproduce el video de Nochebuena (primera apertura desde las 18:00) |
| 25 dic, 00:00 | Abierta | 🔓 Se abre, como los regalos a medianoche |
| 25 dic, 9:00 | Abierta | Si dormía: video de Navidad al abrir la app y luego abrir la cápsula |

### 4. Qué pasa en enero

El 1 de enero de 2027 termina el diciembre mágico. Como solo cuentan los de este año:

- **a) Árbol vacío para 2027 y «Álbum 2026»** con las esferas viejas, que se puede
  abrir cuando se quiera (recomendado).
- **b) Las esferas de 2026 se quedan colgadas,** pero el próximo diciembre solo
  salen las de 2027.
- **c) Se borran.** No recomendado: son recuerdos.

### Notificaciones: cómo funcionarían

- Se programan por adelantado las 62 de diciembre (2 por día). Cada vez que se abre
  la app se recalculan con el número de recuerdos y cuántos salen ese día.
- Al abrir la app se cancela la de las 21:00 de ese día. No hace falta nada
  corriendo en segundo plano.
- La de la mañana puede quedar fija (`ongoing`), pero desde Android 14 el usuario
  igual puede deslizarla.
- Ya existen los recordatorios de Ajustes (diario o semanal); por eso la pregunta
  de si en diciembre se suman o se reemplazan.
