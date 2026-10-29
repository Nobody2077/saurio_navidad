# SaurioNavidad: instrucciones del proyecto

App Flutter (solo Android): un árbol de Navidad con recuerdos, la mascota Saurio
y un cofre de cápsulas. Hablar siempre en español con Juan.

## Reglas que no se rompen

- **Nunca subir datos personales a GitHub.** Los recuerdos, fotos y audios viven
  solo en el teléfono (shared_preferences y la carpeta de documentos de la app).
  No copiar al repo capturas, exportaciones ni archivos de un dispositivo real.
- **La app se publica sin recuerdos guardados.** Nada de esferas reales en el
  código ni en `assets/`.
- No subir llaves de firma (`*.jks`, `key.properties`), `local.properties` ni logs.
- Probar en el **emulador Pixel_5**, no en un teléfono con recuerdos reales: una
  instalación fallida puede desinstalar la app y borrar sus datos.
- Trabajar en ramas `feat/...` y fusionar en `main` cuando Juan lo apruebe.
- Cada cambio que se fusiona se anota en `BITACORA.md`.

## Dirección de diseño

Ver `docs/design_decisions.md`. Lo esencial: la app debe sentirse viva al entrar,
sin culpa ni abandono si no se agregan recuerdos. Rive está descartado; las
animaciones se hacen con `flutter_animate`, CustomPainter, física, partículas y
shaders.

## Mapa rápido

- `lib/screens/home_screen.dart`: pantalla principal y lógica de diciembre.
- `lib/painters/`: cielo, nieve, suelo, árbol.
- `lib/widgets/`: cofre, calendario, formulario, ajustes, Saurio.
- `lib/services/`: recuerdos, audio, fotos, notificaciones, visitas, sonido.
- `assets/sounds/`: efectos generados con `dart run tool/gen_sounds.dart assets/sounds`.

## Probar con otra fecha (emulador)

La imagen del emulador es userdebug, así que acepta `adb root`:

```powershell
adb root
adb shell settings put global auto_time 0
adb shell date 120108002026.00   # MMDDhhmmYYYY.ss → 1 dic 2026 08:00
adb shell am force-stop com.saurionavidad.saurio_navidad
```

Para volver a la hora real: `adb shell settings put global auto_time 1`.
Para probar la app vacía (solo en el emulador): `adb shell pm clear com.saurionavidad.saurio_navidad`.

Si el emulador arranca con «Can't find service: package», reiniciarlo en frío:
`emulator -avd Pixel_5 -no-snapshot-load`.
