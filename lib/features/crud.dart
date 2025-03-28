import "package:cloud_firestore/cloud_firestore.dart";

class CrudMethods {
  Future<void> addData(blogData) async {
    await FirebaseFirestore.instance.collection("blogs").add(blogData);
  }

  // getData() async {
  //   return await FirebaseFirestore.instance.collection("blogs").get();
  // }
  Stream<QuerySnapshot> getData() {
    return FirebaseFirestore.instance.collection("blogs").snapshots();
  }
}