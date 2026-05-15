# Especificacion Rive para Saurio

## Archivo esperado

- Ruta: `assets/rive/saurio.riv`
- Artboard: `Saurio`
- State machine: `SaurioMachine`

## Estados recomendados

- `idle`: respiracion suave, parpadeo, cola lenta.
- `happy`: sonrisa, salto pequeno, cola mas activa.
- `recording`: mira hacia un microfono o emite ondas suaves.
- `photo`: pose corta y flash suave.
- `surprise`: ojos grandes y reaccion al cofre/capsula.
- `sleepy`: ojos cerrados, movimiento lento, sin tristeza.

## Inputs sugeridos para la state machine

- `mood` number:
  - `0`: idle
  - `1`: happy
  - `2`: recording
  - `3`: photo
  - `4`: surprise
  - `5`: sleepy
- `tap` trigger: reaccion corta al tocar a Saurio.
- `celebrate` trigger: reaccion cuando se guarda una esfera.

## Notas de UX

- La app debe sentirse viva aunque el usuario no agregue recuerdos.
- Evitar mensajes que suenen a abandono o culpa.
- Saurio debe parecer dinosaurio por silueta: hocico, cola, espinas y patas.
