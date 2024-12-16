import 'package:flutter/material.dart';

// Kilo Takibi Sayfası

class KiloTakibiPage extends StatefulWidget {
  @override
  _KiloTakibiPageState createState() => _KiloTakibiPageState();
}

class _KiloTakibiPageState extends State<KiloTakibiPage> {
  double _currentWeight = 67; // Başlangıç kilosu
  double _targetWeight = 65; // Hedef kilo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          'Kilo Takibi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlıklar aynı satırda ve her biri ekranın genişliğini kaplar
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Başlangıç',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Güncel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Hedef',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Başlıklar arasına boşluk ekledik
            Row(
              children: [
                // Başlangıç Kilosu
                Expanded(
                  child: Text(
                    '$_currentWeight kg', // Başlangıç kilosu
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Güncel Kilo
                Expanded(
                  child: Text(
                    '$_currentWeight kg', // Güncel kilo
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
                // Hedef Kilo
                Expanded(
                  child: Text(
                    '$_targetWeight kg', // Hedef kilo
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}