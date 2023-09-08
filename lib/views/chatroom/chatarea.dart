import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youwatchbuddy/models/profilemodel.dart';
import 'package:youwatchbuddy/repository/authenication_repository/authenication_repository.dart';

class ChatArea extends StatefulWidget {
  final String name;
  final String email;
  final String imagePath;

  const ChatArea(
      {Key? key,
      required this.name,
      required this.email,
      required this.imagePath})
      : super(key: key);

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController msgController = TextEditingController();

  String lastTime = '';
  String lastMsg = '';

  late String roomId;

  String createRoomId() {
    String withWho = widget.email.toLowerCase();
    String user2name =
        AuthenticationRepository.instance.currentUserInfo.value.email!;
    int result = withWho.compareTo(user2name);
    if (result < 0) {
      debugPrint('creating room Id $withWho$user2name');
      return "$withWho$user2name";
    } else {
      debugPrint('creating room Id $user2name$withWho');
      return "$user2name$withWho";
    }
  }

  void sendMessage() async {
    if (msgController.text.isNotEmpty) {
      String msg = msgController.text;
      msgController.clear();
      DateTime time = DateTime.now();
      Map<String, dynamic> messages = {
        'sendBy': widget.name,
        'message': msg,
        'type':'text',
        'order': FieldValue.serverTimestamp(),
        'time': "${time.hour}:${time.minute}",
      };
      debugPrint("Room id is before sending $roomId");

      await _firebaseFirestore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .doc(time.toString())
          .set(messages);

      await _firebaseFirestore
          .collection('users')
          .doc(AuthenticationRepository.instance.currentUserInfo.value.email)
          .collection('chats')
          .doc(widget.email)
          .set({
        'user': widget.name,
        'imagePath': widget.imagePath,
        'last msg': msg,
        'lastMsgTime': FieldValue.serverTimestamp(),
        'email': widget.email,
      });

      await _firebaseFirestore
          .collection('users')
          .doc(widget.email)
          .collection('chats')
          .doc(AuthenticationRepository.instance.currentUserInfo.value.email)
          .set({
        'user': AuthenticationRepository.instance.currentUserInfo.value.name,
        'imagePath':
            AuthenticationRepository.instance.currentUserInfo.value.imagePath,
        'last msg': msg,
        'lastMsgTime': FieldValue.serverTimestamp(),
        'email': AuthenticationRepository.instance.currentUserInfo.value.email,
      });
      debugPrint("Room id is after sending $roomId");
    } else {
      Fluttertoast.showToast(msg: 'Please enter some text');
    }
  }

  File? imgFile ;
  Future<void> getImage(ImageSource sourceImg) async{
    ImagePicker _picker = ImagePicker();
    final img =await _picker.pickImage(source: sourceImg).then((xFile) {
      if(xFile != null ){
        imgFile = File(xFile.path);
        uploadImg();
      }else{
        Fluttertoast.showToast(msg: "Img not selected");
      }
    });
  }

  Future<void> uploadImg() async{

    int status =1;
    String imgID = "${DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()}.jpg";

    DateTime time = DateTime.now();
    Map<String, dynamic> messages = {
      'sendBy': widget.name,
      'message': '',
      'type':'img',
      'order': FieldValue.serverTimestamp(),
      'time': "${time.hour}:${time.minute}",
    };
    debugPrint("Room id is before sending $roomId");

    await _firebaseFirestore
        .collection('chatroom')
        .doc(roomId)
        .collection('chats')
        .doc(imgID)
        .set(messages);

    var ref = FirebaseStorage.instance.ref().child('Chatimages').child(imgID);

    var uploadTask  =  await ref.putFile(imgFile!).catchError((e)async{
      await _firebaseFirestore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .doc(imgID)
          .delete();

      status = 0;
    });

    if (status ==1){
      String imageUrl = await  uploadTask.ref.getDownloadURL();
      await _firebaseFirestore
          .collection('chatroom')
          .doc(roomId)
          .collection('chats')
          .doc(imgID).update({'message': imageUrl,});
      debugPrint(imageUrl);
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomId = createRoomId();
    // createRoom();
    debugPrint(roomId);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize:  const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.grey.shade800,
          title: Row(
            children: [
              Container(
                height: 35,
                width: 35,
                padding: const EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: widget.imagePath == ''
                      ? Image.asset('assets/login/loginAvatar.png')
                      : FadeInImage(
                          image: NetworkImage(widget.imagePath),
                          // height: 200,
                          placeholder:
                              const AssetImage('assets/login/loginAvatar.png'),
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: _firebaseFirestore
                        .collection('users')
                        .doc(widget.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return snapshot.data!['status'] == 'Online'
                            ? Text(
                                snapshot.data!['status'],
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              )
                            : Container();
                      } else {
                        return Container();
                      }
                    },
                  )
                  // const Text(
                  //   "Online",
                  //   style: TextStyle(
                  //       color: Colors.green,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 12),
                  // ),
                ],
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
              // debugPrint(widget.email);
              // debugPrint(AuthenticationRepository.instance.currentUserInfo.value.email);
              // debugPrint("Room id is $roomId");
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.black,
        height: 80,
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 25),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: msgController,
                  cursorColor: Colors.black,
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 17,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.mic,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: (){
                  getImage(ImageSource.gallery);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.photo_size_select_actual_outlined,
                    color: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  sendMessage();
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.amber,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore
            .collection('chatroom')
            .doc(roomId)
            .collection('chats')
            .orderBy("order", descending: true )
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            return Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: size.height-190,
                  child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> map = snapshot.data!.docs[index]
                          .data() as Map<String, dynamic>;
                      return Message(
                        size: size,
                        map: map,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 90,
                ),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

// Widget messages(Size size, Map<String, dynamic> map) {
//   bool seqChecker = false ;
//   if(lastMsg==map['sendBy']){
//     seqChecker = true;
//   }
//   // seqChecker = seqChecker ;
//
//   lastTime = map['time'];
//   lastMsg = map['sendBy'];
//   bool isUser = map['sendBy'] ==
//       AuthenticationRepository.instance.currentUserInfo.value.name;
//   return Container(
//     width: size.width,
//     alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
//     child: Container(
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
//       decoration: BoxDecoration(
//         color: isUser ? Colors.grey.shade800 : Colors.amber,
//         borderRadius: isUser
//             ? const BorderRadius.only(
//                 topRight: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//                 bottomLeft: Radius.circular(30))
//             : const BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//                 bottomLeft: Radius.circular(30)),
//       ),
//       child: Text(
//         map['message'],
//         style: TextStyle(
//             color: isUser ? Colors.white : Colors.black, fontSize: 17),
//       ),
//     ),
//   );
// }
}

class Message extends StatelessWidget {
  final Size size;
  final Map<String, dynamic> map;

  const Message({Key? key, required this.size, required this.map})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isUser = map['sendBy'] ==
        AuthenticationRepository.instance.currentUserInfo.value.name;
    return map['type']=='text'?Container(
      width: size.width,
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        decoration: BoxDecoration(
          color: isUser ? Colors.grey.shade800 : Colors.amber,
          borderRadius: isUser
              ? const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30))
              : const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              map['message'],
              style: TextStyle(
                  color: isUser ? Colors.white : Colors.black, fontSize: 17),
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  map['order']
                          .toDate()
                          .toString()
                          .split(" ")[1]
                          .toString()
                          .split(":")[0]
                          .toString() +
                      ':' +
                      map['order']
                          .toDate()
                          .toString()
                          .split(" ")[1]
                          .toString()
                          .split(":")[1]
                          .toString()
                          .split('.')[0]
                          .toString(),
                  style: TextStyle(
                      color: isUser ? Colors.white : Colors.black, fontSize: 9),
                ),
                // const SizedBox(
                //   width: 5,
                // ),
                // Text(
                //   'sending',
                //   style: TextStyle(
                //       color: isUser ? Colors.white : Colors.black, fontSize: 9),
                // )
              ],
            )
          ],
        ),
      ),
    ):Container(
      height: size.height/2.5,
      width: size.width,
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        height: size.height/2.5,
        width: size.width/2.5,
        alignment: Alignment.center,
        child: map['message'] != ''?Image.network(map['message']):const CircularProgressIndicator(color: Colors.yellowAccent,),
      ),
    );
  }
}
