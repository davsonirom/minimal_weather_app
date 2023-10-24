import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:minimal_weather_app/model/weather_model.dart';

class WeatherService {
  //!  https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}
  //! https://api.openweathermap.org/data/2.5/weather?q=janauba&appid=key
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;
  WeatherService({
    required this.apiKey,
  });

  Future<WeatherModel> tempoParaHoje(String cidadeNome) async {
    final response =
        await http.get(Uri.parse('$BASE_URL=$cidadeNome&appid=$apiKey'));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Ops! conexão com marte perdida, API fora de alcançe');
    }
  }

  //? permisao para pegar localização do dispositivo
  Future<String> ondeEstou() async {
    LocationPermission permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    //* localização com maxima precisão
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    //* converter localização em placemark objeto
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    //* extrair o nome da cidade do placemark
    String? cidade = placemarks[0].locality;

    return cidade ?? "";
  }
}
