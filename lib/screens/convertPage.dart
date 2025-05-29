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

  bool _isUpdatingCelsius = false;
  bool _isUpdatingFahrenheit = false;

  List<String> _conversionHistory = [];
  
  // Track which field was last modified
  String _lastModifiedField = '';

  @override
  void initState() {
    super.initState();
    // Add listeners to track which field was last modified  
    CelController.addListener(() {
      if (!_isUpdatingCelsius) {
        _lastModifiedField = 'celsius';
      }
    });
    fahController.addListener(() {
      if (!_isUpdatingFahrenheit) {
        _lastModifiedField = 'fahrenheit';
      }
    });
  }

  void performConversion() {
    String celsiusText = CelController.text;
    String fahrenheitText = fahController.text;
    
    // Determine which field has input and convert accordingly
    if (celsiusText.isNotEmpty && fahrenheitText.isEmpty) {
      // Convert Celsius to Fahrenheit
      final celsius = double.tryParse(celsiusText);
      if (celsius != null) {
        _isUpdatingFahrenheit = true;
        final fahrenheit = TemperatureUtils.celsiusToFahrenheit(celsius);
        fahController.text = fahrenheit.toStringAsFixed(2);
        _conversionHistory.add('C to F: $celsius°C => ${fahrenheit.toStringAsFixed(2)}°F');
        _isUpdatingFahrenheit = false;
      }
    } else if (fahrenheitText.isNotEmpty && celsiusText.isEmpty) {
      // Convert Fahrenheit to Celsius
      final fahrenheit = double.tryParse(fahrenheitText);
      if (fahrenheit != null) {
        _isUpdatingCelsius = true;
        final celsius = TemperatureUtils.fahrenheitToCelsius(fahrenheit);
        CelController.text = celsius.toStringAsFixed(2);
        _conversionHistory.add('F to C: $fahrenheit°F => ${celsius.toStringAsFixed(2)}°C');
        _isUpdatingCelsius = false;
      }
    } else if (celsiusText.isNotEmpty && fahrenheitText.isNotEmpty) {
      // Both fields have values, use the last modified field as source
      if (_lastModifiedField == 'celsius') {
        final celsius = double.tryParse(celsiusText);
        if (celsius != null) {
          _isUpdatingFahrenheit = true;
          final fahrenheit = TemperatureUtils.celsiusToFahrenheit(celsius);
          fahController.text = fahrenheit.toStringAsFixed(2);
          _conversionHistory.add('C to F: $celsius°C => ${fahrenheit.toStringAsFixed(2)}°F');
          _isUpdatingFahrenheit = false;
        }
      } else if (_lastModifiedField == 'fahrenheit') {
        final fahrenheit = double.tryParse(fahrenheitText);
        if (fahrenheit != null) {
          _isUpdatingCelsius = true;
          final celsius = TemperatureUtils.fahrenheitToCelsius(fahrenheit);
          CelController.text = celsius.toStringAsFixed(2);
          _conversionHistory.add('F to C: $fahrenheit°F => ${celsius.toStringAsFixed(2)}°C');
          _isUpdatingCelsius = false;
        }
      }
    }
    
    setState(() {});
  }

  void clearFields() {
    _isUpdatingCelsius = true;
    _isUpdatingFahrenheit = true;

    CelController.clear();
    fahController.clear();
    _conversionHistory.clear();

    _isUpdatingCelsius = false;
    _isUpdatingFahrenheit = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        leading: Icon(Icons.thermostat_outlined, size: 30, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 241, 170, 15),
      ),
      body: Container(
        color: const Color.fromARGB(255, 228, 224, 219),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return orientation == Orientation.portrait ? buildPortrait() : buildLandscape();
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
          // Clickable Convert Icon
          GestureDetector(
            onTap: performConversion,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.swap_vert, size: 40, color: Colors.white),
            ),
          ),
          SizedBox(height: 30),
          inputCard('Fahrenheit', '°F', fahController, Icons.wb_sunny, Colors.orange),
          SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: clearFields,
              child: Text('Clear All',
                  style: TextStyle(fontSize: 18, color: Colors.redAccent, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Fixed: Added proper constraints for history section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Conversion History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _conversionHistory.isEmpty
                        ? Center(
                            child: Text(
                              'No conversions yet',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _conversionHistory.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                dense: true,
                                leading: Icon(Icons.history, size: 20),
                                title: Text(
                                  _conversionHistory[index],
                                  style: TextStyle(fontSize: 14),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
Widget buildLandscape() {
  return SingleChildScrollView(
    padding: EdgeInsets.all(20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Inputs and Actions
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              inputCard('Celsius', '°C', CelController, Icons.ac_unit, Colors.blue),
              SizedBox(height: 10),
              GestureDetector(
                onTap: performConversion,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.swap_vert, size: 30, color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              inputCard('Fahrenheit', '°F', fahController, Icons.wb_sunny, Colors.orange),
              SizedBox(height: 10),
           
            ],
          ),
        ),
        SizedBox(width: 10),

        // Right side - History
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  'History',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 200, // limit height to avoid overflow
                  child: _conversionHistory.isEmpty
                      ? Center(
                          child: Text(
                            'No conversions yet',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _conversionHistory.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              dense: true,
                              leading: Icon(Icons.history, size: 16),
                              title: Text(
                                _conversionHistory[index],
                                style: TextStyle(fontSize: 12),
                              ),
                            );
                          },
                        ),
                ),
                   SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: clearFields,
                  child: Text(
                    'Clear All',
                    style: TextStyle(fontSize: 16, color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              ],
            ),
          ),
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