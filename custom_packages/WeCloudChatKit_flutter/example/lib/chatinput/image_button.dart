import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final ImageProvider image;
  final void Function() onPressed;

  const ImageButton({
    Key? key,
    required this.onPressed,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        child: Image(
          image: image,
          width: 35,
          height: 35,
        ),
      ),
    );
  }
}
