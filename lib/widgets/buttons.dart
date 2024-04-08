import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    super.key,
    required this.image,
    required this.onTap,
    required this.caption,
  });

  final String image;
  final Function onTap;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            child: Image.asset(image),
          ),
          Container(
            width: 150,
            color: const Color(0x4F9E9E9E),
            height: 150,
            alignment: Alignment.bottomCenter,
            child: Text(
              caption,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
