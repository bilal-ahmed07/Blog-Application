import 'package:blog_app_flutter/features/crud.dart';
import 'package:blog_app_flutter/pages/blog.dart';
import 'package:blog_app_flutter/pages/create_blog.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = CrudMethods();
  Stream? blogStream;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      Stream result = crudMethods.getData();
      setState(() {
        blogStream = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Widget floatingButton = FloatingActionButton(onPressed: () {});

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
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: "Blog",
                    style: TextStyle(
                      fontSize: 25,
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
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text("Error: $errorMessage"))
              : StreamBuilder(
                stream: blogStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No Blogs Available"));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var data =
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;

                      return BlogTiles(
                        authorName: data['author'] ?? "Unknown",
                        title: data['title'] ?? "No Title",
                        description: data['description'] ?? "",
                        imageurl: data['image_url'] ?? "",
                      );
                    },
                  );
                },
              ),
      floatingActionButton: Container(
        padding: const EdgeInsets.only(left: 35, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              elevation: 25,
              backgroundColor: const Color.fromARGB(255, 50, 138, 89),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50), 
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: ((context) => CreateBlog())),
                );
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTiles extends StatelessWidget {
  BlogTiles({
    super.key,
    this.authorName = 'Unknown',
    this.title = "No Title",
    this.description = "",
    required this.imageurl,
  });

  String imageurl, authorName, title, description;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BlogDetailPage(
                  authorName: authorName,
                  title: title,
                  description: description,
                  imageUrl: imageurl,
                ),
          ),
        );
      },
      child: Container(
        height: 180,
        padding: EdgeInsets.all(8),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageurl,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: 180,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/image/blog.jpg",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                  );
                },
              ),
            ),
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black45.withAlpha(85),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      authorName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.75,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
