import 'package:blog_app_flutter/pages/create_blog.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Flutter',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: "Blog", 
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(bottom: 20,right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              elevation: 25,
              backgroundColor: Colors.white54,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (
                    (context) => CreateBlog()
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}
