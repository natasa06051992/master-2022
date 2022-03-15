import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_master/locator.dart';
import 'package:flutter_master/model/project.dart';
import 'package:flutter_master/model/user.dart';
import 'package:flutter_master/view_controller/user_controller.dart';
import 'package:flutter_master/widgets/custom_image.dart';
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromRGBO(233, 233, 233, 1),
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              project.imageOfCustomer != null
                  ? Container(
                      height: 90.0,
                      width: 90.0,
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     color: const Color.fromRGBO(233, 233, 233, 1),
                      //   ),
                      //   image: DecorationImage(
                      //     image: NetworkImage(
                      //       project.imageOfCustomer!,
                      //     ),
                      //   ),
                      //   borderRadius: BorderRadius.circular(20.0),
                      // ),

                      child: CachedNetworkImage(
                        width: 100.0,
                        imageUrl: project.imageOfCustomer!,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const BlankImageWidget(),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      ))
                  : SizedBox(
                      height: 90.0,
                      width: 90.0,
                      child: const Image(
                        image: AssetImage('assets/logo/LogoMakr-4NVCFS.png'),
                        height: 125,
                        width: 125,
                      ),
                    ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
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
                      project.description,
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
                          project.service,
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        const Text(
                          " | ",
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        Text(
                          project.date,
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                    if (locator.get<UserController>().currentUser
                            is HandymanModel &&
                        project.phoneNumber != null)
                      SizedBox(
                        width: 80,
                        child: ElevatedButton(
                          onPressed: () {
                            project.phoneNumber != null
                                ? _makePhoneCall(project.phoneNumber!)
                                : null;
                          },
                          child: project.phoneNumber == null
                              ? null
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(Icons.phone),
                                    const Text('Call')
                                  ],
                                ),
                        ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
