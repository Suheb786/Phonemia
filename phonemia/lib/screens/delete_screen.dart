import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:phonemia/constants/colors.dart';
import 'package:phonemia/screens/wrapper.dart';

class DeleteScreen extends StatefulWidget {
  static const routeName = "delete_screen";
  @override
  _DeleteScreenState createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('meme').snapshots();
  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

  final storage = FirebaseStorage.instance;
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1,
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          color: Colors.white,
          backgroundColor: Colors.grey,
        ),
        opacity: 0.5,
        inAsyncCall: _uploading,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Delete Memes",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Baloo2',
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _usersStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Something went wrong...',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Baloo",
                          ),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                          child: Text(
                        "Loading...",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Baloo",
                        ),
                      ));
                    } else if (snapshot.data!.size == 0) {
                      return Center(
                          child: Text(
                        "No Memes Avalable",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Baloo",
                        ),
                      ));
                    }

                    return ListView(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        final docId = document.reference.id;

                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: boxshd2,
                          child: ListTile(
                            trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      backgroundColor: bg1,
                                      title: Text(
                                        "Delete",
                                        style: TextStyle(
                                            fontFamily: 'Baloo2',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                      content: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            data['title'],
                                            style: TextStyle(
                                              fontFamily: 'Baloo',
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            data['description'],
                                            style: TextStyle(
                                              fontFamily: 'Baloo2',
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          //! Delete meme logic here...
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _uploading = true;
                                            });
                                            await storage
                                                .refFromURL(data['audioUrl'])
                                                .delete();
                                            await storage
                                                .refFromURL(
                                                    data['thumbnailUrl'])
                                                .delete();
                                            await FirebaseFirestore.instance
                                                .collection('meme')
                                                .doc(docId)
                                                .delete();
                                            setState(() {
                                              _uploading = false;
                                            });
                                          },
                                          child: Text(
                                            "Confirm",
                                            style: TextStyle(
                                              fontFamily: 'Baloo2',
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              fontFamily: 'Baloo2',
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                )),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            title: Text(
                              data['title'],
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Baloo',
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['description'],
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'Baloo2',
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Category : ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Baloo',
                                      ),
                                    ),
                                    Text(
                                      data['category'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Baloo2',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(data["thumbnailUrl"]),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
