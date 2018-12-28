import 'db_helper.dart';
import 'package:flutter/material.dart';
import 'user_bloc.dart';
import 'user.dart';
import 'dart:math' as math;

final bloc = UserBloc();

void main() {
  runApp(new MaterialApp(theme: ThemeData.dark(), home: Home()));
}

class Home extends StatefulWidget {
  @override
  createState() => HomeState();
}

class HomeState extends State<Home> {
    @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddUser()),
            );
          }),
      appBar: new AppBar(
        title: new Text('Database application'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: StreamBuilder<List<User>>(
        stream: bloc.userStream,
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                User user = snapshot.data[index];
                return new Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) => bloc.deleteUser(user.id),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 2.0,
                    child: new ListTile(
                      leading: new CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: Text(
                          "n",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 30.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      title: new Text("User: ${user.name}"),
                      subtitle: new Text("Id: ${user.id}"),
                      onTap: () => debugPrint("${user.name}"),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class AddUser extends StatefulWidget {
  createState() => AddUserState();
}

class AddUserState extends State<AddUser> {
  String name;
  String password;
  var formkey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          appBar: new AppBar(
            title: new Text('Database application'),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          body: new Form(
            key: formkey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                new Text('Name'),
                new Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                new TextFormField(
                  decoration: new InputDecoration(
                    filled: true,
                  ),
                  onSaved: (value) => name = value,
                ),
                new Padding(
                  padding: EdgeInsets.all(5.0),
                ),
                new Text('Password'),
                new TextFormField(
                  decoration: new InputDecoration(
                    filled: true,
                  ),
                  onSaved: (value) => password = value,
                ),
                new Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                RaisedButton(
                  child: Text('add user'),
                  onPressed: () async {
                    formkey.currentState.save();
                    var user = User(name: name, password: password);
                    print(user);
                    bloc.addUser(user);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
