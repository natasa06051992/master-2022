import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/widgets/custom_image.dart';

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
              : CachedNetworkImage(
                  imageUrl: avatarUrl!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const BlankImageWidget(),
                  imageBuilder: (context, imageProvider) => Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                )),
    );
  }
}
