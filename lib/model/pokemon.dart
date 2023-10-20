class Pokemon {
  Pokemon({required this.name, required this.url, this.detail});

  String name;
  String url;
  Map? detail;
  Map? eggGroup;
  Map? gender;

  static Pokemon fromMap(Map data) {
    return Pokemon(name: data['name'], url: data['url']);
  }

  String get imageUrl {
    return detail!['sprites']['other']['official-artwork']['front_default'];
  }

  List<String> get types {
    return (detail!['types'] as List)
        .map((item) => item['type']['name'] as String)
        .toList();
  }

  List<String> get abilities {
    return (detail!['abilities'] as List)
        .map((e) => e['ability']['name'] as String)
        .toList();
  }

  Map<String, int> get stats {
    final result = {
      'hp': 0,
      'attack': 0,
      'defense': 0,
      'speed': 0,
      'special-attack': 0,
      'special-defense': 0,
    };

    for (var item in detail!['stats']) {
      final stat = item['stat'];
      final baseStat = item['base_stat'] as int;
      final statName = stat['name'];

      result[statName] = baseStat;
    }

    return result;
  }

  String get species {
    return detail!['species']['name'];
  }

  int get height {
    return detail!['height'];
  }

  int get weight {
    return detail!['weight'];
  }

  int get id {
    return detail!['id'];
  }

  String get genderName {
    if (gender == null) {
      return '-';
    }

    return gender!['name'];
  }

  String get eggGroupName {
    if (eggGroup == null) {
      return '-';
    }

    return eggGroup!['name'];
  }

  List<String> get eggGroupSpecies {
    if (eggGroup == null) {
      return [];
    }

    return (eggGroup!['pokemon_species'] as List)
        .map((e) => e['name'] as String)
        .toList();
  }
}
