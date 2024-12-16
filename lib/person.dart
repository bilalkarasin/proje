class Person {
  String ad;
  String soyad;
  int yas;
  double boy;
  double kilo;
  String cinsiyet;

  Person({
    required this.ad,
    required this.soyad,
    required this.yas,
    required this.boy,
    required this.kilo,
    required this.cinsiyet,
  });

  // fromJson fonksiyonu
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      ad: json['ad'],
      soyad: json['soyad'],
      yas: json['yas'],
      boy: json['boy'],
      kilo: json['kilo'],
      cinsiyet: json['cinsiyet'],
    );
  }

  // toJson fonksiyonu
  Map<String, dynamic> toJson() {
    return {
      'ad': ad,
      'soyad': soyad,
      'yas': yas,
      'boy': boy,
      'kilo': kilo,
      'cinsiyet': cinsiyet,
    };
  }
}
