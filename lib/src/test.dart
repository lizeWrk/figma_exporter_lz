import 'dart:convert';
import 'dart:io';

class FigmaColorsEnumGenerator {
  final String folderPath;
  final String outputFilePath;

  FigmaColorsEnumGenerator({
    required this.folderPath,
    required this.outputFilePath,
  });

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

    final dataJsonString = await File(jsonFilePath).readAsString().catchError((err) {
      throw Exception('Error reading JSON file: $err');
    });

    final data = jsonDecode(dataJsonString);

    // Generate colorContent
    final colorContent = StringBuffer()
      ..writeln("import 'dart:ui';\n")
      ..writeln("enum FigmaColors {");

    // Generate enum entries
    var currentDataIndex = 0;
    data.forEach((colorName, shades) {
      var currentShadesIndex = 0;
      shades.forEach((shade, value) {
        final enumName = "${colorName.toLowerCase()}${shade}";
        colorContent.writeln("  /// ${value['\$value']}");
        if (data.length - 1 == currentDataIndex && shades.length - 1 == currentShadesIndex) {
          colorContent.writeln("  $enumName;\n");
        } else {
          colorContent.writeln("  $enumName,\n");
        }
        currentShadesIndex++;
      });
      currentDataIndex++;
    });

    // Generate the getter
    colorContent.writeln("  Color get value {");
    colorContent.writeln("    switch (this) {");

    data.forEach((colorName, shades) {
      shades.forEach((shade, value) {
        final enumName = "${colorName.toLowerCase()}${shade}";
        final hexValue = value['\$value']?.replaceFirst('#', '0xff'); // Hex to Color format
        colorContent.writeln("      case FigmaColors.$enumName:");
        colorContent.writeln("        return const Color($hexValue);");
      });
    });

    colorContent.writeln("    }");
    colorContent.writeln("  }");
    colorContent.writeln("}");

    // Write to output file
    final outputFile = File(outputFilePath);
    outputFile.writeAsStringSync(colorContent.toString());

    print('Figma colors generated successfully.');
  }
}
