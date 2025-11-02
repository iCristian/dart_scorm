import 'scorm_js_api.dart';
import 'scorm_version.dart';

extension ScormVersionExtension on ScormVersion {
  /// Nombre del objeto JavaScript que se debe buscar en la jerarquía.
  String get objectName {
    switch (this) {
      case ScormVersion.v1_2:
        return "API";

      case ScormVersion.v2004:
        return "API_1484_11";
    }
  }

  bool Function(String) get initialize => this == ScormVersion.v1_2 ? ApiV12.initialize : ApiV2004.initialize;

  bool Function(String) get finish => this == ScormVersion.v1_2 ? ApiV12.finish : ApiV2004.terminate;

  bool Function(String) get terminate => this == ScormVersion.v1_2 ? ApiV12.finish : ApiV2004.terminate;

  String Function(String) get getValue => this == ScormVersion.v1_2 ? ApiV12.getValue : ApiV2004.getValue;

  String Function(String, String) get setValue => this == ScormVersion.v1_2 ? ApiV12.setValue : ApiV2004.setValue;

  bool Function(String) get commit => this == ScormVersion.v1_2 ? ApiV12.commit : ApiV2004.commit;

  String Function() get getLastError => this == ScormVersion.v1_2 ? ApiV12.getLastError : ApiV2004.getLastError;

  String Function(String) get getErrorString => this == ScormVersion.v1_2 ? ApiV12.getErrorString : ApiV2004.getErrorString;

  String Function(String) get getDiagnosticMessage => this == ScormVersion.v1_2 ? ApiV12.getDiagnosticMessage : ApiV2004.getDiagnosticMessage;
}
