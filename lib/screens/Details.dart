import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sampleApp/screens/SharingData.dart';
import 'package:sampleApp/screens/comman.dart';
import 'dart:convert';

class Details extends StatefulWidget {
  final Data data;

  Details({this.data});

  @override
  _Details createState() => _Details();
}

class _Details extends State<Details> {
  final Data data = new Data(201234497, "");
  IconData _iconData = Icons.bookmark_border;
  final _counter = 1;
  // _Details({this.data});

  void initState() {
    if (SharingData.isTrackBookMark(widget.data.track_Id)) {
      setState(() {
        _iconData = Icons.bookmark;
      });
    }
  }

  Future<dynamic> fetchItem(id, name) async {
    var url1 =
        "https://api.musixmatch.com/ws/1.1/track.get?track_id=${id}&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7";
    var url2 =
        "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=${id}&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7";

    var result = await http.get(url1);
    var result2 = await http.get(url2);
    var resultItems = json.decode(result.body)['message']['body']['track'];
    var resultItems2 =
        json.decode(result2.body)['message']['body']['lyrics']['lyrics_body'];
    // if (resultItems != null) {
    var dt = new Data(id, name);
    // dt.name = resultItems['track_name'];
    dt.artist = resultItems['artist_name'];
    dt.album = resultItems['album_name'];
    dt.explicit = resultItems['explicit'];
    dt.rating = resultItems['track_rating'];
    dt.lyrics = resultItems2;
    return dt;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Details -${widget.data.name}-'),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    var id = widget.data.track_Id;
                    var icon_data;
                    if (SharingData.isTrackBookMark(id)) {
                      SharingData.removeTrackFromBookmark(id);
                      icon_data = Icons.bookmark_border;
                    } else {
                      SharingData.setTrackAsBookMark(id, widget.data.name);
                      icon_data = Icons.bookmark;
                    }
                    setState(() {
                      _iconData = icon_data;
                    });
                  },
                  child: Icon(
                    _iconData,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Container(
            height: 1200,
            padding: const EdgeInsets.all(35),
            child: SingleChildScrollView(
              child: FutureBuilder<dynamic>(
                  future: fetchItem(widget.data.track_Id, widget.data.name),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${snapshot.data.name}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Artist',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${snapshot.data.artist}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Album Name',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${snapshot.data.album}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Explicit',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            snapshot.data.explicit == 0 ? "False" : "True",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Rating',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${snapshot.data.rating}',
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            'Lyrics',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${snapshot.data.lyrics}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            )));
  }
}
