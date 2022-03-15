import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/widgets/custom_image.dart';

class PhotoAlbum extends StatelessWidget {
  final List<String> imgArray;

  const PhotoAlbum({required this.imgArray});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Album",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 250,
          child: GridView.count(
              primary: false,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: imgArray
                  .map((item) => Container(
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: item,
                        placeholder: (context, url) => const BlankImageWidget(),
                        errorWidget: (context, url, error) =>
                            const BlankImageWidget(),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0)),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      )))
                  .toList()),
        )
      ],
    );
  }
}
