/// Declaraciones JS interop para las APIs SCORM 1.2 y 2004.
///
/// Nota: Estas clases solo definen el “shape” de los objetos JS expuestos por
/// el LMS. No contienen lógica; las llamadas se resuelven en el objeto global
/// `API` (SCORM 1.2) o `API_1484_11` (SCORM 2004).
@JS()
library scorm;

import 'package:js/js.dart';

@JS("API")
class ApiV12 {
  @JS("LMSInitialize")
  external static bool initialize(String message);

  @JS("LMSFinish")
  external static bool finish(String message);

  @JS("LMSGetValue")
  external static String getValue(String key);

  @JS("LMSSetValue")
  external static String setValue(String key, String value);

  @JS("LMSCommit")
  external static bool commit(String message);

  @JS("LMSGetLastError")
  external static String getLastError();

  @JS("LMSGetErrorString")
  external static String getErrorString(String errorCode);

  @JS("LMSGetDiagnostic")
  external static String getDiagnosticMessage(String errorCode);
}

@JS("API_1484_11")
class ApiV2004 {
  @JS("Initialize")
  external static bool initialize(String message);

  @JS("Terminate")
  external static bool terminate(String message);

  @JS("GetValue")
  external static String getValue(String key);

  @JS("SetValue")
  external static String setValue(String key, String value);

  @JS("Commit")
  external static bool commit(String message);

  @JS("GetLastError")
  external static String getLastError();

  @JS("GetErrorString")
  external static String getErrorString(String errorCode);

  @JS("GetDiagnostic")
  external static String getDiagnosticMessage(String errorCode);
}
