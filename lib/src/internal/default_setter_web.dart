import '../scorm_api.dart';

/// Implementación web: delega al ScormAPI real.
String? defaultSetValue(String key, String value) => ScormAPI.setValue(key, value);
