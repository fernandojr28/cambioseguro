# cambio-app-flutter
Desarrollo de la app móvil de cambio seguro

# Antes iniciar la aplicación configurar

### Utilizamos el paquete freezed para generar algunos modelos
Antes de comenzar es necesario ejecutar el generador de códigos
```sh
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Android
Editar `android/app/src/main/res/values/strings.xml`
si no existe crear con el mismo nombre, agregar los siguientes
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Cambio Seguro</string>
    <!-- Facebook sign in -->
    <string name="facebook_app_id">FACEBOOK_APP_ID</string>
    <string name="fb_login_protocol_scheme">fbFACEBOOK_APP_ID</string>
    <!-- Google Sign in -->
    <string name = "server_client_id">GOOGLE_CLIENT_ID</string>

</resources>
```
Documentación:
* [login con facebook](https://pub.dev/packages/flutter_facebook_login#-readme-tab-)
* [login con google](https://developers.google.com/identity/sign-in/android/start#configure-a-google-api-project)

## iOS
Editando.. .