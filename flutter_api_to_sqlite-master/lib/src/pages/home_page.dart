import 'dart:ui';

import 'package:api_to_sqlite_flutter/src/providers/db_provider.dart';
import 'package:api_to_sqlite_flutter/src/providers/employee_api_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Family Moovies',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blue),
        ),
        shadowColor: Colors.red,
        backgroundColor: Colors.blueGrey[200],
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.movie_creation),
              color: Colors.red,
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.movie_outlined),
              color: Colors.blue,
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
          FittedBox(
            child: Image.network(
                'https://media.giphy.com/media/VJNNCEVLCMJYQlErmY/giphy.gif'),
            fit: BoxFit.fill,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: new Column(
                children: [
                  new Image.network(
                      'https://media.giphy.com/media/3o6Ztl7RvfwCp9mqhW/giphy.gif',
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      height: 740),
                ],
              ),
            )
          : _buildEmployeeListView(),
    );
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 6));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 5));

    setState(() {
      isLoading = false;
    });

    print('Todas las peliculas eliminadas');
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: LinearProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Colors.red,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                tileColor: Colors.yellow[100],
                leading: Text("🁢${snapshot.data[index].genero}🁢",
                    style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.normal,
                        color: Colors.blue[500])),
                title: Text(
                    "▷${snapshot.data[index].pelicula} De ${snapshot.data[index].director}",
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.blue[500])),
                subtitle: Text(
                    'Duracion ${snapshot.data[index].duracion} minutos, Con Una Recaudación De ${snapshot.data[index].ganancias}M⛂⛁',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.redAccent)),
              );
            },
          );
        }
      },
    );
  }
}
