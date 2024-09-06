import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:multiplos_cadastros/src/core/ui/constants.dart';

class FeatureOption extends StatelessWidget {
  final String textLin1;
  final String textLin2;
  final String textLin3;
  final String image;
  const FeatureOption(
      {required this.textLin1,
      required this.textLin2,
      required this.textLin3,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      width: ((MediaQuery.of(context).size.width * 0.45)),
      height: ((MediaQuery.of(context).size.width * 0.4)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorsConstants.grey,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: ((MediaQuery.of(context).size.width * 0.18)),
            height: ((MediaQuery.of(context).size.height * 0.08)),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    image,
                  ),
                  fit: BoxFit.cover),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Offstage(
            offstage: textLin1.isEmpty,
            child: Text(
              textLin1,
              style: const TextStyle(
                // fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Offstage(
            offstage: textLin2.isEmpty,
            child: Text(
              textLin2,
              style: const TextStyle(
                // fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Offstage(
            offstage: textLin3.isEmpty,
            child: Text(
              textLin3,
              style: const TextStyle(
                // fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
