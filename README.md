# figma_exporter_lz

Dart package to help Generate exported token from figma to flutter class or enums.

> NOTE : This package has been developed for personal use, might need suit to every `Scenarios`.

![Package in action](https://github.com/lizeWrk/figma_exporter_lz)

## Usage - enums

```sh
# Add figma_exporter_lz as a Local dependency
figma_exporter:
   git:
     url: https://github.com/lizeWrk/figma_exporter_lz
     ref: version2

dart run figma_exporter:generate_enums_colors
# OR
flutter dart run figma_exporter:generate_enums_colors

```

## Usage - class

```sh
# Add figma_exporter_lz as a Local dependency
figma_exporter:
   git:
     url: https://github.com/lizeWrk/figma_exporter_lz
     ref: version2

dart run figma_exporter:generate_class_colors
# OR
flutter dart run figma_exporter:generate_class_colors

```

## Why 🤔

Using the Figma Exporter package is beneficial because, when the color naming conventions in the project differ from those in Figma, developers often spend a significant amount of time deciding on color names, checking whether a color already exists in the project, and verifying the corresponding variable name for the color code. This package streamlines the process by converting color tokens into classes and enums, saving time and reducing the manual effort required.

## How 🤖

- `figma_exporter_lz` looks for `token` in the `./scripts/colors` files located in the directory, and fetches all the tokens.
- Then it looks for all the `#hexCode` and `token naming`.
- after then will regenerate the into `enums` or `class`.
- finally you only need to follow the figma variable name and assigned the

## Limitations 😔

- This package currently works only for `Figma`, which exported from Figma and located the token in `.scripts/color` file.
- It required use `local variable` in figma.
- mainly for `personal use`, therefore output and input file structure is hardcoded.

## Error and Limitation 😭

- when you used `Previous` version before, you might notice new upgraded/commits is not working. please delete `pubspec.lock` then `pub get` to get the latest commits/upgraded version.
