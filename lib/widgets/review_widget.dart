import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/config/theme.dart';
import 'package:flutter_master/widgets/custom_image.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewUI extends StatelessWidget {
  final String? image, name;
  final String date, comment;
  final int rating;
  final Function onTap;
  final bool isLess;
  const ReviewUI({
    Key? key,
    required this.image,
    required this.name,
    required this.date,
    required this.comment,
    required this.rating,
    required this.onTap,
    required this.isLess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 2.0,
        bottom: 2.0,
        left: 16.0,
        right: 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 45.0,
                width: 45.0,
                margin: const EdgeInsets.only(right: 16.0),
                child: Center(
                    child: image == null
                        ? const CircleAvatar(
                            radius: 50.0,
                            child: Icon(Icons.photo_camera),
                          )
                        : CachedNetworkImage(
                            width: 120.0,
                            imageUrl: image!,
                            placeholder: (context, url) =>
                                const BlankImageWidget(),
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
                          )
                    // CircleAvatar(
                    //     radius: 50.0,
                    //     backgroundImage: NetworkImage(image!),
                    //   ),
                    ),
              ),
              Expanded(
                child: Text(
                  name ?? 'anonyms',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmoothStarRating(
                isReadOnly: true,
                starCount: 5,
                rating: double.parse(rating.toDouble().toStringAsFixed(2)),
                size: 28.0,
                color: orange,
                borderColor: orange,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  date,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          GestureDetector(
            onTap: () {
              onTap();
            },
            child: isLess
                ? Text(
                    comment,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  )
                : Text(
                    comment,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
