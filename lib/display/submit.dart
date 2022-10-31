import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:model_performance_app/display/thanks_page.dart';
import 'package:model_performance_app/model/mobile.dart';

class Submit extends StatefulWidget {
  const Submit({super.key});

  @override
  State<Submit> createState() => _SubmitState();
}

class _SubmitState extends State<Submit> {
  final formkey = GlobalKey<FormState>();
  Mobile myMobile = Mobile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _mobileCollection =
      FirebaseFirestore.instance.collection("score");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.red],
              )),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          'About your device?',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Brand',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        validator: RequiredValidator(
                            errorText: "Please type your device brand."),
                        onSaved: (brand) {
                          myMobile.brand = brand;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Model',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        validator: RequiredValidator(
                            errorText: "Please type your device model."),
                        onSaved: (model) {
                          myMobile.model = model;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Ram',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        validator: RequiredValidator(
                            errorText: "Please type your device ram."),
                        keyboardType: TextInputType.number,
                        onSaved: (ram) {
                          myMobile.ram = ram;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Rom',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        validator: RequiredValidator(
                            errorText: "Please type your device rom."),
                        keyboardType: TextInputType.number,
                        onSaved: (rom) {
                          myMobile.rom = rom;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {
                                formkey.currentState!.save();
                                await _mobileCollection.add({
                                  'Device' : {
                                    "Brand": myMobile.brand,
                                    "Model": myMobile.model,
                                    "Ram": myMobile.ram,
                                    "Rom": myMobile.rom,
                                  }
                                });
                                formkey.currentState!.reset();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                                  return ThanksPage();
                                }));
                              }
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 18),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }),
    );
  }
}
