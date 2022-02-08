// import 'package:file_picker/file_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:phonemia/constants/colors.dart';
import 'package:phonemia/services/database.dart';
import 'package:phonemia/services/storage.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'delete_screen.dart';
import 'home_screen.dart';

class UploaderScreen extends StatefulWidget {
  static const routeName = "uploader";
  const UploaderScreen({Key? key}) : super(key: key);

  _UploaderScreenState createState() => _UploaderScreenState();
}

class _UploaderScreenState extends State<UploaderScreen> {
  // final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String thumbnailText = 'Select Thumbnail';

  final storageClass = Storage();
  final db = Database();

  String thumbnailIconPath = 'assets/icons/Attach.png';

  String audioSelected = 'Select An Audio File';

  String audioIconPath = "assets/icons/Music.png";

  String? thumbnailPath;
  String? thumbnailFileName;
  String? audioPath;
  String? audioFileName;

  List<String> categories = [
    'Modi Ji',
    "18+",
    "Others",
  ];

  FilePickerResult? thumbnailResults;

  FilePickerResult? audioResults;
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    String selectedCategory = categories[2];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: bg1,
              title: Text(
                "Log Out",
                style: TextStyle(
                    fontFamily: 'Baloo2',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              content: const Text(
                "Confirm to Log Out",
                style: TextStyle(
                  fontFamily: 'Baloo2',
                  color: Colors.white,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(HomeScreen.routeName),
                    );
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
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        backgroundColor: HexColor('#002947'),
        child: Icon(Icons.logout),
      ),
      backgroundColor: bg1,
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(
          color: Colors.white,
          backgroundColor: Colors.grey,
        ),
        opacity: 0.5,
        inAsyncCall: _uploading,
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: HexColor('#053159'),
                      ),
                      child: IconButton(
                        // icon: Image.asset('assets/icons/Logout.png'),
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () => Navigator.of(context)
                            .pushNamed(DeleteScreen.routeName),
                      ),
                    ),
                    Text(
                      "Hi, Admin ", //? todo '
                      style: TextStyle(
                          color: h1clr, fontFamily: "Baloo", fontSize: 39.6),
                    ),
                    Text(
                      "Upload a New Meme ", //? todo '
                      style: TextStyle(
                          height: 1.5,
                          color: h1clr,
                          fontFamily: "Baloo",
                          fontSize: 19.6),
                    ),
                    const SizedBox(
                      height: 10.15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: HexColor('#41414130').withOpacity(0.19),
                          borderRadius: BorderRadius.circular(16.54)),
                      child: Column(
                        children: [
                          InkWell(
                            customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15))),
                            onTap: () async {
                              thumbnailResults =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.custom,
                                allowedExtensions: ['png', 'jpg'],
                              );
                              if (thumbnailResults == null) {
                                setState(() {
                                  thumbnailText = 'Select Thumbnail';
                                  thumbnailIconPath = 'assets/icons/Attach.png';
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No File Selected',
                                      style: TextStyle(
                                          fontFamily: 'Baloo2',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                                return;
                              } else {
                                thumbnailPath =
                                    thumbnailResults!.files.single.path!;
                                thumbnailFileName =
                                    thumbnailResults!.files.single.name;
                                setState(() {
                                  thumbnailText = thumbnailFileName!;
                                  thumbnailIconPath =
                                      'assets/icons/Checkmark.png';
                                });
                                // await storageClass.uploadFile(path, fileName);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 23.0, top: 16.45, bottom: 16.45),
                              child: Row(
                                children: [
                                  Image.asset(
                                    thumbnailIconPath,
                                    height: 31.25,
                                    width: 27.25,
                                  ),
                                  const SizedBox(
                                    width: 15.08,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 120,
                                    child: Text(
                                      thumbnailText,
                                      style: customTextStyle(19.74),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              audioResults = await FilePicker.platform
                                  .pickFiles(
                                      allowMultiple: false,
                                      type: FileType.custom,
                                      allowedExtensions: ["mp3"],
                                      dialogTitle: "Pink a .mp3 file");

                              if (audioResults == null) {
                                setState(() {
                                  audioIconPath = "assets/icons/Music.png";
                                  audioSelected = "Select an Audio File";
                                  audioFileName = '';
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'No mp3 Selected',
                                      style: TextStyle(
                                          fontFamily: 'Baloo2',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              } else {
                                audioPath = audioResults!.files.single.path!;
                                audioFileName = audioResults!.files.single.name;
                                setState(() {
                                  audioIconPath = "assets/icons/Checkfile.png";
                                  audioSelected = "File selected";
                                  audioFileName = audioFileName;
                                });
                              }
                            },
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: HexColor('#414141').withOpacity(0.19),
                                  borderRadius: BorderRadius.circular(15)),
                              height: 109,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    audioIconPath,
                                    height: 37,
                                  ),
                                  Text(
                                    audioSelected,
                                    style: customTextStyle(19.74),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 120,
                                    child: Center(
                                      child: audioFileName == null
                                          ? Container()
                                          : Text(
                                              audioFileName!,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: HexColor("#50e6ff"),
                                                  fontStyle: FontStyle.italic),
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12.89,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: HexColor('#696969').withOpacity(0.19)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10.69),
                                      child: Text(
                                        'Title:',
                                        style: customTextStyle(19.74),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.82,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10.69),
                                      child: Container(
                                        width: 273.6,
                                        height: 36.19,
                                        decoration: BoxDecoration(
                                          color: HexColor("#BEBEBE")
                                              .withOpacity(0.19),
                                          borderRadius:
                                              BorderRadius.circular(16.45),
                                        ),

                                        // ! Title Text field.

                                        child: TextFormField(
                                          controller: _titleController,
                                          style: TextStyle(
                                              fontSize: 18.74,
                                              fontFamily: 'Baloo2',
                                              fontWeight: FontWeight.bold,
                                              color: HexColor('#7DCBFF')),
                                          decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                  color: Colors.red[400]),
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              enabledBorder: InputBorder.none,
                                              errorBorder: InputBorder.none,
                                              focusedErrorBorder:
                                                  InputBorder.none,
                                              prefix: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                              ),
                                              suffix: const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5),
                                              ),
                                              focusedBorder: InputBorder.none),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 17.27),
                                      child: Text(
                                        'Decription:',
                                        style: customTextStyle(19.74),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.82,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10.42),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: HexColor('4a4a48')),
                                        height: 82.58,
                                        width: 220.14,
                                        //! Discription Text field

                                        child: TextField(
                                          keyboardType: TextInputType.multiline,
                                          controller: _descriptionController,
                                          minLines: 1,
                                          maxLines: 3,
                                          style: TextStyle(
                                              fontSize: 16.74,
                                              fontFamily: 'Baloo2',
                                              fontWeight: FontWeight.bold,
                                              color: HexColor('#7DCBFF')),
                                          decoration: const InputDecoration(
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            prefix: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                            ),
                                            suffix: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.only(top: 10.69),
                                //       child: Text(
                                //         'tag:',
                                //         style: customTextStyle(19.74),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: 14.54,
                                //     ),
                                //     Padding(
                                //       padding: const EdgeInsets.only(top: 10.69),
                                //       child: Container(
                                //         width: 273.6,
                                //         height: 36.19,
                                //         decoration: BoxDecoration(
                                //           color: HexColor("#BEBEBE")
                                //               .withOpacity(0.19),
                                //           borderRadius:
                                //               BorderRadius.circular(16.45),
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'Catagory:',
                                          style: customTextStyle(19.74),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16.45),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: ToggleSwitch(
                                                initialLabelIndex:
                                                    categories.indexWhere(
                                                  (element) =>
                                                      element ==
                                                      selectedCategory,
                                                ),
                                                totalSwitches:
                                                    categories.length,
                                                labels: categories,
                                                onToggle: (index) {
                                                  selectedCategory =
                                                      categories[index!];
                                                  print(
                                                      'Switched to: ${selectedCategory}');
                                                },
                                                cornerRadius: 16.45,
                                                activeBgColor: [
                                                  HexColor('#F6F6F6')
                                                      .withOpacity(0.92),
                                                ],
                                                animate: true,
                                                animationDuration: 100,
                                                fontSize: 16.45,
                                                minWidth: 98,
                                                minHeight: 36,
                                                inactiveFgColor: Colors.white54,
                                                radiusStyle: true,
                                                inactiveBgColor:
                                                    HexColor('3D3D3D'),
                                                borderWidth: 0.3,
                                                curve: Curves.easeIn,
                                                doubleTapDisable: false,
                                                dividerColor: Colors.white24,
                                                customTextStyles: const [
                                                  null,
                                                  TextStyle(
                                                    fontFamily: "Baloo",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 19.75,
                                                    color: Colors.red,
                                                  ),
                                                  null,
                                                  TextStyle(
                                                    fontFamily: "Baloo",
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 19.75,
                                                  ),
                                                ],
                                                activeFgColor: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 3,
                                textStyle: const TextStyle(
                                  fontFamily: 'Baloo',
                                  fontSize: 19.74,
                                ),
                                primary: HexColor('#002947'),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.12),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16.45))),
                            onPressed: () async {
                              if (thumbnailResults == null) {
                                customDialogBox(
                                    context: context,
                                    title: "Please Select a thumbnail.");
                              } else if (audioResults == null) {
                                customDialogBox(
                                    context: context,
                                    title: "Please Select a .mp3 file.");
                              } else if (_titleController.text.isEmpty ||
                                  _descriptionController.text.isEmpty) {
                                customDialogBox(
                                    context: context,
                                    title:
                                        "Title and description are required.");
                              } else if (_titleController.text.length <= 6 ||
                                  _descriptionController.text.length <= 6) {
                                customDialogBox(
                                    context: context,
                                    title:
                                        "Title and Description can't be less then 6 characters.");
                              } else {
                                setState(() {
                                  _uploading = true;
                                });
                                final thumbnailUrl =
                                    await storageClass.uploadFile(
                                        folderName: "thumb",
                                        filePath: thumbnailPath!,
                                        fileName: thumbnailFileName!);
                                final audioFileUrl =
                                    await storageClass.uploadFile(
                                        folderName: "audio",
                                        filePath: audioPath!,
                                        fileName: audioFileName!);

                                if (thumbnailUrl == null ||
                                    audioFileUrl == null) {
                                  setState(() {
                                    _uploading = false;
                                  });
                                  customDialogBox(
                                      context: context,
                                      title: "Upload Error Please try again");
                                  return;
                                } else {
                                  Map<String, dynamic> uploadData = {
                                    'type': 'memeCard',
                                    'category': selectedCategory,
                                    'title': _titleController.text,
                                    'description': _descriptionController.text,
                                    'thumbnailUrl': thumbnailUrl,
                                    'audioUrl': audioFileUrl,
                                  };
                                  final uploadedCard =
                                      await db.memeCard(uploadData);
                                  if (uploadedCard!.id.isEmpty) {
                                    setState(() {
                                      _uploading = false;
                                    });
                                    customDialogBox(
                                        context: context,
                                        title:
                                            "Database Listing Failed Please try again");
                                    return;
                                  }
                                  print(uploadedCard);
                                  print(uploadData.toString());

                                  setState(() {
                                    _uploading = false;

                                    thumbnailResults = null;
                                    audioResults = null;
                                    thumbnailText = 'Select Thumbnail';
                                    thumbnailIconPath =
                                        'assets/icons/Attach.png';
                                    audioIconPath = "assets/icons/Music.png";
                                    audioSelected = "Select an Audio File";
                                    audioFileName = '';
                                    _titleController.clear();
                                    _descriptionController.clear();
                                  });
                                  customDialogBox(
                                      context: context,
                                      title: "Upload Successful");
                                }
                              }
                            },
                            child: const Text('Post'),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> customDialogBox({
    required BuildContext context,
    required String title,
  }) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              title,
              style: TextStyle(fontFamily: 'baloo'),
            ),
            actions: [
              TextButton(
                child: Text(
                  "Ok",
                  style: TextStyle(fontFamily: 'baloo'),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  // TextFormField BoxTextField({
  //   required Key key,
  //   required TextEditingController ctrlr,
  //   required String? Function(String?) validator,
  // }) {
  //   return TextFormField(
  //     key: key,
  //     validator: validator,
  //     controller: ctrlr,
  //     style: TextStyle(
  //         fontSize: 18.74,
  //         fontFamily: 'Baloo2',
  //         fontWeight: FontWeight.bold,
  //         color: HexColor('#7DCBFF')),
  //     decoration: InputDecoration(
  //         errorStyle: TextStyle(color: Colors.red[400]),
  //         isDense: true,
  //         contentPadding: EdgeInsets.symmetric(vertical: 4),
  //         enabledBorder: InputBorder.none,
  //         errorBorder: InputBorder.none,
  //         focusedErrorBorder: InputBorder.none,
  //         prefix: Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 5),
  //         ),
  //         suffix: Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 5),
  //         ),
  //         focusedBorder: InputBorder.none),
  //   );
  // }

  TextStyle customTextStyle(double fntsize) {
    return TextStyle(
        height: 1.5, color: h1clr, fontFamily: "Baloo", fontSize: fntsize);
  }
}
