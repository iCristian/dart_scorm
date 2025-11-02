// Migrado para compatibilidad con Dart/Flutter web modernos: evitar dart:html y dart:js
// ignore: deprecated_member_use
import 'dart:js_util' as js_util;

import 'package:web/web.dart' as web;

import 'scorm_version.dart';
import 'scorm_version_extension.dart';

/// Clase principal para toda la interacción con las APIs SCORM.
///
/// - Primero, intenta localizar la API con [findApi].
/// - Puedes consultar en cualquier momento si la API fue encontrada con [apiFound].
///
/// Nota: Todos los métodos/miembros son estáticos porque este paquete asume que
/// la app web consumidora representa un único recurso SCORM por ejecución.
class ScormAPI {
  ScormAPI._();

  static int _tries = 0;
  static int _maxTries = 7;

  /// Indica si la API se encontró correctamente. Si no se encuentra, el resto de
  /// los métodos devolverán `null`/`false` según corresponda.
  static bool get apiFound => _apiFound;

  static bool _apiFound = false;

  static late ScormVersion _version;

  /// Versión de SCORM encontrada o especificada.
  static ScormVersion? get version => _version;

  /// Recorre la jerarquía de ventanas para localizar el objeto `API` o `API_1484_11`.
  /// Si lo encuentra, lo copia al contexto actual (window) para poder invocarlo
  /// directamente desde esta ventana.
  static bool _search(web.Window window) {
    Object current = window;

    bool hasApi(Object target) => js_util.getProperty<Object?>(target, _version.objectName) != null;

    Object? parentOf(Object target) => js_util.getProperty<Object?>(target, 'parent');

    while (!hasApi(current) && parentOf(current) != null && !identical(parentOf(current), current)) {
      _tries++;
      if (_tries > _maxTries) {
        return false;
      }
      final next = parentOf(current);
      if (next == null) {
        break;
      }
      current = next;
    }

    // ¿API encontrada? Copiar referencia al contexto actual
    if (hasApi(current)) {
      final foundApi = js_util.getProperty<Object?>(current, _version.objectName);
      if (foundApi != null) {
        js_util.setProperty(web.window, _version.objectName, foundApi);
        return true;
      }
    }
    return false;
  }

  static bool _findVersion({int maxTries = 7}) {
    _maxTries = maxTries;
    final foundNormal = _search(web.window);
    var foundInOpener = false;

    final opener = js_util.getProperty<Object?>(web.window, 'opener');
    if (!foundNormal && opener != null) {
      _tries = 0;
      // `opener` es otra ventana: intentamos buscar ahí
      // Nota: usamos js_util.getProperty para acceder de forma segura.
      foundInOpener = _search(js_util.getProperty<web.Window>(web.window, 'opener'));
    }

    _apiFound = foundNormal || foundInOpener;

    return _apiFound;
  }

  /// Intenta encontrar la API de SCORM en la jerarquía hasta [maxTries] niveles.
  /// Si no se encuentra en la jerarquía actual, intenta buscar en la jerarquía
  /// de la ventana `opener` (si existe).
  ///
  /// Si se especifica [version], solo buscará esa versión. De lo contrario,
  /// probará primero SCORM 2004 y, si no se encuentra, SCORM 1.2.
  ///
  /// Devuelve si la API fue encontrada. También puedes consultar [apiFound].
  static bool findApi({ScormVersion? version, int maxTries = 7}) {
    if (version == null) {
      _version = ScormVersion.v2004;
      if (_findVersion(maxTries: maxTries)) {
        return true;
      } else {
        _version = ScormVersion.v1_2;
        return _findVersion(maxTries: maxTries);
      }
    } else {
      _version = version;
      return _findVersion(maxTries: _maxTries);
    }
  }

  /// Ejecuta `Initialize`.
  static bool initialize({String message = ""}) => _apiFound ? _version.initialize(message) : false;

  /// Ejecuta `Finish/Terminate`.
  static bool finish({String message = ""}) => _apiFound ? _version.finish(message) : false;

  /// Ejecuta `Finish/Terminate`.
  static bool terminate({String message = ""}) => _apiFound ? _version.terminate(message) : false;

  /// Ejecuta `GetValue`.
  static String? getValue(String key) => _apiFound ? _version.getValue(key) : null;

  /// Ejecuta `SetValue`.
  static String? setValue(String key, String value) => _apiFound ? _version.setValue(key, value) : null;

  /// Ejecuta `Commit`.
  static bool commit({String message = ""}) => _apiFound ? _version.commit(message) : false;

  /// Ejecuta `GetLastError`.
  static String? getLastError() => _apiFound ? _version.getLastError() : null;

  /// Ejecuta `GetErrorString`.
  static String? getErrorString(String errorCode) => _apiFound ? _version.getErrorString(errorCode) : null;

  /// Ejecuta `GetDiagnostic`.
  static String? getDiagnosticMessage(String errorCode) => _apiFound ? _version.getDiagnosticMessage(errorCode) : null;
}
