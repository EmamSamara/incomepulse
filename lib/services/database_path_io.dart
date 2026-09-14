import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<String> databaseFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return join(directory.path, 'irregular_income.db');
}
