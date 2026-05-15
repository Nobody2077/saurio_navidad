Put the final Rive mascot file here as `saurio.riv`.

When that file exists, add this block to `pubspec.yaml`:

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/rive/saurio.riv
```

The current app is prepared for Rive, but keeps the Flutter-painted Saurio as
the working fallback until a real `.riv` file is exported from the Rive editor.
