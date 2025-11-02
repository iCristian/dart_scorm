import 'package:scorm/src/scorm_utils.dart';
import 'package:scorm/src/scorm_version.dart';
import 'package:scorm/src/scorm_version_object_name.dart';
import 'package:test/test.dart';

void main() {
	group('ScormVersionExtension', () {
		test('objectName mapea correctamente', () {
			expect(ScormVersion.v1_2.objectName, equals('API'));
			expect(ScormVersion.v2004.objectName, equals('API_1484_11'));
		});
	});

	group('ScormUtils.setValues', () {
		test('prefija claves y usa función inyectada', () {
			final llamadas = <String, String>{};
			String? fakeSetter(String key, String value) {
				llamadas[key] = value;
				return 'OK';
			}

			final result = ScormUtils.setValues(
				{
					'cmi.core.lesson_status': 'completed',
					'cmi.core.score.raw': '95',
				},
				keyPrefix: 'prefix.',
				setValueFn: fakeSetter,
			);

			expect(result, equals(['OK', 'OK']));
			expect(llamadas.length, 2);
			expect(llamadas['prefix.cmi.core.lesson_status'], 'completed');
			expect(llamadas['prefix.cmi.core.score.raw'], '95');
		});
	});
}
