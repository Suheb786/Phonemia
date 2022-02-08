import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:phonemia/constants/colors.dart';
import 'package:phonemia/screens/wrapper.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "home_screen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('meme').snapshots();
  AudioPlayer audioPlayer = AudioPlayer();

  play(String url) async {
    int result = await audioPlayer.play(url);
    if (result == 1) {
      print('Successful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primarybtn,
        onPressed: () {
          Navigator.of(context).pushNamed(Wrapper.routeName);
        },
        child: Text(
          "Admin",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Baloo',
          ),
        ),
      ),
      backgroundColor: bg1,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Memes",
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
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: boxshd2,
                        child: ListTile(
                          onTap: () async {
                            await play(data['audioUrl'].toString());
                          },
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
    );
  }
}
