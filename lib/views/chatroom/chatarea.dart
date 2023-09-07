import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/models/profilemodel.dart';
import 'package:youwatchbuddy/repository/authenication_repository/authenication_repository.dart';

class ChatArea extends StatefulWidget {
  String name;
  String email;
  String imagePath;

  ChatArea(
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
    String withWho = widget.email!.toLowerCase();
    String user2name =
        AuthenticationRepository.instance.currentUserInfo.value.email!;
    int result = withWho.compareTo(user2name);
    if (result < 0) {
      return "${widget.email!.toLowerCase()}$user2name";
    } else {
      return "$user2name${widget.email!.toLowerCase()}";
    }
  }

  void sendMessage() async {
    if (msgController.text.isNotEmpty) {
      String msg = msgController.text;
      msgController.clear();
      DateTime time = DateTime.now();
      Map<String, dynamic> messages = {
        'sendBy': widget.name!,
        'message': msg,
        'order': FieldValue.serverTimestamp(),
        'time': "${time.hour}:${time.minute}",
      };
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
        'imagePath': widget.imagePath,
        'last msg': msg,
        'lastMsgTime': FieldValue.serverTimestamp(),
        'email': widget.email,
      });
    } else {
      Fluttertoast.showToast(msg: 'Please enter some text');
    }
  }

  // Future<void> createRoom() async{
  //   Details currentUserinfo = AuthenticationRepository.instance.currentUserInfo.value ;
  //   await _firebaseFirestore.collection('chatroom').doc(roomId).set({
  //     'email1': currentUserinfo.email,
  //     'imagePath1': currentUserinfo.email,
  //     'name1': currentUserinfo.name,
  //     'password1': currentUserinfo.password,
  //     'email2':widget.chatWith.email,
  //     'imagePath2':widget.chatWith.imagePath,
  //     'name2':widget.chatWith.name,
  //     'password2':widget.chatWith.password,
  //   });
  // }

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
                child: widget.imagePath == ''
                    ? Image.asset('assets/login/loginAvatar.png')
                    : FadeInImage(
                        image: NetworkImage(widget.imagePath ?? ""),
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
            Text(
              widget.name ?? "",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
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
              Container(
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
            .orderBy("order", descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> map =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;
                return Message(
                  size: size,
                  map: map,
                );
              },
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
  Size size;
  Map<String, dynamic> map;

  Message({Key? key, required this.size, required this.map}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isUser = map['sendBy'] ==
        AuthenticationRepository.instance.currentUserInfo.value.name;
    return Container(
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
                          .split(":")[1]
                          .toString() +':'+
                      map['order']
                          .toDate()
                          .toString()
                          .split(" ")[1]
                          .toString()
                          .split(":")[2]
                          .toString().split('.')[0].toString() ,
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
    );
  }
}
