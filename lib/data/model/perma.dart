class Advisor {
  Advisor({this.id, required this.advice, required this.plantId});
  int? id;
  final String advice;
  final String plantId;
  // Convert a Advice into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {'id': id, 'advice': advice, 'plant_id': plantId};
  }

  Advisor.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        advice = json['advice'],
        plantId = json['plant_id'];

  Map<String, dynamic> toJson() {
    return {'id': id, 'advice': advice, 'plant_id': plantId};
  }

  // Implement toString to make it easier to see information about
  // each advice when using the print statement.
  @override
  String toString() {
    return 'Advice{id: $id, advice: $advice, plantId: $plantId}';
  }
}

enum PlantType {
  vegetable,
  fruit,
  flower,
  aromatic
}
class Plant {
  Plant({this.id, required this.name, required this.icon, required this.family, required this.type, required this.size, required this.growthType, required this.rootType, required this.leafType, required this.sunExposure, required this.watering, required this.sowingPeriod, required this.creeping, required this.isMelliferous, required this.isParasiteAttackRisk, required this.isNitrogenInput, required this.isAntiParasite, required this.isNutrientRich, required this.advices});
  final int? id;
  final String name;
  final String icon;
  final String family;
  final PlantType type;
  final int size;
  final String growthType;
  final String rootType;
  final String leafType;
  final String sunExposure;
  final String watering;
  final String sowingPeriod;
  final bool creeping;
  final bool isMelliferous;
  final bool isParasiteAttackRisk;
  final bool isNitrogenInput;
  final bool isAntiParasite;
  final bool isNutrientRich;
  final List<Advisor> advices;
  // Convert a Plant into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'icon': icon, 'family': family, 'type': type, 'size': size, 'growth_type': growthType, 'root_type': rootType, 
    'leaf_type': leafType, 'sun_exposure': sunExposure, 'watering': watering, 'sowing_period': sowingPeriod, 'creeping': creeping, 'melliferous': isMelliferous, 
    'parasite_attack': isParasiteAttackRisk, 'nitrogen': isNitrogenInput, 'anti_parasite': isAntiParasite, 'nutrient_rich': isNutrientRich, 'advices': advices};
  }

  Plant.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        icon = json['icon'],
        family = json['family'],
        type = PlantType.values.firstWhere((v) => v.toString() == json['type']),
        size = json['size'],
        growthType = json['growth_type'],
        rootType = json['root_type'],
        leafType = json['leaf_type'],
        sunExposure = json['sun_exposure'],
        watering = json['watering'],
        sowingPeriod = json['sowing_period'],
        creeping = json['creeping'] == 1,
        isMelliferous = json['melliferous'] == 1,
        isParasiteAttackRisk = json['parasite_attack'] == 1,
        isNitrogenInput = json['nitrogen'] == 1,
        isAntiParasite = json['anti_parasite'] == 1,
        isNutrientRich = json['nutrient_rich'] == 1,
        advices = [];
        // advices = (json['advices'] as List<dynamic>?)
        //     ?.map((e) => Advisor(
        //           id: e['id'],
        //           advice: e['advice'],
        //           plantId: e['plant_id'],
        //         ))
            // .toList() ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'family': family,
      'type': type.toString(),
      'size': size,
      'growth_type': growthType,
      'root_type': rootType,
      'leaf_type': leafType,
      'sun_exposure': sunExposure,
      'watering': watering,
      'sowing_period': sowingPeriod,
      'creeping': creeping ? 1 : 0,
      'melliferous': isMelliferous ? 1 : 0,
      'parasite_attack': isParasiteAttackRisk ? 1 : 0,
      'nitrogen': isNitrogenInput ? 1 : 0,
      'anti_parasite': isAntiParasite ? 1 : 0,
      'nutrient_rich': isNutrientRich ? 1 : 0,
      //'advices': advices.map((e) => e.toMap()).toList(),
    };
  }

  // Implement toString to make it easier to see information about
  // each plant when using the print statement.
  @override
  String toString() {
    return 'Plant{id: $id, name: $name, icon: $icon, family: $family, type: $type, size: $size, growthType: $growthType, rootType: $rootType, leafType: $leafType, sunExposure: $sunExposure, watering: $watering, sowingPeriod: $sowingPeriod, creeping: $creeping, isMelliferous: $isMelliferous, isParasiteAttackRisk: $isParasiteAttackRisk, isNitrogenInput: $isNitrogenInput, isAntiParasite: $isAntiParasite, isNutrientrich: $isNutrientRich, advices: $advices}';
  }
}

class Area {
  Area({this.id, required this.plants, required this.gardenId});
  int? id;
  List<Plant>? plants;
  final int gardenId;
  // Convert a Area into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {'id': id, 'garden_id': gardenId};
  }

  Area.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        plants = (json['plants'] as List<dynamic>?)
            ?.map((e) => Plant.fromJson(e as Map<String, dynamic>))
            .toList(),
        gardenId = json['garden_id'];
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plants': plants?.map((e) => e.toJson()).toList(),
      'garden_id': gardenId,
    };
  }
  // Implement toString to make it easier to see information about
  // each area when using the print statement.
  @override
  String toString() {
    return 'Area{id: $id, plants: $plants, gardenId: $gardenId}';
  }
}
class Garden {
  Garden({required this.id, this.areas});
  int? id;
  List<Area>? areas;
  // Convert a Garden into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {'id': id};
  }

  Garden.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        areas = (json['areas'] as List<dynamic>?)
            ?.map((e) => Area.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'areas': areas?.map((e) => e.toJson()).toList(),
    };
  }
  // Implement toString to make it easier to see information about
  // each garden when using the print statement.
  @override
  String toString() {
    return 'Garden{id: $id, areas: $areas}';
  }
}