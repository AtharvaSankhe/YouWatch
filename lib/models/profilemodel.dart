import 'package:cloud_firestore/cloud_firestore.dart';

class Details{
  String? email ;
  String? imagePath ;
  String? name ;
  String? password ;


  Details({
    this.email ,
    this.imagePath ,
    this.name ,
    this.password ,

  });


  Map<String,dynamic> toJson(){
    return {
      'email': email,
      'imagePath': imagePath,
      'name': name,
      'password': password,
    };
  }

  static Details fromDocumentSnapShot(DocumentSnapshot snapshot){
    var docSnapshot = snapshot.data() as Map<String, dynamic>;
    return Details(
      email: docSnapshot["email"],
      imagePath: docSnapshot["imagePath"],
      name: docSnapshot["name"],
      password: docSnapshot["password"],

    );
  }


}