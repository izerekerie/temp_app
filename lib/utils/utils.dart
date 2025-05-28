// temperature_utils.dart
import 'package:flutter/services.dart';

class TemperatureUtils {
  
  // function Celsius to Fahrenheit
  static double celsiusToFahrenheit(double celsius) {
    return celsius * 9 / 5 + 32;
  }
  
  // function Fahrenheit to Celsius
  static double fahrenheitToCelsius(double fahrenheit) {
    return (fahrenheit - 32) * 5 / 9;
  }
  
  //  temperature to 2 decimal places
  static String formatTemperature(double temperature) {
    return temperature.toStringAsFixed(2);
  }
  
  // Get input formatters for number input
  static List<TextInputFormatter> getInputFormatters() {
    return [
      FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*$')),
    ];
  }
  


}