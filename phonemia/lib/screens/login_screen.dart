import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:phonemia/constants/colors.dart';
import 'package:phonemia/screens/uploader.dart';

class LogInScreen extends StatefulWidget {
  static const routeName = "/";
  LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwrodController = TextEditingController();

  String errmsg = "";
  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bg1,

        // Container(
        //   decoration: BoxDecoration(

        //       image: DecorationImage(
        //         image: AssetImage("assets/images/bg.png"),
        //         fit: BoxFit.cover,

        //       ),

        //       ),
        // ),
        body: ModalProgressHUD(
          progressIndicator: CircularProgressIndicator(
            color: Colors.white,
            backgroundColor: Colors.grey,
          ),
          opacity: 0.5,
          inAsyncCall: _uploading,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Admin Login',
                  style: TextStyle(
                    color: h1clr,
                    fontFamily: 'Baloo',
                    fontSize: 32,
                  ),
                ),
                const SizedBox(
                  height: 16.69,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Container(
                        height: 227,
                        decoration: BoxDecoration(
                          color: boxshd3,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Container(
                        height: 197,
                        decoration: BoxDecoration(
                          color: boxshd2,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      Container(
                        height: 167,
                        decoration: BoxDecoration(
                          color: boxshd1,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Form(
                          key: _formkey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  style: TextStyle(
                                      fontFamily: 'Baloo2',
                                      color: HexColor('#B2DAFF')),
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: CustomInputDecoration(
                                      hnttxt: 'Email',
                                      prfxicn: Image.asset(
                                          'assets/icons/Emailsign.png')),
                                  validator: (_val) {
                                    if (_val!.isEmpty) {
                                      return "Email can't be Empty";
                                    } else if (!_val.contains("@")) {
                                      return "invalid Email";
                                    }
                                  },
                                ),
                                Divider(
                                  color: HexColor('#999999'),
                                  thickness: 2.69,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  controller: _passwrodController,
                                  validator: (_val) {
                                    if (_val!.isEmpty) {
                                      return "Hey!!!!! Password??";
                                    } else if (_val
                                            .replaceAll(RegExp(r"\s+"),
                                                "") //replaceAll(RegExp(r"\s+") to do not count space
                                            .length <
                                        6)
                                      return "Password can't be less than 6 characters";
                                  },
                                  style: TextStyle(
                                      fontFamily: 'Baloo2',
                                      color: HexColor('#B2DAFF')),
                                  // obscureText: true,
                                  decoration: CustomInputDecoration(
                                      hnttxt: 'Password',
                                      prfxicn:
                                          Image.asset('assets/icons/Lock.png')),
                                ),
                                Divider(
                                  color: HexColor('#999999'),
                                  thickness: 2.69,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  errmsg,
                  style: TextStyle(
                      color: Colors.red[300],
                      fontFamily: 'Baloo2',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      fontStyle: FontStyle.italic),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    primary: primarybtn,
                    elevation: 2,
                    textStyle: TextStyle(
                      fontFamily: 'Baloo',
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        _uploading = true;
                      });
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwrodController.text);
                        setState(() {
                          _uploading = false;
                        });
                        // Navigator.of(context).pushNamed(UploaderScreen.routeName);
                      } catch (e) {
                        setState(() {
                          errmsg = "Invalid Cradiential";
                          _uploading = false;
                        });
                      }
                    }
                  },
                  child: const Text('Login'),
                ),
                SizedBox(
                  height: 2.72,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: darkbluebutton,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13))),
                    onPressed: () {},
                    child: Text(
                      "Request to become an Admin",
                      style: TextStyle(
                        fontFamily: 'Baloo',
                        fontSize: 18,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration CustomInputDecoration(
      {String? hnttxt, required Image prfxicn}) {
    return InputDecoration(
        hintStyle: TextStyle(color: HexColor('DFDFDF'), fontFamily: 'Baloo2'),
        hintText: hnttxt,
        errorStyle: TextStyle(color: Colors.red[400]),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 1),
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: prfxicn,
        ),
        prefixIconConstraints: BoxConstraints(
          minHeight: 2,
        ),
        focusedBorder: InputBorder.none);
  }
}
