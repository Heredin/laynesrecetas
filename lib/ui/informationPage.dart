import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyInfoPage extends StatefulWidget {
  final DocumentSnapshot ds;
  MyInfoPage({this.ds});
  @override
  _MyInfoPageState createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  String productImage;
  String id;
  String name;
  String recipe;
  TextEditingController nameInputController;
  TextEditingController recipeInputController;

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot qn = await firestore.collection("colrecipes").getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    recipeInputController =
        new TextEditingController(text: widget.ds.data["recipe"]);
    nameInputController =
        new TextEditingController(text: widget.ds.data["name"]);
    productImage = widget.ds.data["image"];
    print(productImage);
  }

  @override
  Widget build(BuildContext context) {
    getPosts();
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalles de receta '),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
              child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 300.0,
                      width: 300.0,
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blueAccent)),
                      padding: new EdgeInsets.all(5.0),
                      child: productImage == ''
                          ? Text('Editar')
                          : Image.network(productImage + '?alt=media'),
                    )
                  ],
                ),
                Divider(),
                new IniciarIcon(),
                new ListTile(
                  leading: const Icon(Icons.person, color: Colors.black),
                  title: new TextFormField(
                    controller: nameInputController,
                    validator: (value) {
                      if (value.isEmpty) return "ingresa un nombre";
                    },
                    decoration: new InputDecoration(
                        hintText: 'Nombre', labelText: "Nombre"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                new ListTile(
                  leading: const Icon(Icons.person, color: Colors.black),
                  title: new TextFormField(
                    controller: recipeInputController,
                    validator: (value) {
                      if (value.isEmpty) return "ingresa una receta";
                    },
                    decoration: new InputDecoration(
                        hintText: 'Receta', labelText: "Receta"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
              ],
            ),
          )),
        ));
  }
}
class IniciarIcon extends StatelessWidget {
  @override
Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: new EdgeInsets.all(10.0),
      child: new Row(
        children: <Widget>[
          new IconMenu(
        icon:Icons.call,
      label: "Llamar"
    ),
    new IconMenu(
        icon:Icons.message,
        label: "Mensaje"
    ),
    new IconMenu(
    icon:Icons.place,
    label: "Lugar"
    )
      ],
    ),
    );
  }
}
class IconMenu extends StatelessWidget{
  IconMenu({this.icon,this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Expanded(
      child: new Column(
    children: <Widget>[
      new Icon(
    icon,
        size: 50.0,
        color: Colors.blue,
    ),
      new Text(
        label,
        style: new TextStyle(
          fontSize:12.0,
        color: Colors.blue
      ),
      ),
        ]
    ),
    );
  }
}

