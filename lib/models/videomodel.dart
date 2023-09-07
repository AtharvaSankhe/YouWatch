
import 'package:cloud_firestore/cloud_firestore.dart';

class Video{
  String? userEmail ;
  String? userName ;
  String? videoID ;
  String? title ;
  String? description ;
  String? category;
  String? videoUrl;
  String? thumbnailUrl;
  int? publishedDateTime;
  int? comments;
  List? likesList ;
  // String? location ;

  Video({
    this.userEmail ,
    this.userName ,
    this.videoID ,
    this.title ,
    this.description ,
    this.category,
    this.videoUrl,
    this.thumbnailUrl,
    this.publishedDateTime,
    this.comments,
    this.likesList ,
    // this.location
});


  Map<String,dynamic> toJson(){
    return {
      'userEmail': userEmail,
      'userName': userName,
      'videoID': videoID,
      'title': title,
      'description': description ,
      'category': category,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'publishedDateTime': publishedDateTime,
      'comments': comments,
      'likesList': likesList,
      // 'location': location,
    };
  }

  static Video fromDocumentSnapShot(DocumentSnapshot snapshot){
    var docSnapshot = snapshot.data() as Map<String, dynamic>;
    return Video(
        userEmail: docSnapshot["userEmail"],
        userName: docSnapshot["userName"],
        videoID: docSnapshot["videoID"],
    title: docSnapshot["title"],
    description: docSnapshot["description"],
    category: docSnapshot["category"],
    videoUrl: docSnapshot["videoUrl"],
    thumbnailUrl: docSnapshot["thumbnailUrl"],
    publishedDateTime: docSnapshot["publishedDateTime"],
    comments: docSnapshot["comments"],
    likesList: docSnapshot["likesList"],
    //   location: docSnapshot["location"],
    );
  }


}