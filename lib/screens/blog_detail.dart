import 'package:MentalHealthApp/providers/posts.dart';
import 'package:MentalHealthApp/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

String description =
    "Brown, well groomed hair almost fully covers a strong, cheerful face. Woeful aquamarine eyes, set appealingly within their sockets, watch energetically over the rivers they've shown mercy on for so long.";

class BlogDetails extends StatelessWidget {
  final Post blog;

  const BlogDetails(this.blog);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.green[100],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment(-1.25, 2.2),
                  child: GestureDetector(
                      child: Container(
                          width: 100,
                          height: 90,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple[200]),
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'D e s i g n',
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.all(8),
                //   child: Text(
                //     blog.title,
                //     style: TextStyle(fontSize: 30),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 15.0),
                //   child: Align(
                //     alignment: Alignment.center,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(20),
                //       ),
                //       child: Image.network(
                //         defaultImage,
                //         height: 300,
                //         width: 300,
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ),
                // ),
                Container(
                    padding: EdgeInsets.all(20),
                    child: Html(
                      style:{ },
                      data: blog.content,
                    )),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Text('Read Full Story'),
          backgroundColor: Colors.purple[200],
        ),
      ),
    );
  }
}
