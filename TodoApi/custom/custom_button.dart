import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.deepPurple, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
              child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }
}
