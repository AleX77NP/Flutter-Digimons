class Digimon {
  String name;
  String img;
  String level;

  Digimon({this.name, this.img, this.level});

  factory Digimon.fromJson(Map<String, dynamic> json) {
    return Digimon(
      name: json['name'],
      img: json['img'],
      level: json['level'],
    );
  }


}

