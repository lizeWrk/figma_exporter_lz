import 'package:figma_exporter/figma_exporter.dart';

Future<void> main() async {
  //TODO (Lize):make this dynamic if needed in future.
  final folderPath = './scripts/colors';
  final outputFilePath = './lib/app/assets/figmaColors.enum.dart';

  final generator = FigmaColorsEnumGenerator(
    folderPath: folderPath,
    outputFilePath: outputFilePath,
  );

  try {
    await generator.generate();
    print('Figma colors generated successfully.');
  } catch (e) {
    print('Error: $e');
  }
}
