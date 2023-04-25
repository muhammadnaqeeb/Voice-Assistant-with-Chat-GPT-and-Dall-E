import 'package:flutter/material.dart';
import 'package:voice_assistant/color_pallete.dart';

class FeatureBox extends StatelessWidget {
  final String headerText;
  final String descriptionText;
  const FeatureBox({
    super.key,
    required this.headerText,
    required this.descriptionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xffDDDDDD),
            blurRadius: 6.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20, left: 15, bottom: 20, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              headerText,
              style: const TextStyle(
                color: Pallete.blackColor,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              descriptionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Pallete.blackColor,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const Divider(
              color: Colors.grey,
              indent: 60,
              endIndent: 60,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              "More",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
