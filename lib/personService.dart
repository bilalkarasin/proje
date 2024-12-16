import 'package:ornek_test/DatabaseHelper.dart';
import 'package:ornek_test/person.dart';

class PersonService {
  static Future<bool> createPerson(Person model) async {
    bool isSaved = false;
    // Person nesnesini Map'e dönüştürme
    int inserted = await Databasehelper.insert("person", model.toJson());
    isSaved = inserted == 1 ? true : false;

    return isSaved;
  }

  static Future<List<Person>> getPersons() async {
    List<Map<String, dynamic>> result = await Databasehelper.query("person");
    return result.map((e) => Person.fromJson(e)).toList();
  }

  static Future<bool> updateWeight(String name, double newWeight) async {
    // Person tablosundaki kişiyi ad üzerinden bul ve kilosunu güncelle
    int updated = await Databasehelper.update(
      "person",
      {"kilo": newWeight}, // Person'dan Map'e dönüşüm
      where: "ad = ?",
      whereArgs: [name],
    );
    return updated > 0;
  }
}
