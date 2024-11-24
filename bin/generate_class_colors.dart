import 'package:figma_exporter/src/createColorsClass.dart';

void main() async {
  //TODO (Lize):make this dynamic if needed in future.
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
