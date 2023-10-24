class WeatherModel {
  final String cidadeNome;
  final double temperatura;
  final String condicaoPredominante;
  WeatherModel({
    required this.cidadeNome,
    required this.temperatura,
    required this.condicaoPredominante,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cidadeNome: json['name'],
      temperatura: json['main']['temp'],
      condicaoPredominante: json['weather'][0]['main'],
    );
  }
}
