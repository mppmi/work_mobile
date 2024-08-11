// import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/config.dart';
import 'package:flutter_application_2/models/requset/customerLoginpostReq.dart';
import 'package:flutter_application_2/models/respone/customerloginpostres.dart';
import 'package:flutter_application_2/pages/regiter.dart';
import 'package:flutter_application_2/pages/showtrip.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int number = 0;
  String phoneNo = '';
  var phoneCtl = TextEditingController();
  var passwordCtl = TextEditingController();
  String Url = '';
  //innits คือ function ที่ทำวานเม่อเปิดหน้านี้
  //1. innits จะทำงาน ครั้งเดียว เมื่อเปิดหน้านี้
  //2.มันจะไม่ทำงานเมื่อเราเรียก setstate
  //3.มันไม่สามารถทำงานเป็น async function ได้
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Configuration.getConfig().then(
      (config){
        Url = config['apiEndpoint'];
      },
    )
    .catchError((err){
      log(err.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onDoubleTap: () {
                    log('image double tap');
                  },
                  child: Image.asset('assets/images/logo.png')),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'หมายเลขโทรศัพท์',
                        style: TextStyle(
                            color: Color.fromARGB(255, 48, 47, 47),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        // onChanged: (value) {
                        //   log(value);
                        //    phoneNo = value;

                        // },
                        controller: phoneCtl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1))),
                      ),
                      const Text(
                        'รหัสผ่าน',
                        style: TextStyle(
                            color: Color.fromARGB(255, 48, 47, 47),
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: passwordCtl,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1))),
                      ),
                    ],
                  )),
              Padding(
                // ignore: prefer_const_constructors
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => register(),
                        child: const Text(
                          'ลงทะเบียนใหม่',
                          style: TextStyle(fontSize: 20),
                        )),
                    FilledButton(
                        onPressed: () => login(),
                        child: const Text(
                          'เข้าสู่ระบบ',
                          style: TextStyle(fontSize: 20),
                        )),
                  ],
                ),
              ),
              Text(text)
            ],
          ),
        ));
  }

  void register() {
    // log('this is regiter');

    // setState(() {
    //    text = 'Hello World !!';
    // });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }

  void login() {
    //call login api
   var data = CustomersLoginPostRequset(phone: phoneCtl.text, password: passwordCtl.text);
    http
        .post(Uri.parse("$Url/customers/login"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body:customersLoginPostRequsetToJson(data))
        .then(
          (value) {
          var cc = customersLoginPostResponseFromJson(value.body);
            log(cc.customer.email);
            setState(() {
        text = '';
      });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context)=> ShowTripPage(idx: cc.customer.idx),
              ));

    },).catchError((error) {
      setState(() {
        text = 'Phone no or Password Incorrec';
      });
      
      log(error.toString());
    },);
    // log(phoneCtl.text);
    // //  log('this is login');
    // //  count ++;
    // //
    // //

    // if (phoneCtl.text == "0812345678" && passwordCtl.text == "1234") {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const ShowTripPage(),
    //       ));
    //   setState(() {
    //     text = ' ';
    //   });
    // } else {
    //   setState(() {
    //     text = ' password in correct';
    //   });
    // }
  }
}
