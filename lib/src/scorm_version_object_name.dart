import 'scorm_version.dart';

/// Extensión ligera con solo el mapeo del nombre del objeto JS por versión.
/// No importa interop de JS para ser usable en tests VM.
extension ScormVersionObjectName on ScormVersion {
  /// Nombre del objeto JavaScript que se debe buscar en la jerarquía.
  String get objectName {
    switch (this) {
      case ScormVersion.v1_2:
        return 'API';
      case ScormVersion.v2004:
        return 'API_1484_11';
    }
  }
}
