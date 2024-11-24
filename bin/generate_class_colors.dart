import 'package:figma_exporter/src/createColorsClass.dart';

void main() async {
  final generator = FigmaColorsClassGenerator(
    folderPath: './scripts/colors',
    outputFilePath: './lib/app/assets/figmaColors.class.dart',
  );

  try {
    await generator.generate();
  } catch (e) {
    print('Error generating Figma colors: $e');
  }
}
