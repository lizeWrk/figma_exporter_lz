import 'dart:convert';
import 'dart:io';

class FigmaColorsClassGenerator {
  final String folderPath;
  final String outputFilePath;

  FigmaColorsClassGenerator({
    required this.folderPath,
    required this.outputFilePath,
  });

  /// Generates a Dart file with a class that contains color constants
  Future<void> generate() async {
    // Get the list of files in the folder
    final folder = Directory(folderPath);
    final files = folder.listSync();

    // Check if the folder contains exactly one file
    if (files.length != 1) {
      throw Exception('Error: The folder should contain exactly one file.');
    }

    // Get the path of the JSON file
    final jsonFilePath = files.first.path;

    // Read the JSON file
    final dataJsonString = await File(jsonFilePath).readAsString().catchError((err) {
      throw Exception('Error reading JSON file: $err');
    });

    final data = jsonDecode(dataJsonString);

    // Prepare content for the generated Dart file
    final colorContent = StringBuffer()
      ..writeln("import 'dart:ui';\n")
      ..writeln("class FigmaColors {");

    // Loop through data and generate color constants
    var currentDataIndex = 0;
    data.forEach((colorName, shades) {
      var currentShadesIndex = 0;
      shades.forEach((shade, value) {
        final enumName = "${colorName.toLowerCase()}$shade";
        colorContent.writeln("  /// ${value['\$value']}");
        String hexValue;
        if (value['\$value'] != null && value['\$value']?.length > 7) {
          String rgb = value['\$value']!.substring(1, 7); // First 6 characters: "e4cee9"
          String alpha = value['\$value']!.substring(7, 9);
          hexValue = '0x$alpha$rgb';
        } else {
          hexValue = value['\$value']?.replaceFirst('#', '0xff'); // Hex to Color format
        }
        final isLast = data.length - 1 == currentDataIndex && shades.length - 1 == currentShadesIndex;
        colorContent.writeln("  static const Color $enumName = Color($hexValue);${isLast ? '' : '\n'}");
        currentShadesIndex++;
      });
      currentDataIndex++;
    });

    // End the class definition
    colorContent.writeln("}");

    // Write the generated content to the specified file
    final outputFile = File(outputFilePath);
    outputFile.writeAsStringSync(colorContent.toString());

    print('Figma colors generated successfully at $outputFilePath.');
  }
}
