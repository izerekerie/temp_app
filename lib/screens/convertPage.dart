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
  
  // Flags to track which field is being updated
  bool _isUpdatingCelsius = false;
  bool _isUpdatingFahrenheit = false;

  @override
  void initState() {
    super.initState();
    // Add listeners for real-time conversion
    CelController.addListener(updateFahrenheit);
    fahController.addListener(updateCelsius);
  }

  void updateFahrenheit() {
    // If we're already updating Fahrenheit, don't do it again
    if (_isUpdatingFahrenheit) return;
    
    String text = CelController.text;
    if (text.isEmpty) {
      _isUpdatingCelsius = true;  // Set flag before changing
      fahController.clear();
      _isUpdatingCelsius = false; // Clear flag after changing
      return;
    }
    
    double? celsius = double.tryParse(text);
    if (celsius != null) {
      _isUpdatingCelsius = true;  // Set flag before changing
      double fahrenheit = TemperatureUtils.celsiusToFahrenheit(celsius);
      fahController.text = fahrenheit.toStringAsFixed(2);
      _isUpdatingCelsius = false; // Clear flag after changing
    }
  }

  void updateCelsius() {
    // If we're already updating Celsius, don't do it again
    if (_isUpdatingCelsius) return;
    
    String text = fahController.text;
    if (text.isEmpty) {
      _isUpdatingFahrenheit = true;  // Set flag before changing
      CelController.clear();
      _isUpdatingFahrenheit = false; // Clear flag after changing
      return;
    }
    
    double? fahrenheit = double.tryParse(text);
    if (fahrenheit != null) {
      _isUpdatingFahrenheit = true;  // Set flag before changing
      double celsius = TemperatureUtils.fahrenheitToCelsius(fahrenheit);
      CelController.text = celsius.toStringAsFixed(2);
      _isUpdatingFahrenheit = false; // Clear flag after changing
    }
  }

  void clearFields() {
    // Set both flags to prevent any updates during clearing
    _isUpdatingCelsius = true;
    _isUpdatingFahrenheit = true;
    
    CelController.clear();
    fahController.clear();
    
    // Clear flags after clearing
    _isUpdatingCelsius = false;
    _isUpdatingFahrenheit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
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
                style: TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.bold),
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
    // Remove listeners before disposing
    CelController.removeListener(updateFahrenheit);
    fahController.removeListener(updateCelsius);
    
    CelController.dispose();
    fahController.dispose();
    super.dispose();
  }
}