import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/models/profilemodel.dart';

class FavCreatorController extends GetxController {
  static FavCreatorController get instance => Get.find();

  final _firebaseFirestore = FirebaseFirestore.instance;

  RxList<Details> favCreators = <Details>[].obs ;
  List<Details> fetchAllFavCreators = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchFavCreators();
  }


  Future<void> fetchFavCreators() async {
    final querySnapshot = await _firebaseFirestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email).collection('favs')
        .get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    for (int i = 0; i < documents.length; i++) {
      fetchAllFavCreators.add(Details.fromDocumentSnapShot(documents[i]));
    }
    favCreators.value = fetchAllFavCreators;


  }


  searchVideo(value) {
    favCreators.value = fetchAllFavCreators
        .where((element) =>
    element.name!.toLowerCase().contains(value.toLowerCase()))
        .toList();
    if(favCreators.isEmpty){
      Fluttertoast.showToast(msg: 'No match found');
      favCreators.value = fetchAllFavCreators;
    }

    if (value.isBlank || favCreators.isEmpty) {
      favCreators.value = fetchAllFavCreators;
    }

  }

}
