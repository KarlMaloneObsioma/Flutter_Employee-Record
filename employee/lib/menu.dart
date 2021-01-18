import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'addrecord.dart';
import 'editrecord.dart';
import 'employee.dart';

class Menu extends StatefulWidget {
  final VoidCallback signOut;
  Menu(this.signOut);
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String username = "", email = "";
  getpref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      email = preferences.getString("email");
    });
  }

  var loading = false;
  final list = new List<Employeedetails>();
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get("http://192.168.1.10/employee/read.php");
    debugPrint(response.body);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new Employeedetails(
          api['id'],
          api['employee_id'],
          api['employee_name'],
          api['employee_position'],
          api['employee_address'],
          api['empid'],
        );

        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Are you sure want to delete this booking?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                        onTap: () {
                          _delete(id);
                        },
                        child: Text("Yes")),
                  ],
                )
              ],
            ),
          );
        });
  }

  _delete(String id) async {
    final response = await http.post(
        "http://192.168.1.10/employee/deleterecord.php",
        body: {"clientid": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lihatData();
    getpref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Employee Record'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("$username", style: TextStyle(fontSize: 20.0)),
              accountEmail: Text("$email", style: TextStyle(fontSize: 20.0)),
              decoration: BoxDecoration(color: Colors.green),
            ),
            Divider(),
            ListTile(
              title: Text('Sign out', style: TextStyle(fontSize: 20.0)),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                signOut();
                Fluttertoast.showToast(
                    msg: 'You Have Sucessfully Logout',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 5,
                    backgroundColor: Colors.green,
                    textColor: Colors.white);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Addrecord(_lihatData)));
        },
      ),
      body: RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Employee Name:\t' + x.employee_name,
                                  style: TextStyle(fontSize: 17.0)),
                              Text('Employee Address :\t' + x.employee_address,
                                  style: TextStyle(fontSize: 17.0)),
                              Text('Employee Position:\t' + x.employee_position,
                                  style: TextStyle(fontSize: 17.0)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    Editrecord(x, _lihatData)));
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            dialogDelete(x.id);
                          },
                          icon: Icon(Icons.delete),
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
