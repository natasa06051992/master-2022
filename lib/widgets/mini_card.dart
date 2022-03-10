import 'package:flutter/material.dart';
import 'package:flutter_master/config/theme.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view/handyman_details_screen.dart';

class MiniCard extends StatefulWidget {
  final UserModel userModel;
  const MiniCard({required this.userModel});

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
  Widget build(BuildContext context) {
    var user = widget.userModel as HandymanModel;
    return GestureDetector(
      onTap: () {
        _navigator
            .pushNamed(HandymanDetailScreen.routeName, arguments: user)
            .then((value) => super.setState(() {}));
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(233, 233, 233, 1),
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
                        color: Color.fromRGBO(233, 233, 233, 1),
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
                    child: Image(
                      image: AssetImage('assets/logo/LogoMakr-4NVCFS.png'),
                      height: 125,
                      width: 125,
                    ),
                  ),
            SizedBox(
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
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    user.email!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color.fromRGBO(139, 144, 165, 1),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "${user.startingPrice ?? ""} RSD",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        " | ",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        user.averageReviews != null
                            ? user.averageReviews.toString()
                            : "",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color.fromRGBO(251, 89, 84, 1),
                        ),
                      ),
                      user.numberOfReviews != null
                          ? Text(" (${user.numberOfReviews})",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromRGBO(251, 89, 84, 1),
                              ))
                          : Text(""),
                      Icon(
                        Icons.star,
                        size: 17,
                        color: primary,
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
