# Bitácora de cambios

Lo más nuevo arriba. Cada entrada: qué cambió y, si aplica, qué arreglo o
decisión hubo detrás.

## 2026-10-29: Sonidos y limpieza

- **Sonidos:** 16 efectos propios sintetizados con código (`tool/gen_sounds.dart`),
  sin descargas ni derechos de terceros. Suenan al guardar un recuerdo, tocar una
  esfera (uno por tipo), tocar a Saurio, abrir el cofre, grabar audio y borrar.
  Reemplazan al «click» del sistema, que en Android casi nunca suena.
- **Ajustes → Sonidos:** interruptores de efectos (encendido) y música navideña
  (apagada), más una lista para escuchar cada sonido.
- Los efectos no pausan la música de otras apps; la música se detiene al salir.
- Saurio ahora responde al toque.
- Generados y aún sin usar: abrir cápsula, desbloquear día, «llegó diciembre» y
  la música de fondo (caja musical original de 30 s en bucle).
- **Rive descartado:** se quitó la carpeta `assets/rive/` y su especificación.
- **Limpieza:** se quitaron del repo 10 logs de errores de Kotlin y se ignora
  `android/.kotlin/`.
- Se agregan `CLAUDE.md` (reglas del proyecto) y esta bitácora.

## 2026-06-08: Ambiente y header

- Menú de Ajustes y limpieza del header.
- Zona horaria nativa vía MethodChannel y soporte Kotlin.
- Ícono de la app con el logo de Saurio.
- Rediseño del cofre con imagen, flotación y apertura al tocar.
- Suelo nevado y cielo según el momento del día.
- Contador hacia diciembre; se quita el chip «frase del día».
- Header con chips en forma de nube.
- Mejor diálogo de Saurio, nubes flotantes y acentos.
- Cielo nocturno con estrellas y estrellas fugaces.
- Saludo de bienvenida e incentivo según la actividad, en la burbuja de Saurio.

## 2026-06-05: Saurio con imágenes y notificaciones

- Saurio rediseñado con imágenes por estado y chips de emoción.
- La burbuja de Saurio sube para que no la tape la imagen.
- Notificaciones locales configurables (diarias o semanales).
- Arreglo: se habilita core library desugaring, que exige
  `flutter_local_notifications`.

## 2026-05-19

- Se quita el botón «lugar» y se agrega el botón para borrar.

## 2026-05-15

- Primer commit: árbol, Saurio, cofre, calendario de diciembre y formulario.

## Pendientes conocidos

- En diciembre el árbol se vacía y el calendario cuenta recuerdos de cualquier
  mes. Se rediseña en la próxima rama (ver decisiones en curso).
- Las cápsulas se abren el 24 a las 00:00; la hora final está por decidir.
- El botón «+ Recuerdo» tapa parte del cofre.
- La app trae 4 esferas de ejemplo en la primera instalación (`starterMemories`).
