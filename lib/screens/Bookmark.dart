import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:sampleApp/screens/SharingData.dart';

class Bookmark extends StatelessWidget {
  Future<List<String>> fetchList() async {
    List<String> listitems = SharingData.getListOfItems();
    return listitems;
  }

  String _name(dynamic user) {
    return user['track']['track_name'];
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
        debounceDuration: Duration.zero,
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          if (connectivity == ConnectivityResult.none) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Home'),
              ),
              body: Container(
                  child: (Center(child: Text('No internet connection!')))),
            );
          }
          return child;
        },
        child: Scaffold(
          appBar: AppBar(
            title: (Center(child: Text('Bookmarks'))),
          ),
          body: Container(
            child: FutureBuilder<List<String>>(
              future: fetchList(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Column(
                            children: <Widget>[
                              ListTile(title: Text(snapshot.data[index])),
                            ],
                          ),
                        );
                      });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ));
  }
}
