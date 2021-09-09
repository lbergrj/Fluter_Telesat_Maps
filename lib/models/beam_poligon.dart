import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BeamPolygonPoints{

  List<LatLng> _points;
  double _gt;
  Color color;

  List<LatLng> get points => _points;
  double get gt => _gt;

  BeamPolygonPoints(this._gt,String points, Color this.color){
    this._points = _setPointsPoligon(points);

  }

  List<LatLng> _setPointsPoligon(String entrada){
    List<LatLng> points = [];
    var array = entrada.split(' ');
    for(int i =0; i< array.length; i++){
      String itens = array[i];
      var valores =  itens.split(',');
      double lat = double.parse(valores[1]);
      double long = double.parse(valores[0]);
      LatLng point = LatLng(lat,long);
      points.add(point);
    }

    return points;

  }


}