import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:http/http.dart' as http;
import 'package:sampleApp/screens/Bookmark.dart';
import 'package:sampleApp/screens/comman.dart';
import 'dart:convert';
import 'Details.dart';

class TrackList extends StatelessWidget {
  final String apiUrl =
      "https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7";

  Future<List<dynamic>> fetchList() async {
    var result = await http.get(apiUrl);
    return json.decode(result.body)['message']['body']['track_list'];
  }

  String _name(dynamic user) {
    return user['track']['track_name'];
  }

  String _artist(dynamic user) {
    return user['track']['artist_name'];
  }

  String _album(dynamic user) {
    return user['track']['album_name'];
  }

  int _trackId(dynamic user) {
    return user['track']['track_id'];
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
                title: const Text('Trending'),
              ),
              body: Container(
                  child: (Center(child: Text('No internet connection!')))),
            );
          }
          return child;
        },
        child: Scaffold(
          appBar: AppBar(
            title: (Center(child: Text('Trending'))),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 2.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return Bookmark();
                      }));
                    },
                    child: Icon(
                      Icons.list_alt,
                      size: 26.0,
                    ),
                  )),
            ],
          ),
          body: Container(
            child: FutureBuilder<List<dynamic>>(
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
                              ListTile(
                                leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        "https://e7.pngegg.com/pngimages/69/982/png-clipart-music-icon-itunes-computer-icons-logo-itunes-text-logo.png")),
                                title: Text(_name(snapshot.data[index])),
                                subtitle: Text(_album(snapshot.data[index])),
                                trailing: Text(_artist(snapshot.data[index])),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return Details(
                                      data: new Data(
                                          _trackId(snapshot.data[index]),
                                          _name(snapshot.data[index])),
                                    );
                                  }));
                                },
                              ),
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
