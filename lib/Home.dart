import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _posicaoCamera = CameraPosition(
      target: LatLng(-19.4712974, -45.602116),
      zoom: 16
  );
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  Set<Polyline> _polylines = {};

  _onMapCreated(GoogleMapController googleMapController){
    _controller.complete(googleMapController);
  }

  _movimentarCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
          _posicaoCamera
      )
    );
  }

  _carregarMarcadores(){

    /*
    Set<Marker> markersLocal = {};

    Marker markerShopping = Marker(
      markerId: MarkerId("marker-shopping"),
      position: LatLng(-19.938430, -43.974915),
      infoWindow: InfoWindow(
        title: "Bem Viver Supermercado e Padaria"
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueMagenta
      ),
      onTap: (){
        print("Shopping clicado");
      }
      //rotation: 45
    );

    Marker markerRestaurante = Marker(
        markerId: MarkerId("marker-restaurante"),
        position: LatLng(-19.936083, -43.977297),
        infoWindow: InfoWindow(
          title: "Bar e Restaurante do Batista"
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue
        ),
        onTap: (){
            print("Restaurante clicado");
        }
    );
    
    markersLocal.add(markerShopping);
    markersLocal.add(markerRestaurante);

    setState(() {
      _markers = markersLocal;
    });
    */

    /*
    Set<Polygon> listPolygons = {};
    Polygon polygon1 = Polygon(
      polygonId: PolygonId("polygon1"),
      fillColor: Colors.green,
      strokeColor: Colors.red,
      strokeWidth: 10,
      points: [
        LatLng(-19.936282, -43.976962),
        LatLng(-19.936480, -43.975079),
        LatLng(-19.935246, -43.974935),
        LatLng(-19.934999, -43.977310),
      ],
      consumeTapEvents: true,
      onTap: (){
          print("Clicado na área");
      },
      zIndex: 0
    );

    Polygon polygon2 = Polygon(
        polygonId: PolygonId("polygon1"),
        fillColor: Colors.purple,
        strokeColor: Colors.orange,
        strokeWidth: 10,
        points: [
          LatLng(-19.935727, -43.976339),
          LatLng(-19.936412, -43.976030),
          LatLng(-19.935881, -43.977113),
        ],
        consumeTapEvents: true,
        onTap: (){
          print("Clicado na área");
        },
        zIndex: 1
    );

    listPolygons.add(polygon1);
    listPolygons.add(polygon2);

    setState(() {
      _polygons = listPolygons;
    });
    */

    Set<Polyline> listPolylines = {};
    Polyline polyline = Polyline(
      polylineId: PolylineId("polyline"),
      color: Colors.red,
      width: 20,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.bevel,
      points: [
        LatLng(-19.934271, -43.977481),
        LatLng(-19.937711, -43.977650),
        LatLng(-19.937651, -43.974818),
      ],
      consumeTapEvents: true,
      onTap: (){
        print("Clicado na área");
      }
    );

    listPolylines.add(polyline);
    setState(() {
      _polylines = listPolylines;
    });
  }

  _recuperarLocalizacaoAtual() async {
    Position position = await Geolocator().getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    setState(() {
      _posicaoCamera = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17
      );
      _movimentarCamera();
    });

    //print("localizacao atual: " + position.toString());
  }

  _adicionarListenerLocalizacao(){
    var geolocator = Geolocator();
    var locationOptions = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10
    );
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      print("localizacao atual: " + position.toString());

      Marker markerUsuario = Marker(
          markerId: MarkerId("marker-usuario"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
              title: "Meu local"
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueMagenta
          ),
          onTap: (){
            print("Meu local clicado");
          }
        //rotation: 45
      );

      setState(() {
        _markers.add(markerUsuario);
        _posicaoCamera = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 17
        );
        _movimentarCamera();
      });
    });
  }

  _recuperarLocalParaEndereco() async {
    List<Placemark> listaEnderecos = await Geolocator().placemarkFromAddress("Av. Paulista, 1372");

    print("total: " + listaEnderecos.length.toString());

    if(listaEnderecos != null && listaEnderecos.length > 0){
      Placemark endereco = listaEnderecos[0];

      String resultado;

      resultado = "\n administrativeArea " + endereco.administrativeArea;
      resultado += "\n subAdministrativeArea " + endereco.subAdministrativeArea;
      resultado += "\n locality " + endereco.locality;
      resultado += "\n subLocality " + endereco.subLocality;
      resultado += "\n thoroughfare " + endereco.thoroughfare;
      resultado += "\n subThoroughfare " + endereco.subThoroughfare;
      resultado += "\n postalCode " + endereco.postalCode;
      resultado += "\n country " + endereco.country;
      resultado += "\n isoCountryCode " + endereco.isoCountryCode;
      resultado += "\n position " + endereco.position.toString();

      print("resultado: " + resultado);
    }
  }

  _recuperarEnderecoParaLatLong() async {
    List<Placemark> listaEnderecos = await Geolocator().placemarkFromCoordinates(-23.562712299999998, -46.6547268);

    print("total: " + listaEnderecos.length.toString());

    if(listaEnderecos != null && listaEnderecos.length > 0){
      Placemark endereco = listaEnderecos[0];

      String resultado;

      resultado = "\n administrativeArea " + endereco.administrativeArea;
      resultado += "\n subAdministrativeArea " + endereco.subAdministrativeArea;
      resultado += "\n locality " + endereco.locality;
      resultado += "\n subLocality " + endereco.subLocality;
      resultado += "\n thoroughfare " + endereco.thoroughfare;
      resultado += "\n subThoroughfare " + endereco.subThoroughfare;
      resultado += "\n postalCode " + endereco.postalCode;
      resultado += "\n country " + endereco.country;
      resultado += "\n isoCountryCode " + endereco.isoCountryCode;
      resultado += "\n position " + endereco.position.toString();

      print("resultado: " + resultado);
    }
  }

  @override
  void initState() {
    super.initState();
    //_carregarMarcadores();
    //_recuperarLocalizacaoAtual();
    //_adicionarListenerLocalizacao();
    //_recuperarLocalParaEndereco();
    _recuperarEnderecoParaLatLong();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mapas e geolocalização"),),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          onPressed: _movimentarCamera
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
            initialCameraPosition: _posicaoCamera,
          onMapCreated: _onMapCreated,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          //markers: _markers,
          //polygons: _polygons,
          //polylines: _polylines,
        ),
      ),
    );
  }
}
