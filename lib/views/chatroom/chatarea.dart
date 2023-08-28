import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/models/profilemodel.dart';
import 'package:youwatchbuddy/repository/authenication_repository/authenication_repository.dart';

class ChatArea extends StatefulWidget {
  Details chatWith;

  ChatArea({Key? key, required this.chatWith}) : super(key: key);

  @override
  State<ChatArea> createState() => _ChatAreaState();
}

class _ChatAreaState extends State<ChatArea> {
  final _firebaseFirestore = FirebaseFirestore.instance;

  late String roomId;

  String createRoomId() {
    int codeUnit1 = widget.chatWith.email!.toLowerCase().codeUnits[0];
    String user2name = AuthenticationRepository.instance.currentUserInfo.value.email!;
    int codeUnit2 = user2name.toLowerCase().codeUnits[0];
    // if ( >
    //         AuthenticationRepository.instance.currentUserInfo.value.email! ??
    //     "".toLowerCase().codeUnits[0]) {
    //   return "$";
    // }
    if(codeUnit1>codeUnit2){
      return "${widget.chatWith.email!.toLowerCase()}${user2name}";
    }else{
      return "${user2name}${widget.chatWith.email!.toLowerCase()}";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roomId = createRoomId();
    debugPrint(roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade800,
        title: Row(
          children: [
            Container(
              height: 35,
              width: 35,
              padding: const EdgeInsets.all(0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: widget.chatWith.imagePath == ''
                    ? Image.asset('assets/login/loginAvatar.png')
                    : FadeInImage(
                        image: NetworkImage(widget.chatWith.imagePath ?? ""),
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
            Text(widget.chatWith.name ?? ""),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
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
              const Expanded(
                child: TextField(
                  cursorColor: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.mic,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.photo_size_select_actual_outlined,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.send,
                  color: Colors.grey.shade800,
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore
            .collection('chatrooms')
            .doc(roomId)
            .collection('chats')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container();
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
