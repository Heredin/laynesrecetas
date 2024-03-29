import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


File image;
String filename;



class MyUpdatePage extends StatefulWidget {
  final DocumentSnapshot ds;
  MyUpdatePage({this.ds});
  @override
  _MyUpdatePageState createState() => _MyUpdatePageState();
}

class _MyUpdatePageState extends State<MyUpdatePage> {
  String productImage;
  TextEditingController recipeInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;

  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String recipe;

  pickerCamera() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    recipeInputController=
        new TextEditingController(text: widget.ds.data["recipe"]);
    nameInputController=
        new TextEditingController(text: widget.ds.data["name"]);
    productImage= widget.ds.data["image"];
    print(productImage);
  }

  updateData(selectedDoc,newValues){
    Firestore.instance
        .collection('colrecipes')
        .document(selectedDoc)
        .updateData(newValues)
        .catchError((e){

    });
  }

  Future getPosts() async{
    var firestore =Firestore.instance;
        QuerySnapshot qn=await firestore.collection("colrecipes").getDocuments();
    return qn.documents;
  }


  @override
  Widget build(BuildContext context) {
  getPosts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar receta '),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blueAccent
                          )
                      ),
                      padding: new EdgeInsets.all(5.0),
                      child:
                      image == null ? Text('Agregar') : Image.file(image),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.2),
                      child: new Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blueAccent)
                        ),
                        padding: new EdgeInsets.all(5.0),
                        child: productImage=='' ? Text('Editar'): Image.network(productImage+'?alt=media'),
                      ),
                    ),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.camera_alt), onPressed: pickerCamera),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.image), onPressed: pickerGallery),
                  ],
                ),
                Container(
                  child: TextFormField(
                    controller: nameInputController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nombre',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingresa el nombre';
                      }
                    },
                    onSaved: (value) => name = value,
                  ),
                ),
                Container(
                  child: TextFormField(
                    controller: recipeInputController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Receta',
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Ingresa la receta';
                      }
                    },
                    onSaved: (value) => recipe = value,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                child: Text('Editar'),
                onPressed: (){
                  DateTime now =DateTime.now();
                  String nuevoformato=
                      DateFormat('kk:mm:ss:MMMMd').format(now);
                  var  fullImageName='nomfoto-$nuevoformato'+'.jpg';
                  var  fullImageName2='nomfoto-$nuevoformato'+'.jpg';

                  final StorageReference ref=
                    FirebaseStorage.instance.ref().child(fullImageName);
                  final  StorageUploadTask task =ref.putFile(image);

                  var part1 = 'https://firebasestorage.googleapis.com/v0/b/recetaapp-24be6.appspot.com/o/';

                  var fullPathImage =part1 +fullImageName2;
                  print(fullPathImage);
                  Firestore.instance
                  .collection('colrecipes')
                  .document(widget.ds.documentID)
                  .updateData({
                    'name': nameInputController.text,
                    'recipe': recipeInputController.text,
                    'image': '$fullPathImage'
                  });
                  Navigator.of(context).pop();
                }
              )
            ],
          )
        ],
      ),
    );
  }
}
