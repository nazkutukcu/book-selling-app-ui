import 'package:final_project/model/book.dart';
import 'package:final_project/pages/add_status.dart';
import 'package:final_project/pages/bookspage.dart';
import 'package:final_project/pages/profile.dart';
import 'package:final_project/pages/profile_page.dart';
import 'package:final_project/pages/status_list.dart';
import 'package:final_project/service/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.withOpacity(.75),
          title: Center(child: Text("Satışa Koyduğum Kitaplar")),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.withOpacity(.75),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddStatusPage()));
          },
          child: Icon(Icons.add),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // ignore: prefer_const_constructors
              UserAccountsDrawerHeader(
                accountName: Text("Sarah Will"),
                accountEmail: Text("sarah.abs@gmail.com"),
                // ignore: prefer_const_constructors
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      AssetImage(".dart_tool/assets/images/sarah.png"),
                ),
              ),
              ListTile(
                title: Text('Anasayfa'),
                leading: Icon(Icons.home),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Profilim'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                },
                leading: Icon(Icons.person),
              ),

              ListTile(
                title: Text('Kitaplar'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BooksHome()));
                },
                leading: Icon(Icons.book),
              ),

              Divider(),
              ListTile(
                title: Text('Çıkış yap'),
                onTap: () {
                  _authService.signOut();
                  Navigator.pop(context);
                },
                leading: Icon(Icons.remove_circle),
              ),
            ],
          ),
        ),
        body: StatusListPage());
  }
}
