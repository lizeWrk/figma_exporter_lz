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
    ..writeln("enum FigmaColors {");

  // Generate enum entries
  var currentDataIndex = 0;
  data.forEach((colorName, shades) {
    var currentShadesIndex = 0;
    shades.forEach((shade, value) {
      final enumName = "${colorName.toLowerCase()}$shade";
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

  // colorContent.writeln("  ;\n"); // End of enum entries

  // Generate the getter
  colorContent.writeln("  Color get value {");
  colorContent.writeln("    switch (this) {");

  data.forEach((colorName, shades) {
    shades.forEach((shade, value) {
      final enumName = "${colorName.toLowerCase()}$shade";
      final hexValue = value['\$value']?.replaceFirst('#', '0xff'); // Replace '#' with '0xff' for Color format
      colorContent.writeln("      case FigmaColors.$enumName:");
      colorContent.writeln("        return const Color($hexValue);");
    });
  });

  colorContent.writeln("    }");
  colorContent.writeln("  }");
  colorContent.writeln("}");

  final outputFilePath = './lib/app/assets/figmaColors.enum.dart';
  final outputFile = File(outputFilePath);
  outputFile.writeAsStringSync(colorContent.toString());

  // Print the generated code
  print(colorContent.toString());
}
