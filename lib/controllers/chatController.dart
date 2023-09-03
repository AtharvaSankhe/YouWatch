import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/models/profilemodel.dart';
import 'package:youwatchbuddy/repository/authenication_repository/authenication_repository.dart';

class ChatController extends GetxController{

  static ChatController get instance => Get.find();

  final _firebaseFirestore  = FirebaseFirestore.instance ;
  RxList<Details> allusers = <Details>[].obs;
  RxList<Details> recentChats = <Details>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async{
    final querySnapshot = await _firebaseFirestore.collection('users').get();
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    for (int i = 0; i < documents.length; i++) {
      allusers.add(Details.fromDocumentSnapShot(documents[i]));
    }
  }








}