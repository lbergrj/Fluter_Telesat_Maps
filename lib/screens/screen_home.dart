import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:maps02/models/beam.dart';
import 'package:maps02/models/beam_poligon.dart';


class ScreenHome extends StatefulWidget {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _marcadores = {};

  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  List<String> _intensMenu = ["Find Adress", "Set Position", "Show Lines", "T19V-K12","T14R-K14"];
  String _tranponder = "T19V  K-12";
  //Completers são usados para fazer requisições a APIs

  CameraPosition _cameraPosition =  CameraPosition(
    //Latitude -22.895702, Longitude -43.180260
    target:LatLng(-22.919029, -43.233406),
    zoom: 16,
  );

  String _info = "" ;
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};
  bool _showLines = false;
  int count = 0;

  _menuItemEscolhido(String itemEscolhido) {
    switch (itemEscolhido) {
      case "Find Adress":
        _searchAdress();
        break;
      case "Set Position":
        inserLatLong();
        break;
      case "Show Lines":

              print("Show Lines");
              setState(() {
                _intensMenu[2] = "Hide Lines";
                _showLines = true;
              });

        break;

      case "Hide Lines":
        setState(() {
          _intensMenu[2] = "Show Lines";
          _showLines = false;
        });

        break;

      case "T19V-K12":
        _tranponder = "T19V  K-12";

          setState(() {
            _info = "";
          });

        break;
      case "T14R-K14":
        _tranponder = "T14R  K-14";
        setState(() {
          _info= "";
        });

        break;

    }
  }

  
  _changeTansponder(){
    if(_tranponder == "T19V  K-12"){
      setState(() {
        _info = "";
        _tranponder = "T14R  K-14";
      });
    }
    else{
      setState(() {
        _info = "";
        _tranponder = "T19V  K-12";
      });
    }
  }


  inserLatLong(){
    TextEditingController controllerLat = TextEditingController();
    TextEditingController controllerLong = TextEditingController();
    TextEditingController controllerName = TextEditingController();

    controllerLat.text = "-22.89732";
    controllerLong.text = "-43.179916";
    //-22.897321, -43.179916

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Set the position"),
          content: SingleChildScrollView(
            child:  Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: controllerName,
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (text) {},
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: controllerLat,
                  decoration: InputDecoration(
                    labelText: "Insert Lat.",
                    labelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (text) {},
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: controllerLong,
                  decoration: InputDecoration(
                    labelText: "Insert Long.",
                    labelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (text) {},
                ),
              ],
            ),
          ),



          actions: <Widget>[
            RaisedButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              textColor: Colors.white,
              child: Text("Enter"),
              onPressed: () {
                String id ="place";
                widget._marcadores.remove("place");
                String name = controllerName.text;
                String lat = controllerLat.text.replaceAll(",", ".");
                String long = controllerLong.text.replaceAll(",", ".");
                if(name != "" && lat != "" && long != ""){
                  _inserirMercador(double.parse(lat), double.parse(long), name, null);
                  _movimentarCameraLatLong(double.parse(lat), double.parse(long));
                  setState(() {

                  });
                }

                Navigator.pop(context);
              },
            ),


            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _searchAdress(){
    TextEditingController controllerAdress = TextEditingController();
    TextEditingController controllerName = TextEditingController();
    TextEditingController controllerIsolation = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Set the position"),
          content: SingleChildScrollView(
            child:  Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.number,
                  controller: controllerAdress,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Adress",
                    labelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (text) {},
                ),

                TextField(
                  keyboardType: TextInputType.text,
                  controller: controllerName,
                  decoration: InputDecoration(
                    labelText: "Customer ID",
                    labelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (text) {},
                ),

                TextField(
                  keyboardType: TextInputType.number,
                  controller: controllerIsolation,
                  decoration: InputDecoration(
                    labelText: "Isolation",
                    labelStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onChanged: (text) {},
                ),

              ],
            ),
          ),

          actions: <Widget>[
            RaisedButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              textColor: Colors.white,
              child: Text("View Place"),
              onPressed: () {
               if(controllerAdress.text != ""){
                 _recuperarLocalParaEndereco(controllerAdress.text, false, "", 0);
                 Navigator.pop(context);
               }
              },
            ),

            RaisedButton(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              textColor: Colors.white,
              child: Text("Save Place"),
              onPressed: () {
                if(controllerAdress.text != "" && controllerName != ""){
                  String Sisolation  = controllerIsolation.text.replaceAll(",", ".");
                  double isolation = null;
                  if(Sisolation != ""){
                    isolation = double.parse(Sisolation);
                  }
                  _recuperarLocalParaEndereco(controllerAdress.text, true, controllerName.text, isolation);
                  Navigator.pop(context);
                }
              },
            ),

            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black)),
              child: Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );

  }

 
  _carregarMercadores() {
    Marker markerCasa = Marker(
      markerId: MarkerId("Casa"),
      position: LatLng(-22.919029, -43.233406),
      infoWindow: InfoWindow(
        title: "Casa",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
      rotation: 1,
      onTap: () {

      },
    );
    widget._marcadores.add(markerCasa);


    Marker markerShopping = Marker (
      markerId: MarkerId("Shopping"),
      position: LatLng(-22.921918, -43.234510),
      infoWindow: InfoWindow(
        title: "Shopping Tijuca",
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueOrange,
      ),
    );

    setState(() {
      widget._marcadores.add( markerShopping);
    });

  }

 
  _inserirMercador(double lat, double long,  String name, double isolation ) async{
     widget._marcadores.remove(name);
     var colorMarker;
     if (isolation == null){
       colorMarker = BitmapDescriptor.hueBlue;
     }
     else if(isolation>=30 ){
       colorMarker = BitmapDescriptor.hueGreen;
     }
     else if(isolation >= 25 ){
       colorMarker = BitmapDescriptor.hueYellow;
     }
     else if(isolation >= 18 ){
       colorMarker = BitmapDescriptor.hueOrange;
     }
     else{
       colorMarker = BitmapDescriptor.hueRed;
     }

     Marker marker1 =  await Marker(
      markerId: MarkerId(name),
      position: LatLng(lat, long),
      infoWindow: InfoWindow(
        title: name,
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        colorMarker ,
      ),
      rotation: 1,
      onTap: () {

      },
    );
    setState(() {
      widget._marcadores.add(marker1);
    });

  }

  _carregarPoligonos(){
    Polygon polygon1 = Polygon(
      polygonId: PolygonId("polygon1"),
      //Cor de preenchimento
      fillColor: Colors.transparent,
      //Cor da borda
      strokeColor: Colors.red,
      //Quanto menr o Zindex mais abaixo ele fica no layer
      zIndex: 0,

      //lista de Latitude e longitudes
      points: [
        LatLng(-22.916244, -43.229839),
        LatLng(-22.920277, -43.239856),
        LatLng(-22.925847, -43.234913),
        LatLng(-22.920377, -43.221912),
      ],
      //precisa estar habilitado para liberar função onTap
      consumeTapEvents: true,
      onTap: (){
        setState(() {
          _info = "Area 1";
        });
      },
    );


    setState(() {
      _polygons.add(polygon1);

    });

    Polygon polygon2 = Polygon(
      polygonId: PolygonId("polygon2"),
      //Cor de preenchimento
      fillColor: Colors.transparent,
      //Cor da borda
      strokeColor: Colors.green,

      //Quanto menr o Zindex mais abaixo ele fica no layer
      zIndex: 1,

      //lista de Latitude e longitudes
      points: [
        LatLng(-22.919000, -43.229839),
        LatLng(-22.921177, -43.235551),
        LatLng(-22.922549, -43.230273),
      ],
      //precisa estar habilitado para liberar função onTap
      consumeTapEvents: true,
      onTap: (){
        setState(() {
          _info = "Area 2";
        });
      },
    );

    setState(() {
      _polygons.add(polygon2);

    });

    _loadPolygons();

  }
 

  _loadPolygons(){
    _polygons.clear();
    List<BeamPolygonPoints> polygonPoints = [];
    if(_tranponder == "T19V  K-12"){
      polygonPoints = Beam.t19VK12();
    }

    if(_tranponder == "T14R  K-14"){
      polygonPoints = Beam.t14RK14();
    }

     for(int i = 0; i< polygonPoints.length; i++){
      BeamPolygonPoints points =  polygonPoints[i];

      String id = "${_tranponder}_${i}";
       Polygon polygon = Polygon(
       polygonId: PolygonId(id),
        //Cor de preenchimento
        fillColor: Colors.transparent,
        //Cor da borda
        strokeColor: _showLines
                      ? points.color
                      : Colors.transparent,
        strokeWidth: 2,
        //Quanto menr o Zindex mais abaixo ele fica no layer
        zIndex: points.gt.toInt(),

        //lista de Latitude e longitudes
        points:points.points,
        //precisa estar habilitado para liberar função onTap
        consumeTapEvents: true,
        onTap: (){
          setState(() {
            _info = " G/T  =   ${points.gt} dB";
          });
        },
      );
       setState(() {
         _polygons.add(polygon);
       });

    }





  }


  _carregarPolylines(){
    Polyline polyline1 = Polyline(
      polylineId: PolylineId("polyline1"),

      //Cor da linha
      color: Colors.red,

      startCap: Cap.roundCap,
      endCap: Cap.roundCap,

      //Altera o acabamento nos angulos
      jointType: JointType.round,

      width: 20,
      //Quanto menr o Zindex mais abaixo ele fica no layer
      zIndex: 0,

      //lista de Latitude e longitudes
      points: [
        LatLng(-22.916244, -43.229839),
        LatLng(-22.920277, -43.239856),
        LatLng(-22.925847, -43.234913),
        LatLng(-22.920377, -43.221912),
      ],
      //precisa estar habilitado para liberar função onTap
      consumeTapEvents: true,
      onTap: (){
        print("Linha 1 Clicada");
      },
    );

    setState(() {
      _polylines.add(polyline1 );

    });



  }

  //Move a cmamera para a posiçãoinformada (_camera Position)
  _movimentarCamera()async{
    GoogleMapController googleMapController = await widget._controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(_cameraPosition),
    );
  }

  //Recupera a posição do GPS de forma estática
  _recuperarLocalizacaoAtual() async{
    _info = "";
    Position position =  await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 16,
      );
      _movimentarCamera();
    });

  }

  _onMapCreated (GoogleMapController googleMapController){
    widget._controller.complete(googleMapController);
  }

  
  _adcionarListenerLocalizacao(){
    var geolocator = Geolocator();
    LocationOptions locationOptions = LocationOptions(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        timeInterval: 1000
    );
    geolocator.getPositionStream( locationOptions ).listen((Position position) {
      print("Localização: " + position.toString());
      setState(() {
        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16,
        );
        _movimentarCamera();
      });
    });

  }

 
  _recuperarLocalParaEndereco(String endereco, bool saveMark, String nome, double isolation) async{
   List<Placemark> listaEnderecos =  await Geolocator().placemarkFromAddress(endereco);
   if(listaEnderecos!= null && listaEnderecos.length> 0){
    Placemark item = listaEnderecos[0];
    Position position = item.position;
    setState(() {
      _info = "";
      if(saveMark){
        _inserirMercador(position.latitude, position.longitude,nome, isolation);
      }
      _movimentarCameraLatLong(position.latitude, position.longitude);

    });
   }
  }

  _movimentarCameraLatLong( double lat, double long )async{
    GoogleMapController googleMapController = await  widget._controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target:LatLng(lat, long),
          zoom: 16,
          tilt: 0,
          bearing:0,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _recuperarLocalizacaoAtual();
      //_adcionarListenerLocalizacao();
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadPolygons();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("GPS Tool",),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.gps_fixed),
                  iconSize: 30,
                  onPressed:  _recuperarLocalizacaoAtual,
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  iconSize: 30,
                  onPressed:  _searchAdress,
                ),

                PopupMenuButton<String>(
                  onSelected: _menuItemEscolhido,
                  itemBuilder: (context) {
                    return _intensMenu.map((String item) {
                      return PopupMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ],
        ),
      ),

      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Expanded(
              child: GoogleMap(
                onCameraMove: (position){
                  setState(() {
                    _info = "";
                  });
                },
               myLocationButtonEnabled: false,
                mapType: MapType.normal,
                onLongPress: (posicao){
                  _changeTansponder();
                },
                onTap: (posisao){
                  setState(() {
                    _info = "";
                  });
                },
                initialCameraPosition: _cameraPosition,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                markers: widget._marcadores,
                //polylines: _polylines,
                polygons: _polygons,
              ),
            ),
            Container(
              color: Colors.blue,
              padding: EdgeInsets.all(5),
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 60),
                      child: Text(_tranponder,
                        style: TextStyle(
                          // backgroundColor: Colors.blue,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 60),
                      child: Text(_info,
                        style: TextStyle(
                          // backgroundColor: Colors.blue,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
              ),
            ),
          ],
        ),
      )
    );
  }
}
