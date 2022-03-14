import 'package:flutter/material.dart';
import 'package:flutter_master/config/theme.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/handyman_details_screen.dart';

class MiniCard extends StatefulWidget {
  UserModel? userModel;
  MiniCard({required this.userModel});

  @override
  State<MiniCard> createState() => _MiniCardState();
}

class _MiniCardState extends State<MiniCard> {
  late NavigatorState _navigator;
  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    widget.userModel = null;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.userModel as HandymanModel;
    return GestureDetector(
      onTap: () {
        _navigator
            .pushNamed(HandymanDetailScreen.routeName, arguments: user)
            .then((value) => super.setState(() {}));
      },
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(233, 233, 233, 1),
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            user.avatarUrl != null
                ? Container(
                    height: 125.0,
                    width: 125.0,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(233, 233, 233, 1),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          user.avatarUrl!,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  )
                : Container(
                    height: 125.0,
                    width: 125.0,
                    child: const Image(
                      image: AssetImage('assets/logo/LogoMakr-4NVCFS.png'),
                      height: 125,
                      width: 125,
                    ),
                  ),
            const SizedBox(
              width: 30.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    user.displayName ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    user.email!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color.fromRGBO(139, 144, 165, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "${user.startingPrice ?? ""} RSD",
                        style: const TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      const Text(
                        " | ",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        user.averageReviews != null
                            ? user.averageReviews.toString()
                            : "",
                        style: const TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.bold),
                      ),
                      user.numberOfReviews != null
                          ? Text(" (${user.numberOfReviews})",
                              style: const TextStyle(
                                  fontSize: 14.0, fontWeight: FontWeight.bold))
                          : const Text(""),
                      const Icon(
                        Icons.star,
                        size: 17,
                        color: orange,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
