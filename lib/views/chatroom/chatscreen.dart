import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youwatchbuddy/controllers/chatController.dart';
import 'package:youwatchbuddy/models/profilemodel.dart';
import 'package:youwatchbuddy/repository/authenication_repository/authenication_repository.dart';
import 'package:youwatchbuddy/views/chatroom/chatarea.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
              child: InkWell(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: SearchScreen(),
                  );
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Search',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(AuthenticationRepository
                        .instance.currentUserInfo.value.email)
                    .collection('chats')
                    .orderBy("lastMsgTime", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 5),
                      itemCount: snapshot.data!.docs.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 15,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return InkWell(
                          onTap: () {
                            Get.to(() => ChatArea(
                                  name: map['user'],
                                  email: map['email'],
                                  imagePath: map['imagePath'],
                                ));
                          },
                          child: ListTile(
                            leading: map['imagePath'] == ''
                                ? Image.asset('assets/login/loginAvatar.png')
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(map['imagePath'])),
                            title: Text(
                              map['user'] ?? "",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                            subtitle: SizedBox(
                                width: double.infinity,
                                child: Text(
                                  map['last msg'] ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10),
                                )),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }
}

class SearchScreen extends SearchDelegate {
  ChatController chatController = Get.find();

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
      onPressed: () {
        return close(context, null);
      },
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.grey.shade600,
      ));

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.from(
        colorScheme: const ColorScheme.dark(primary: Colors.black));
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: Icon(
            Icons.clear,
            color: Colors.grey.shade600,
          )),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: const TextStyle(
            fontSize: 64, fontWeight: FontWeight.w700, color: Colors.amber),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Details> suggestions = chatController.allusers
        .where((element) =>
            element.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // {
    //   final result = element.name!.toLowerCase();
    //   final input = query.toLowerCase();
    //
    //   return result.contains(input);
    // }).toList();

    return Container(
      color: Colors.black,
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (BuildContext context, int index) {
          final suggestion = suggestions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: ListTile(
              title: Text(suggestion.name ?? ""),
              leading: suggestion.imagePath == ''
                  ? Image.asset(
                      'assets/login/loginAvatar.png',
                      height: 50,
                      width: 50,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        suggestion.imagePath ?? '',
                        height: 50,
                        width: 50,
                      )),
              onTap: () {
                query = suggestion.name ?? "";
                Get.to(() => ChatArea(
                      name: suggestion.name!,
                      email: suggestion.email!,
                      imagePath: suggestion.imagePath!,
                    ));
                // showResults(context);
              },
            ),
          );
        },
      ),
    );
  }
}
