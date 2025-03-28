import 'dart:convert';
import 'dart:io';
import 'package:blog_app_flutter/features/crud.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CreateBlog extends StatefulWidget {
  const CreateBlog({super.key});

  @override
  State<CreateBlog> createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  String? authorName, title, description;
  bool isLoading = false;

  File? selectedImage;
  ImagePicker picker = ImagePicker();
  final crud = CrudMethods();

  Future<String?> uploadImageToCloudinary(File selectedImage) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/ddbyofivo/image/upload",
    );

    var request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = 'blog_pic_upload'
          ..fields['folder'] = "blog pictures"
          ..files.add(
            await http.MultipartFile.fromPath('file', selectedImage.path),
          );

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonData = json.decode(responseData);
      return jsonData['secure_url'];
    }
  }

  Future<void> saveBlogToFirestore(String imageUrl) async {
    crud.addData({
      'author': authorName ?? 'Anonymous',
      'title': title ?? 'Untitled',
      'description': description ?? '',
      'image_url': imageUrl.trim(),
    });
  }

  // Handle Image Upload (Upload + Save to Firestore)
  handleImageUpload() async {
    if (selectedImage == null) {
      final snackBar = SnackBar(
        content: Text("An error occured"),
        behavior: SnackBarBehavior.floating,
        elevation: 15,
        backgroundColor: const Color.fromARGB(255, 255, 111, 101),
      );
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    String? imageUrl = await uploadImageToCloudinary(selectedImage!);
    if (imageUrl != null) {
      await saveBlogToFirestore(imageUrl);
      Navigator.pop(context);
    } else {
      //image Url issue snack bar
      SnackBar(
        content: Text("image missing"),
        behavior: SnackBarBehavior.floating,
        elevation: 15,
      );
    }
  }

  Future<void> getImage() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

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
              onPressed: handleImageUpload,
              icon: Icon(Icons.upload),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 25),
          GestureDetector(
            onTap: getImage,
            child:
                selectedImage != null
                    ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 14),
                      height: 190,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13.5),
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      ),
                    )
                    : Container(
                      margin: EdgeInsets.symmetric(horizontal: 14),
                      height: 190,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13.5),
                      ),
                      child: Icon(Icons.add_a_photo, color: Colors.black45),
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
                  onChanged: (val) => authorName = val,
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    hintText: "Title",
                  ),
                  onChanged: (val) => title = val,
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.article),
                    hintText: "Description",
                  ),
                  onChanged: (val) => description = val,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
