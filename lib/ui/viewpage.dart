import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laynes_recetas/ui/addpage.dart';
import 'package:laynes_recetas/ui/informationPage.dart';
import 'package:laynes_recetas/ui/listviewpage.dart';
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
      home: new MyHomePage(),
    );
  }
}

class CommonThings {
  static Size size;
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  navigateToInfo(DocumentSnapshot ds){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> MyInfoPage(
      ds:ds,
    )));
  }

  navigateToDetail(DocumentSnapshot ds){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyUpdatePage(
        ds:ds
    )));
  }

  //Widget para mostrar que en la base de datos no hay nada
  Widget _buildEmptyMessage(){
    return Center(
      child: Flex(direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.check,
            size: 45.0,
            color: Colors.blueGrey,
          ),
          Padding(padding: EdgeInsets.all(10.0),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetas'),
        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.place),
            tooltip: 'Lista',
            onPressed: () {
              Route route =MaterialPageRoute(builder: (context)=>MyListViewPage());
              Navigator.push(context, route);
            },

          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            tooltip: 'salir',
            onPressed: () {


            },

          ),
          IconButton(
            icon: Icon(Icons.list),
            tooltip: 'Lista',
            onPressed: () {
              Route route =MaterialPageRoute(builder: (context)=>MyListViewPage());
              Navigator.push(context, route);
            },

          ),



        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("colrecipes").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              //return Text('Cargando...');
              return Center(child: CircularProgressIndicator(),);
            }else{
              if(snapshot.data.documents.length==0){
                return _buildEmptyMessage();
              }else{

            int length = snapshot.data.documents.length;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //2 columnas
                mainAxisSpacing: 0.1, //espacio entre card
                childAspectRatio: 0.800, //espacio largo de cada card
              ),
              itemCount: length,
              padding: EdgeInsets.all(2.0),
              itemBuilder: (_, int index) {
                final DocumentSnapshot doc = snapshot.data.documents[index];
                return new Container(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            InkWell(
                              onTap: ()=> navigateToDetail(doc),
                              child: new Container(
                                child: Image.network(
                                    '${doc.data["image"]}' + '?alt=media',
                                ),
                                width: 170,
                                height: 120,
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: ListTile(
                            title: Text(
                              doc.data["name"],
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 19.0),
                            ),
                            subtitle: Text(
                              doc.data["recipe"],
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 12.0),
                            ),
                            onTap: () {},
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: new Row(
                                children: <Widget>[
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
                                              content: Text('¿Deseas eliminar la receta?'),
                                              actions: <Widget>[
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () => deleteData(doc)
                                                ),
                                                new FlatButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.blueAccent,
                                    ),
                                    onPressed: ()=> navigateToInfo(doc),
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );}
          }}),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
              color: Colors.white,
        ),
        backgroundColor: Colors.pinkAccent,
        onPressed: (){
          Route route =MaterialPageRoute(builder: (context)=>MyAddPage());
          Navigator.push(context, route);
        },
      ),


    );
  }


}
