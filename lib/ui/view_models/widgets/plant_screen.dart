import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../../../data/model/perma.dart';
import '../area_view_model.dart';
import '../plant_view_model.dart';

class PlantScreen extends StatefulWidget{
  const PlantScreen({super.key, required this.plantId, required this.areaId});
  final int plantId;
  final int areaId; // Assuming areaId is 1 for demonstration
  @override
  State<PlantScreen> createState() => _PlantScreenState();
}

class _PlantScreenState extends State<PlantScreen> {
  Plant? plant;
  String plantTitle = 'Plant Details';
  void getPlantById(BuildContext context) async {
    try {
      final plantViewModel = PlantViewModel(plantRepository: context.read());
      final plant = await plantViewModel.getPlantById(widget.plantId);
      if (plant == null) {
        throw Exception('Plant not found');
      }
      if (mounted) {
        setState(() {
          plantTitle = '${plant.name} ${plant.icon}';
          this.plant = plant;
        });
      }
    } catch (e) {
      throw Exception('Failed to get plant by id: $e');
    }
  }
  void addPlantToArea(BuildContext context) async {
    try{
      final areaViewModel = AreaViewModel(areaRepository: context.read());
      final plants = await areaViewModel.getAreaPlantsByAreaId(widget.areaId);
      if((plants??[]).contains(plant)) return;
      if((plants??[]).length < 6) {
        await areaViewModel.addPlantToArea(widget.areaId, widget.plantId);
      }
    } catch (e) {
      throw Exception('Failed to add plant to area: $e');
    }
  }
  String getWateringEmoji(String watering){
    switch (watering) {
      case 'little':
        return '💧';
      case 'moderate':
        return '💧💧';
      default:
        return '💧';
    }
  }
  String getSunExposureEmoji(String sunExposure){
    switch (sunExposure) {
      case 'sun':
        return '☀️';
      case 'shade':
        return '⛅️';
      default:
        return '🌤️';
    }
  }
  @override
  Widget build(BuildContext context) {
    getPlantById(context);
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        //backgroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: const Color.fromARGB(255, 221, 245, 238),
        // Here we take the value from the GardenScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(plantTitle, style: TextStyle(fontWeight: FontWeight(900), color: const Color.fromARGB(255, 8, 51, 35))),
      ),
      body: Container(
          color: const Color.fromARGB(255, 221, 245, 238),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
          child: plant?.id != null ? Column(
            spacing: 10.0,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsetsGeometry.directional(start: 10.0, end: 10.0, top: 0.0, bottom: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 5.0,
                  children: [
                  ItemWidget(title: 'FAMILY', text: plant!.family),
                  ItemWidget(title: 'TYPE', text: plant!.type.name),
                ])
              ),
              Text('FEATURE', style: TextStyle(fontWeight: FontWeight(600)), textAlign: TextAlign.left,),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Color.fromARGB(255, 8, 51, 35)), borderRadius: BorderRadiusGeometry.circular(25.0)),
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text('${plant!.name} is a ${plant!.growthType} plant and could measure until ${plant!.size} cm.', style: TextStyle(color: Color.fromARGB(255, 8, 51, 35)), textAlign: TextAlign.left),
                    Text('${plant!.name} has ${plant!.rootType} root ${plant!.creeping ? ', creeping ': ''}and ${plant!.leafType} leaves.', style: TextStyle(color: Color.fromARGB(255, 8, 51, 35)), textAlign: TextAlign.left),
                    plant!.isMelliferous ? Text('${plant!.name} is a melliferous plant.', style: TextStyle(color: Color.fromARGB(255, 8, 51, 35)), textAlign: TextAlign.left) : SizedBox()
                  ])
                ),
              // ),
              Container(
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsetsGeometry.directional(start: 10.0, end: 10.0, top: 0.0, bottom: 0.0),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 5.0,
                children: [
                  ItemWidget(title: 'SOWING', text: '📅 ${plant!.sowingPeriod}'),
                  ItemWidget(title: 'WATERING', text: getWateringEmoji(plant!.watering)),
                  ItemWidget(title: 'EXPOSURE', text: getSunExposureEmoji(plant!.sunExposure)),
                ])),
              Text('DISTINCTIVE FEATURE', style: TextStyle(fontWeight: FontWeight(600)), textAlign: TextAlign.left,),
              Container( 
                decoration: BoxDecoration(border: Border.all(color: Color.fromARGB(255, 8, 51, 35)), borderRadius: BorderRadiusGeometry.circular(25.0)),
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      plant!.isAntiParasite ? Text('${plant!.name} is a good anti parasite.', style: TextStyle(color: Color.fromARGB(255, 8, 51, 35)), textAlign: TextAlign.left,) : SizedBox(),
                      plant!.isNutrientRich ? Text('${plant!.name} is consumes a lot of nutrient.', style: TextStyle(color: Color.fromARGB(255, 8, 51, 35)), textAlign: TextAlign.left): SizedBox(),
                      plant!.isParasiteAttackRisk ? Text('${plant!.name} can be attack by parasite.', style: TextStyle(color: Color.fromARGB(255, 8, 51, 35)), textAlign: TextAlign.left): SizedBox(),
                      plant!.isNitrogenInput ? Text('${plant!.name} extends nitrogen in soil.', style: TextStyle(color: Color.fromARGB(255, 8, 51, 35)), textAlign: TextAlign.left): SizedBox(),
                  ])),
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.bottomCenter,
                width: 250.0,
                child: TextButton(
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll<Color>(Color.fromARGB(255, 8, 51, 35))),
                  onPressed: () {
                    addPlantToArea(context);
                    {
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Add ${plant!.name} ${plant!.icon} to Area ${widget.areaId}', textAlign: TextAlign.center, style: TextStyle(color: const Color.fromARGB(255, 221, 245, 238),)),
                )
              )
             ]) : Text('Plant not found')
    )));
  }
}

class ItemWidget extends StatefulWidget{
  const ItemWidget({super.key, required this.title, required this.text});
  final String title;
  final String text;
  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context){
    return Container( 
          decoration: BoxDecoration(borderRadius: BorderRadiusGeometry.circular(25.0), color: Color.fromARGB(255, 8, 51, 35),),
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(widget.title, style: TextStyle(fontWeight: FontWeight(600), color: Color.fromARGB(255, 221, 245, 238)), textAlign: TextAlign.left),
              // Container(
              //   padding: EdgeInsets.all(10.0),
              //   decoration: BoxDecoration(color: Color.fromARGB(255, 8, 51, 35), borderRadius: BorderRadiusGeometry.circular(25.0)),
                // child: 
              Text(widget.text, style: TextStyle(color: Color.fromARGB(255, 221, 245, 238)), textAlign: TextAlign.left),
              // ),
            ]));
  }
}