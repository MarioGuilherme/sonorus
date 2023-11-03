import "package:flutter/material.dart";

class PictureUser extends StatelessWidget {
  final Widget picture;

  const PictureUser({
    super.key,
    required this.picture
  });

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        color: Colors.white,
        child: this.picture
      )
    );
  }
}