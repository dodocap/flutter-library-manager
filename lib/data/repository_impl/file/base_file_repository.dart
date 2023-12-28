import 'dart:io';

import 'package:orm_library_manager/domain/dto/csv_covertable.dart';
import 'package:path_provider/path_provider.dart';

abstract class BaseFileRepository<T extends CsvConvertible> {
  File? file;
  final List<T> list = [];
  final String fileRowString;

  BaseFileRepository(String fileName, this.fileRowString) {
    _loadFile(fileName);
  }

  T fromCSV(List<String> splitStringList);

  Future<void> _loadFile(String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    file = File('${directory.path}/$fileName');

    try {
      final String readString = await file?.readAsString() ?? '';
      List<String> readLines = readString.split('\n');
      String readFirstRow = readLines.first.split(',').map((e) => e.trim()).join(',');

      if (readFirstRow == fileRowString) {
        for(int i = 1; i < readLines.length; i++) {
          final List<String> commaSplitList = readLines[i].split(',').map((e) => e.trim().toLowerCase()).toList();
          if (commaSplitList.length == fileRowString.split(',').length) {
            T t = fromCSV(readLines[i].split(',').map((e) => e.trim().toLowerCase()).toList());
            list.add(t);
          }
        }
        print(list);
      } else {
        // await _file?.delete();
      }
    } catch (e) {
      print(e);
      // await _file?.delete();
    }
  }

  Future<void> saveFile() async {
    final StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write('$fileRowString\n');
    for (final T element in list) {
      stringBuffer.write(element.toCSV());
    }
    await file?.writeAsString(stringBuffer.toString());
  }
}