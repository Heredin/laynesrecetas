import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laynes_recetas/ui/addpage.dart';
import 'package:laynes_recetas/ui/informationPage.dart';
import 'package:laynes_recetas/ui/updatepage.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de recetas',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new MyListViewPage(),
    );
  }
}

class CommonThings {
  static Size size;
}

class MyListViewPage extends StatefulWidget {
  @override
  _MyListViewPageState createState() => _MyListViewPageState();
}

class _MyListViewPageState extends State<MyListViewPage> {
  TextEditingController recipeInputController;
  TextEditingController nameInputController;

  String id;
  final db = Firestore.instance;
  //final _formKey = GlobalKey<FormState>();
  String name;
  String recipe;

//metodo para borrar registro
  void deleteData(DocumentSnapshot doc) async {
    await db.collection('colrecipes').document(doc.documentID).delete();
    setState(() => id = null);
  }

  navigateToInfo(DocumentSnapshot ds) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyInfoPage(
                  ds: ds,
                )));
  }

  navigateToDetail(DocumentSnapshot ds) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyUpdatePage(ds: ds)));
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.check,
            size: 45.0,
            color: Colors.blueGrey,
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Text(
            'Parece que no tiene datos',
            style: TextStyle(color: Colors.blueGrey),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CommonThings.size = MediaQuery.of(context).size;
    //print('Width of the screen: ${CommonThings.size.width}');
    return new Scaffold(
      appBar: AppBar(
        title: Text('Lista de recetas'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("colrecipes").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            //return Text('Cargando...');
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data.documents.length == 0) {
              return _buildEmptyMessage();
            } else {
              int length = snapshot.data.documents.length;
              return ListView.builder(
                itemCount: length,
                itemBuilder: (_, int index) {
                  final DocumentSnapshot doc = snapshot.data.documents[index];
                  return new Container(
                    padding: new EdgeInsets.all(3.0),
                    child: Card(
                      child: Row(
                        children: <Widget>[
                          new Container(
                            padding: new EdgeInsets.all(5.0),
                            child: Image.network(
                              '${doc.data["image"]}' + '?alt=media',
                            ),
                            width: 100,
                            height: 100,
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                doc.data["name"],
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 21.0,
                                ),
                              ),
                              subtitle: Text(
                                doc.data["recipe"],
                                style: TextStyle(
                                    color: Colors.redAccent, fontSize: 21.0),
                              ),
                              onTap: () => navigateToDetail(doc),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Eliminar receta'),
                                      content: Text('¿Estas seguro de eliminar?'),
                                      actions: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => deleteData(doc),
                                        ),
                                        new FlatButton(
                                          child: Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                            }, //funciona
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () => navigateToInfo(doc),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          Route route = MaterialPageRoute(builder: (context) => MyAddPage());
          Navigator.push(context, route);
        },
      ),
    );
  }
}
