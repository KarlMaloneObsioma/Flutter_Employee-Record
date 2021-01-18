import 'package:flutter/material.dart';
import 'menu.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

enum LoginStatus { notSignIn, signIn }

class _MyHomePageState extends State<MyHomePage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  String username, password;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    debugPrint("Success");
    final response =
        await http.post("http://192.168.1.10/employee/login.php", body: {
      'username': username,
      'password': password,
    });

    debugPrint(response.body.toString());
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String userAPI = data['username'];
    String emailAPI = data['email'];
    String id = data['userid'];

    print(id);
    debugPrint(data.toString());
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, userAPI, emailAPI, id);
      });
      print(message);
      loginToast(message);
    } else {
      print(message);
      failedToast(message);
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: 'You Have Sucessfully Login',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  failedToast(String toast) {
    return Fluttertoast.showToast(
        msg: 'Your Account Dosent Exist',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Color(0xffb5171d),
        textColor: Colors.white);
  }

  savePref(
    int value,
    String username,
    String email,
    String id,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt('value', value);
      preferences.setString('username', username);
      preferences.setString('email', email);
      preferences.setString('id', id);
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt('value');
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString('username', null);
      preferences.setString('email', null);
      preferences.setString('id', null);
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return new Scaffold(
            resizeToAvoidBottomPadding: false,
            body: SingleChildScrollView(
              child: Center(
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                padding:
                                    EdgeInsets.fromLTRB(15.0, 150.0, 0.0, 0.0),
                                child: Material(
                                  child: Image.asset(
                                    'assets/icon.png',
                                    width: 350,
                                    height: 180,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              top: 35.0, left: 20.0, right: 20.0),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Please insert username";
                                  }
                                  return null;
                                },
                                onSaved: (e) => username = e,
                                decoration: InputDecoration(
                                    hintText: 'Username',
                                    suffixIcon: Icon(Icons.account_circle),
                                    hintStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                style: new TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black),
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Please insert password";
                                  }
                                  return null;
                                },
                                obscureText: _secureText,
                                onSaved: (e) => password = e,
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    suffixIcon: IconButton(
                                      onPressed: showHide,
                                      icon: Icon(_secureText
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                    hintStyle: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.normal,
                                    )),
                              ),
                              SizedBox(height: 40.0),
                              Container(
                                width: 300,
                                height: 50.0,
                                child: Material(
                                  color: Color(0xff083663),
                                  elevation: 7.0,
                                  child: MaterialButton(
                                    onPressed: () {
                                      check();
                                    },
                                    child: Center(
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ));
        break;
      case LoginStatus.signIn:
        return Menu(signOut);
        break;
    }
  }
}
