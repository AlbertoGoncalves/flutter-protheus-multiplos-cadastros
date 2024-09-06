import 'package:flutter/material.dart';
import 'package:multiplos_cadastros/src/core/ui/constants.dart';

class ImagePersonType extends StatelessWidget {
  final String peopleType;
  
  const ImagePersonType({
    super.key,
    required this.peopleType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: switch (peopleType) {
            '0001' => const AssetImage(ImagePersonTypeConstants.porteiro),
            '0002' => const AssetImage(ImagePersonTypeConstants.visitante),
            '0003' => const AssetImage(ImagePersonTypeConstants.solicitante),
            '0004' => const AssetImage(ImagePersonTypeConstants.aprovador),
            '0005' => const AssetImage(ImagePersonTypeConstants.visualizador),
            '0006' => const AssetImage(ImagePersonTypeConstants.motorista),
            '0007' => const AssetImage(ImagePersonTypeConstants.delivery),
            '0008' => const AssetImage(ImagePersonTypeConstants.entregador),
            '0009' => const AssetImage(ImagePersonTypeConstants.agricultor),
            _ => const AssetImage(ImageConstants.avatar),
          },
        ),
      ),
    );
  }
}