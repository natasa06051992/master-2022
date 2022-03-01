import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? avatarUrl;
  final Function onTap;

  const Avatar({required this.avatarUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Center(
        child: avatarUrl == null
            ? const CircleAvatar(
                radius: 70.0,
                child: Image(
                  image: AssetImage('assets/logo/LogoMakr-4NVCFS.png'),
                  height: 70,
                  width: 70,
                ),
              )
            : CircleAvatar(
                radius: 70.0,
                backgroundImage: NetworkImage(avatarUrl!),
              ),
      ),
    );
  }
}
