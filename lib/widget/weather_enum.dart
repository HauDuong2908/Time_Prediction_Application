enum WeatherState {
  rain('Rain'),
  partiallyCloudy('Partially cloudy'),
  overcast('Overcast');

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
    }
  }
}


// imageUrl = weatherStateName.toLowerCase();
      // switch (imageUrl) {
      //   case 'rain, overcast':
      //     imageUrl = 'heavyrain';
      //     break;
      //   case 'rain, partially cloudy':
      //     imageUrl = 'heavyrain';
      //     break;
      //   case 'overcast':
      //   case 'partially cloudy':
      //     imageUrl = 'heavycloud';
      //     break;
      //   case 'clear':
      //     imageUrl = 'clear1';
      //     break;
      // }
      // if (imageUrl.startsWith('rain')) {
      //   imageUrl = 'heavyrain';
      // } else {
      //   switch (imageUrl) {
      //     case 'overcast':
      //     case 'partiallycloudy':
      //       imageUrl = 'heavycloud';
      //       break;
      //     case 'clear':
      //       imageUrl = 'clear1';
      //       break;
      //     case 'snow':
      //       imageUrl = 'snow';
      //       break;
      //     default:
      //       break;
      //   }
      // }
