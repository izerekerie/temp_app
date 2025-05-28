// converter_page.dart
import 'package:flutter/material.dart';
import 'package:temp_app/components/InputCard.dart';
import 'package:temp_app/utils/utils.dart';
class ConverterPage extends StatefulWidget {
  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  TextEditingController CelController = TextEditingController();
  TextEditingController fahController = TextEditingController();

  @override
  void initState() {
    super.initState();
    CelController.addListener(updateFahrenheit);
    fahController.addListener(updateCelsius);
  }

  void updateFahrenheit() {
    
    String text = CelController.text;
    if (text.isEmpty) {
      fahController.clear();
      return;
    }

    double? celsius = double.tryParse(text);
    if (celsius != null) {
      double fahrenheit = TemperatureUtils.celsiusToFahrenheit(celsius);
      fahController.text = TemperatureUtils.formatTemperature(fahrenheit);
    }
  }

  void updateCelsius() {
    
    String text = fahController.text;
    if (text.isEmpty) {
      CelController.clear();
    }

    double? fahrenheit = double.tryParse(text);
    if (fahrenheit != null) {
      double celsius = TemperatureUtils.fahrenheitToCelsius(fahrenheit);
      CelController.text = TemperatureUtils.formatTemperature(celsius);
    }
  }

  void clearFields() {
    CelController.clear();
    fahController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
        ),
        centerTitle: true,
        leading: Icon(Icons.thermostat_outlined, size: 30, color: Colors.white),
        
        backgroundColor: const Color.fromARGB(255, 241, 170, 15),
      ),
      body: Container(
        color: const Color.fromARGB(255, 228, 224, 219),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait 
                ? buildPortrait() 
                : buildLandscape();
          },
        ),
      ),
    );
  }

  Widget buildPortrait() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 20),
          inputCard('Celsius', '°C', CelController, Icons.ac_unit, Colors.blue),
          SizedBox(height: 30),
          Icon(Icons.swap_vert, size: 40, color: Colors.orange),
          SizedBox(height: 30),
          inputCard('Fahrenheit', '°F', fahController, Icons.wb_sunny, Colors.orange),
          SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: clearFields,
              child: Text('Clear All',
                style: TextStyle(fontSize: 18,color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLandscape() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: inputCard('Celsius', '°C', CelController, Icons.ac_unit, Colors.blue),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.swap_horiz, size: 40, color: const Color.fromARGB(255, 236, 95, 13)),
            ],
          ),
          SizedBox(width: 20),
          Expanded(
            child: inputCard('Fahrenheit', '°F', fahController, Icons.wb_sunny, Colors.orange),
          ),
        ],
      ),
    );
  }

 
  @override
  void dispose() {
    CelController.dispose();
    fahController.dispose();
    super.dispose();
  }
}