import 'dart:convert';
import 'dart:io';

void main() async {
  // Define the folder path
  final folderPath = './scripts/colors';

  // Get the list of files in the folder
  final folder = Directory(folderPath);
  final files = folder.listSync();

  // Check if the folder contains exactly one file
  if (files.length != 1) {
    print('Error: The folder should contain exactly one file.');
    return;
  }

  // Get the path of the JSON file
  final jsonFilePath = files.first.path;

  final dataJsonString = await File(jsonFilePath).readAsString().catchError((err) {
    print(err);
    return err;
  });
  final data = jsonDecode(dataJsonString);

  // colorContent for output
  final colorContent = StringBuffer()
    ..writeln("import 'dart:ui';\n")
    ..writeln("class FigmaColors {");

  // Generate enum entries
  var currentDataIndex = 0;
  data.forEach((colorName, shades) {
    var currentShadesIndex = 0;
    shades.forEach((shade, value) {
      final enumName = "${colorName.toLowerCase()}$shade";
      colorContent.writeln("  /// ${value['\$value']}");
      String hexValue;
      print(value['\$value']);
      // 7 => 1st is "#", rbg length will be 6
      if (value['\$value'] != null && value['\$value']?.length > 7) {
        String rgb = value['\$value']!.substring(1, 7); // First 6 characters: "e4cee9"
        String alpha = value['\$value']!.substring(7, 9);
        hexValue = '0x$alpha$rgb';
      } else {
        hexValue = value['\$value']?.replaceFirst('#', '0xff'); // Replace '#' with '0xff' for Color format
      }
      final isLast = data.length - 1 == currentDataIndex && shades.length - 1 == currentShadesIndex;
      colorContent.writeln("  static const Color $enumName = Color($hexValue);${isLast ? '' : '\n'}");
      currentShadesIndex++;
    });
    currentDataIndex++;
  });

  colorContent.writeln("}");

  final outputFilePath = './lib/app/assets/figmaColors.class.dart';
  final outputFile = File(outputFilePath);
  outputFile.writeAsStringSync(colorContent.toString());

  // Print the generated code
  print(colorContent.toString());
}
