import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'employee.dart';

class Editrecord extends StatefulWidget {
  final Employeedetails model;
  final VoidCallback reload;
  Editrecord(this.model, this.reload);
  @override
  _EditrecordState createState() => _EditrecordState();
}

class _EditrecordState extends State<Editrecord> {
  final _key = new GlobalKey<FormState>();
  String employee_name, employee_id, employee_position, employee_address;

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  save() async {
    final response =
        await http.post('http://192.168.1.10/employee/editrecord.php', body: {
      'employee_id': employee_id,
      'employee_name': employee_name,
      'employee_position': employee_position,
      'employee_address': employee_address,
      'clientid': widget.model.id,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
      });
      Fluttertoast.showToast(
          msg: 'Record successfully updated',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Colors.green,
          textColor: Colors.white);
    } else {
      setState(() {
        Navigator.pop(context);
      });
      Fluttertoast.showToast(
          msg: 'Fail to update the record',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 6,
          backgroundColor: Color(0xffb5171d),
          textColor: Colors.white);
      String message = data['message'];
      print(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "Employee Edit record",
        ),
        backgroundColor: Colors.green,
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Edit Record Form',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w900),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: TextFormField(
                    onSaved: (e) => employee_id = e,
                    decoration: InputDecoration(
                        labelText: 'Employee Id',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff083663),
                        )),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: TextFormField(
                    onSaved: (e) => employee_name = e,
                    decoration: InputDecoration(
                        labelText: 'Employee Name',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff083663),
                        )),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: TextFormField(
                    onSaved: (e) => employee_position = e,
                    decoration: InputDecoration(
                        labelText: 'Employee Position',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff083663),
                        )),
                        border: OutlineInputBorder()),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  child: TextFormField(
                    onSaved: (e) => employee_address = e,
                    decoration: InputDecoration(
                        labelText: 'Employee Address',
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Color(0xff083663),
                        )),
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 50,
                  width: 250,
                  child: RaisedButton(
                    onPressed: () {
                      check();
                    },
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Edit Record',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
