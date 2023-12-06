import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../model/getx_controller.dart';

class DetailedNewsScreen extends StatelessWidget {

  NewsController _controller = Get.find();

  DetailedNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: Obx( () {
        _controller.changed();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // News Image
            Container(
              height: 200, // Set an appropriate height for the image
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_controller.newsImageLink.value),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // News Content
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _controller.newsContent.value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Information Message
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Unfortunately, the full article cannot be displayed here. Please use the following link to visit the official website:",
                style: TextStyle(color: Colors.grey),
              ),
            ),

            // RichText with Link
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    text: 'Read more',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrlString(_controller.newsWebsiteLink.value);
                      },
                  ),
                ),
              ),
            ),
          ],
        );

      }) 
    );
  }
}
