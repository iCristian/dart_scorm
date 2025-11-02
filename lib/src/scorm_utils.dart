// Import condicional para evitar dependencias web en entornos VM (tests).
// En web, delega al ScormAPI real; en VM usa un stub seguro.
import 'internal/default_setter_stub.dart'
  if (dart.library.html) 'internal/default_setter_web.dart';

/// Métodos de utilidad para trabajar con SCORM.
class ScormUtils {
  ScormUtils._();

  /// Toma un [Map] de `<String, String>` en [values] y ejecuta
  /// [ScormAPI.setValue] para cada par clave/valor.
  ///
  /// Puedes pasar un [keyPrefix] que se antepondrá a cada clave antes de
  /// establecer el valor. Útil cuando todas las claves comparten un prefijo
  /// común (por ejemplo `cmi.core`, `cmi.interactions` o simplemente `cmi`).
  ///
  /// Para mayor testabilidad, puedes inyectar una función [setValueFn]
  /// alternativa (firma `(key, value) => String?`) que se usará en lugar de
  /// [ScormAPI.setValue]. Por defecto usa la API real.
  ///
  /// Devuelve la lista de respuestas devueltas por cada invocación a
  /// [ScormAPI.setValue] (o [setValueFn]).
  static List<String?> setValues(
    Map<String, String> values, {
    String keyPrefix = "",
    String? Function(String key, String value)? setValueFn,
  }) {
    final statuses = <String?>[];
    final setter = setValueFn ?? defaultSetValue;
    values.forEach((key, value) {
      statuses.add(setter(keyPrefix + key, value));
    });
    return statuses;
  }
}
