enum WeatherState {
  rain('Rain'),
  partiallyCloudy('Partially cloudy'),
  overcast('Overcast'),
  clear('Clear');

  final String code;
  const WeatherState(this.code);

  static WeatherState getEnumFromCode(String inputCode) {
    return WeatherState.values.firstWhere(
      (element) => element.code == inputCode,
    );
  }
}

extension WeatherStateaExt on WeatherState {
  String get image {
    switch (this) {
      case WeatherState.rain:
        return 'heavyrain';
      case WeatherState.partiallyCloudy:
        return 'lightcloud';
      case WeatherState.overcast:
        return 'snow';
      case WeatherState.clear:
        return 'clear1';
    }
  }
}
