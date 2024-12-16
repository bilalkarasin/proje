import 'package:flutter/material.dart';
import 'package:ornek_test/person.dart';
import 'package:ornek_test/personService.dart';
import 'package:ornek_test/vucutIstatistikleri.dart';
import 'package:ornek_test/yemekTarifi.dart';
import 'DatabaseHelper.dart';
import 'ayarlar.dart';
import 'kiloTakibi.dart';
import 'ilerlemeGrafigi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Databasehelper.instance.initDb();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Alt menüde seçili olan sekmeyi takip etmek için
  double _currentWaterIntake = 0; // Tüketilen su miktarı
  double _currentExerciseValue = 0; // Egzersiz değeri
  double _currentWeight = 67; // Varsayılan başlangıç kilosu
  double _targetWeight = 65; // Varsayılan hedef kilo

  @override
  void initState() {
    super.initState();
    PersonService.createPerson(Person(ad: "Bilal", soyad: "Karaşin", boy: 170, kilo: 67, yas: 23, cinsiyet: "Erkek"));
    PersonService.createPerson(Person(ad: "Ali", soyad: "Veli", boy: 180, kilo: 77, yas: 24, cinsiyet: "Erkek"));
    PersonService.createPerson(Person(ad: "Şerife", soyad: "Topçuoğlu", boy: 175, kilo: 66, yas: 21, cinsiyet: "Kadın"));
  }

  void _showUpdateWeightDialog(BuildContext context) {
    double newWeight = _currentWeight; // Varsayılan değer mevcut kilo
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Kilo Güncelle"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Yeni Kilo (kg)"),
            onChanged: (value) {
              newWeight = double.tryParse(value) ?? _currentWeight;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentWeight = newWeight; // Yeni kiloyu güncelle
                });
                PersonService.updateWeight("Bilal", newWeight); // Backend güncellemesi
                Navigator.pop(context);
              },
              child: Text("Güncelle"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("İptal"),
            ),
          ],
        );
      },
    );
  }

  void _showSetTargetWeightDialog(BuildContext context) {
    double newTargetWeight = _targetWeight; // Varsayılan hedef kilo
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hedef Kilo Belirle"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Hedef Kilo (kg)"),
            onChanged: (value) {
              newTargetWeight = double.tryParse(value) ?? _targetWeight;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _targetWeight = newTargetWeight; // Yeni hedef kiloyu güncelle
                });
                Navigator.pop(context);
              },
              child: Text("Belirle"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("İptal"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildAnasayfa(),
      KiloTakibiPage(),
      FoodRecipesPage(), // Burada değişiklik yok
      ProgressPage(),
    ];


    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu), // Menü simgesi
          onPressed: () {
            _showOptions(context); // Seçenekler için Bottom Sheet açılır
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bilal Karaşin",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "Boy = 170 cm, Kilo = $_currentWeight, Yaş = 23, Cinsiyet = Erkek",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: false, // Başlık sola hizalı
      ),
      body: _pages[_currentIndex], // Alt menüye göre değişen ekran
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Seçili olan sekmeyi gösterir
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Tıklanan sekmeye geçiş yap
          });
        },
        type: BottomNavigationBarType.fixed, // 4+ sekme için sabit tip
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Anasayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: "Kilo Takibi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Yemek Tarifleri",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "İlerleme Grafiği",
          ),
        ],
      ),
    );
  }


  // Anasayfa İçeriği
  Widget _buildAnasayfa() {
    double exerciseProgress = _currentExerciseValue / 1000; // Örneğin 1000 kcal hedefi
    double progressPercentage = (exerciseProgress * 100).clamp(0, 100); // Yüzde değeri

    // VKI hesaplama
    double heightInMeters = 1.70; // Boy 170 cm
    double bmi = _currentWeight / (heightInMeters * heightInMeters); // VKİ formülü

    // VKİ değerlendirmesi
    String bmiEvaluation;
    if (bmi < 18.5) {
      bmiEvaluation = "Zayıf";
    } else if (bmi >= 18.5 && bmi < 24.9) {
      bmiEvaluation = "Normal";
    } else {
      bmiEvaluation = "Aşırı Kilolu";
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Yakılan Kalori kısmı (halkalı gösterim ve iç metin)
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Daireyi oluşturuyoruz
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: exerciseProgress, // Yüzde hesaplaması
                    strokeWidth: 6, // Çubuğun kalınlığı
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                  ),
                ),
                // Eğer yüzde %100 ise onay simgesi göster
                if (progressPercentage == 100)
                  Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 40, // Onay simgesinin boyutu
                  )
                else
                // Halkanın içine yüzdelik değer yazıyoruz
                  Text(
                    "${progressPercentage.toStringAsFixed(0)}%", // Yüzdeyi yazıyoruz
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          // Yakılan Kalori metnini dairenin altına ekliyoruz
          SizedBox(height: 10),
          Center(
            child: Text(
              "Yakılan Kalori: $_currentExerciseValue kcal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30),

          // Tüketilen Su kısmı
          Text(
            "Tüketilen Su",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          LinearProgressIndicator(value: _currentWaterIntake / 2738),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${_currentWaterIntake.toStringAsFixed(0)}/2738 ml"),
              // Onay simgesini ekliyoruz
              if (_currentWaterIntake >= 2738)
                Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 30, // Onay simgesinin boyutu
                ),
              ElevatedButton(
                onPressed: () => _showAddWaterDialog(context),
                child: Text("Ekle"),
              ),
            ],
          ),
          SizedBox(height: 30),

          // Egzersizler kısmı
          Text(
            "Egzersizler",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showAddExerciseDialog(context),
            child: Text("Egzersiz Ekle"),
          ),

          // Çizgi ekleme
          SizedBox(height: 20),
          Divider(thickness: 3, color: Colors.blueAccent),
          SizedBox(height: 20),

          // Kilo güncelleme ve hedef kilo ayarlama butonlarını sayfayı kaplayacak şekilde yerleştiriyoruz
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showUpdateWeightDialog(context),
                  child: Text("Kilo Güncelle"),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showSetGoalWeightDialog(context),
                  child: Text("Hedef Kilo Ayarla"),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Hedef Kilo metni, burası dinamik olacak
          Text(
            "Hedef Kilo: $_goalWeight kg", // Dinamik hedef kilo
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          // Vücut Kitle İndeksi metni
          Text(
            "Vücut Kitle İndeksi: ${bmi.toStringAsFixed(1)}", // VKİ
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent, // Renk değişimi
            ),
          ),
          SizedBox(height: 10),

          // VKİ değerlendirmesi
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: bmi < 18.5
                  ? Colors.orange[200]
                  : (bmi < 24.9 ? Colors.green[200] : Colors.red[200]),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: bmi < 18.5
                    ? Colors.orange
                    : (bmi < 24.9 ? Colors.green : Colors.red),
                width: 2,
              ),
            ),
            child: Text(
              "Değerlendirme: $bmiEvaluation", // VKİ değerlendirmesi
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Metin rengi
              ),
            ),
          ),
          SizedBox(height: 30),
          Spacer(),
        ],
      ),
    );
  }

// Hedef Kilo için bir değişken ekledik
  double _goalWeight = 65; // Başlangıçta varsayılan hedef kilo

// Hedef Kilo Ayarlama için diyalog
  void _showSetGoalWeightDialog(BuildContext context) {
    double goalWeight = _goalWeight; // Başlangıçta mevcut hedef kilo

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hedef Kilo Ayarla"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Hedef Kilo (kg)"),
            onChanged: (value) {
              goalWeight = double.tryParse(value) ?? goalWeight;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _goalWeight = goalWeight; // Kullanıcının girdiği değeri kaydediyoruz
                });
                Navigator.pop(context);
              },
              child: Text("Kaydet"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("İptal"),
            ),
          ],
        );
      },
    );
  }


// Su eklemek için diyalog
  void _showAddWaterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double waterAmount = 0;
        return AlertDialog(
          title: Text("Su Ekle"),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Miktar (ml)"),
            onChanged: (value) {
              waterAmount = double.tryParse(value) ?? 0;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentWaterIntake += waterAmount;
                });
                Navigator.pop(context);
              },
              child: Text("Ekle"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("İptal"),
            ),
          ],
        );
      },
    );
  }

  // Egzersiz eklemek için diyalog
  void _showAddExerciseDialog(BuildContext context) {
    String selectedExercise = 'Basketbol';
    double selectedExerciseCalories = 300;

    Map<String, double> exerciseCaloriesMap = {
      'Basketbol': 300,
      'Yüzme': 400,
      'Koşmak': 350,
      'Futbol Oynamak': 450,
      'Ağırlık Kaldırmak': 500,
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Egzersiz Ekle"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedExercise,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedExercise = newValue!;
                        selectedExerciseCalories = exerciseCaloriesMap[selectedExercise]!;
                      });
                    },
                    items: exerciseCaloriesMap.keys.map((String exercise) {
                      return DropdownMenuItem<String>(
                        value: exercise,
                        child: Text(exercise),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Seçilen Egzersiz: $selectedExercise",
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Kalori Değeri: $selectedExerciseCalories",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentExerciseValue += selectedExerciseCalories;
                });
                Navigator.pop(context);
              },
              child: Text("Ekle"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("İptal"),
            ),
          ],
        );
      },
    );
  }
}

// Seçenekler Menüsü
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Vücut İstatistikleri"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => BodyStatsPage()));
              },
            ),/*
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Kaydedilen Yemek Listeleri"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => FoodListsPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Bildirimler"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
              },
            ),*/
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Ayarlar"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ],
        );
      },
    );
  }


// Daire İndikatör Widget
class CircularIndicator extends StatelessWidget {
  final String title;
  final String unit;
  final double value;

  CircularIndicator({required this.title, required this.unit, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(value: value, strokeWidth: 8),
            Text("${(value * 100).toInt()}%", style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 10),
        Text("$title\n$unit", textAlign: TextAlign.center),
      ],
    );
  }
}
