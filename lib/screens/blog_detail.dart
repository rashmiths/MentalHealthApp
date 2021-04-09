import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogDetails extends StatelessWidget {
  final content;
  final tag;

  const BlogDetails(this.content, this.tag);
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
                    tag,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(20),
                    child: Html(
                      style: {"p": Style(fontSize: FontSize.xxLarge)},
                      data: content,
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
