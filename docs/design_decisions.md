# SaurioNavidad - decisiones de diseño

## Aprobado por el usuario

- Rediseñar a Saurio con silueta clara de dinosaurio.
- Agregar animación al guardar un recuerdo: la esfera debe aparecer/subir al arbol.
- Usar a Saurio como guía/reactivo dentro de la app.
- Mantener colores por tipo de recuerdo.
- Mejorar la pantalla/vista del cofre.
- Agregar microinteracciones: vibración suave, luces, sonidos sutiles y respuestas al toque.

## Desaprobado por el usuario

- Estados del arbol basados en cantidad de recuerdos. El usuario quiere que la app se sienta viva desde que entra, incluso si no agrego recuerdos por mucho tiempo.
- Detalle de recuerdo mas emocional y visual. No queda claro visualmente todavia y no se implementara por ahora.

## Direccion de vida de la app

- La app debe sentirse viva al entrar, sin depender de que el usuario agregue recuerdos constantemente.
- Evitar mecanicas que hagan sentir abandono, culpa o tristeza por no haber agregado contenido.
- La vida de la app debe venir de ambiente, Saurio, hora del dia, clima visual navideno, microanimaciones y frases calidas.

## Direccion recomendada para Saurio

- Saurio debe leerse como dinosaurio aun en tamano pequeno.
- Priorizar silueta: cabeza lateral, hocico, cola grande, patas cortas y espinas.
- Evitar que parezca solo una mascota verde redonda.
- Estilo sugerido: baby dinosaurio navideno, tierno, expresivo y emocional.

## Opcion tecnica recomendada

- Usar Rive para una mascota animada con estados: idle, feliz, grabando audio, foto, sorpresa y dormido.
- Mantener Flutter Animate para microinteracciones de UI.

## Implementado en Flutter como primera iteracion

- Saurio tiene silueta mas dinosaurio: hocico, cola, espinas y patas con garras.
- Saurio tiene estados visuales en Flutter: cozy, excited, recording, photo y surprise.
- Saurio muestra mensajes calidos como guia sin culpar al usuario por no entrar.
- Al guardar una esfera hay vibracion suave, sonido del sistema y una esfera que sube hacia el arbol.
- El cofre usa tarjetas visuales con candado, fecha y estado.
- Se agregaron `flutter_animate` y `rive` como base tecnica para microinteracciones y futura mascota Rive.

## Rive pendiente

- Crear/exportar `assets/rive/saurio.riv` desde el editor de Rive.
- Registrar el asset en `pubspec.yaml` cuando el archivo exista.
- Conectar la maquina de estados de Rive con acciones de la app.
