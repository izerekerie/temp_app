 import 'package:flutter/material.dart';
import 'package:temp_app/utils/utils.dart';

Widget inputCard(String title, String unit, TextEditingController controller, IconData icon, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                                SizedBox(width: 10),

Text(unit, style: TextStyle(fontSize: 18, color: color)),
              ],
            ),
            SizedBox(height: 15),
            TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: TemperatureUtils.getInputFormatters(),
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: '0.00',
                suffixText: unit,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ],
        ),
      ),
    );
  }
