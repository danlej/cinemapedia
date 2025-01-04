# cinemapedia

# Dev

1. Copy the .env.emplate file and rename it to .env
2. Change environment variables (The MovieDB)
3. Get an AP Key from [TheMovieDB.org](https://developer.themoviedb.org/docs/getting-started)
4. Entity changes, you must to execute this command line:
   ```
   flutter pub run build_runner build
   ```

# Prod

Para cambiar el nombre de la aplicación:

```
dart run change_app_package_name:main com.new.package.name
```

Para cambiar el icono de la aplicación:

```
dart run flutter_launcher_icons
```

Para cambiar el splash screen:

```
dart run flutter_native_splash:create
```
