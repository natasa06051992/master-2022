import 'package:flutter/material.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/project.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher.dart';

class MiniCardProject extends StatelessWidget {
  final Project project;
  const MiniCardProject({required this.project});
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.82,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color.fromRGBO(233, 233, 233, 1),
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          project.imageOfCustomer != null
              ? Container(
                  height: 125.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(233, 233, 233, 1),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                        project.imageOfCustomer!,
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
            width: 15.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  project.title,
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
                  project.description,
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
                      "${project.service}",
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      " | ",
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    Text(
                      "${project.date}",
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
                if (locator.get<UserController>().currentUser
                        is HandymanModel &&
                    project.phoneNumber != null)
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          project.phoneNumber != null
                              ? _makePhoneCall(project.phoneNumber!)
                              : null;
                        },
                        child: project.phoneNumber == null
                            ? null
                            : Row(
                                children: [Icon(Icons.phone), Text('Call')],
                              )),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
