import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() async{


  Map _data = await getJson();


  List _features = _data["features"]; // features object list



  for(int i=0;i<_features.length;i++){
    print(_features[i]);


  }





  runApp(MaterialApp(
    title: "EarthQuake App",
    home: Scaffold(
      appBar: AppBar(title: Text("Quakes"), centerTitle: true, backgroundColor: Colors.red,),
      body: Center(
        child: ListView.builder(
            itemCount: _features.length,
            padding: EdgeInsets.all(16.0),

            itemBuilder: (BuildContext context, int position){
              if(position.isOdd) return Divider();
              final index = position ~/2;


              var format = new DateFormat.yMMMMd("en_US").add_jm();


              var date = format.format(new DateTime.fromMillisecondsSinceEpoch(_features[index]["properties"]["time"]*1000, isUtc: true));


              //var dateString = format.format(date);


              return ListTile(
            title: Text("At : $date ",style: TextStyle(fontSize: 12.5, color: Colors.orange, fontWeight: FontWeight.w500),),

            subtitle: Text("${_features[index]["properties"]["place"]}", style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.normal, fontStyle: FontStyle.italic, color: Colors.grey),),
            
            leading: CircleAvatar(
              backgroundColor: Colors.green,
              child: Text("${_features[index]["properties"]["mag"]}", style: TextStyle(color: Colors.white, fontSize: 16.5, fontStyle: FontStyle.normal, fontWeight: FontWeight.bold),),
            ),

                onTap: (){
              _onTapMessage(context, "${_features[index]["properties"]["title"]}");
                },
            
          );
        }),

      ),
    ),
  ));


}

void _onTapMessage(BuildContext context, String message) {
  var alert = AlertDialog(
    title: Text('Quake'),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Ok"),
      )
    ],
  );

  showDialog(context: context, child: alert);
}


Future<Map> getJson() async{
  String apiUrl = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);

}