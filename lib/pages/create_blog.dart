import 'package:flutter/material.dart';

class CreateBlog extends StatefulWidget {
  const CreateBlog({super.key});

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {

  String? authorName, title, description;

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
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.upload),
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 25),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              height: 190,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13.5),
              ),
              child: Icon(
                Icons.add_a_photo, 
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Author Name",
                    ),
                    onChanged: (val) {
                      authorName = val;
                    },
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      hintText: "Title",
                    ),
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Description",
                      prefixIcon: Icon(Icons.article),
                    ),
                    onChanged: (val) {
                      description = val;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}