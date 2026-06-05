# assets/saurio/

Carpetas de animación de Saurio, una por estado de humor.

## Estados disponibles

| Carpeta      | Estado en código       | Cuándo se activa                        |
|--------------|------------------------|-----------------------------------------|
| `cozy/`      | `SaurioMood.cozy`      | Reposo / mensaje ambiental              |
| `excited/`   | `SaurioMood.excited`   | Al abrir el formulario, meta, lugar     |
| `recording/` | `SaurioMood.recording` | Mientras graba audio                    |
| `photo/`     | `SaurioMood.photo`     | Al elegir foto                          |
| `surprise/`  | `SaurioMood.surprise`  | Al abrir el cofre, emoción "Sorpresa"   |

## Formato recomendado (frames PNG)

Nombra los frames así dentro de cada carpeta:

```
cozy/
  frame_00.png
  frame_01.png
  frame_02.png
  ...
```

Resolución sugerida: 200x200 px, fondo transparente.
Entre 6 y 12 frames por estado es suficiente para que se vea fluido.

## Registro en pubspec.yaml

Cuando tengas archivos en las carpetas, agrega en pubspec.yaml:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/saurio/cozy/
    - assets/saurio/excited/
    - assets/saurio/recording/
    - assets/saurio/photo/
    - assets/saurio/surprise/
```
