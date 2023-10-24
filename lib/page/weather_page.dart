import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minimal_weather_app/model/weather_model.dart';
import 'package:minimal_weather_app/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //? api key 5a968cdd17c2357b9b376c5ad4baed0a

  final _weatherService =
      WeatherService(apiKey: '5a968cdd17c2357b9b376c5ad4baed0a');
  WeatherModel? _weather;

  //? pegar previsao do temo
  _verificarTempo() async {
    String cidadeNome = await _weatherService.ondeEstou();

    try {
      final weather = await _weatherService.tempoParaHoje(cidadeNome);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //? animação
  String animacaoDoTempo(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarTempo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //!* cidade
            Text(
              _weather?.cidadeNome ?? "carregando ....",
              style: TextStyle(
                fontSize: 32,
                color: Colors.grey[400],
                fontWeight: FontWeight.w700,
              ),
            ),

            //* animação
            Lottie.asset(animacaoDoTempo(_weather?.condicaoPredominante)),

            //* temperatura
            Text(
              '${_weather?.temperatura.round()}˚C',
              style: TextStyle(
                fontSize: 40,
                color: Colors.grey[300],
                fontWeight: FontWeight.w700,
              ),
            ),

            //* condição do tempo
            Text(
              _weather?.condicaoPredominante ?? "...",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
