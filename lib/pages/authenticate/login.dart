import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:smartlights/model_providers/user.dart';
import 'package:smartlights/services/authenticate.dart';
import 'package:smartlights/shared/decorations.dart';
import 'package:smartlights/shared/shapes/shapes.dart';
import 'package:smartlights/shared/widgets/loading.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email, password, error = '';

  bool pressed = false;

  final _formKey = GlobalKey<FormState>();

  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final teacherProvider = Provider.of<Teacher>(context, listen: false);
    return pressed == true
        ? Loading()
        : SafeArea(
            child: Scaffold(
              body: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Icon(
                    Icons.person,
                    size: 175,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            validator: (val) =>
                                !val.contains('@') && val.contains(' ')
                                    ? 'Please enter a valid email address'
                                    : null,
                            decoration:
                                textFormDecoration.copyWith(hintText: 'Email'),
                            onChanged: (val) => email = val,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            validator: (val) => !val.contains(new RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))
                                ? 'Password must be atleast 8 characters long\nMust contain a number\nMust have a capital and a small letter\nMust have a special character'
                                : null,
                            decoration: textFormDecoration.copyWith(
                                hintText: 'Password'),
                            onChanged: (val) => password = val,
                            obscureText: true,
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: Shapes.loginButton,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                print('$email $password');

                                setState(() {
                                  pressed = true;
                                });
                                try {
                                  teacherProvider.email = email.trim();

                                  teacherProvider.userID = email
                                      .trim()
                                      .substring(0, email.trim().indexOf('@'));
                                  teacherProvider.fetchDetails();
                                  var box = await Hive.openBox('teacher');

                                  box.put('email', teacherProvider.email);
                                  box.put('userID', teacherProvider.userID);
                                  dynamic user =
                                      await _auth.signInWithEmailAndPassword(
                                          email.trim(), password);

                                  if (user != null) {
                                    error = '';
                                  } else {
                                    var box = await Hive.openBox('teacher');

                                    box.put('email', null);
                                    box.put('userID', null);
                                    setState(() {
                                      pressed = false;
                                      error = 'Login Failed';
                                    });
                                  }
                                } catch (e) {
                                  print(e.toString() + "hi");

                                  setState(() {
                                    error = 'Login Failed';
                                  });
                                }
                              }
                            },
                            elevation: 0,
                            color: Colors.deepOrange,
                            child: Text(
                              'Sign In',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            error,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
