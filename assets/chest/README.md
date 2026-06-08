# assets/chest/

Imágenes del cofre de cápsulas (el que aparece abajo, junto al árbol).

Exporta con **fondo transparente** (PNG) para que se integre con la escena:

- `cofre.png` — cofre **cerrado** (estado normal). Obligatorio.
- `cofre_abierto.png` — cofre **abierto** (se muestra al tocarlo). Opcional:
  si no existe, al tocar solo se hace el efecto de brillo + pop sobre el cerrado.

Recomendado: ~600x360 px (proporción ~5:3, más ancho que alto), centrado,
con algo de margen alrededor para que el brillo no quede cortado.

Ya está registrada la carpeta en `pubspec.yaml` (`- assets/chest/`), así que
en cuanto coloques los archivos y hagas `flutter run`, aparecerán solos.

## Pendiente / mejora futura

Para que la animación de apertura sea **pixel-perfect**, el cofre debe ocupar
el **mismo tamaño y posición** dentro del lienzo en ambas imágenes.

Hoy el cofre cerrado llena casi todo el cuadro y el abierto es algo más
pequeño, así que en el cross-fade (cerrado → abierto) el cofre "encoge" un
instante. El brillo y el pop de escala lo disimulan, pero si se quiere dejar
impecable: reexportar `cofre_abierto.png` con el cofre centrado y al mismo
tamaño que en `cofre.png` (mismo lienzo, misma escala).

