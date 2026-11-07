import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../../data/model/perma.dart';
import '../../../data/plants.dart' as plants_data;

class AreaScreen extends StatefulWidget{
  const AreaScreen({super.key, required this.areaIndex, required this.areaId});
  final int areaIndex;
  final int areaId;
  @override
  State<AreaScreen> createState() => _AreaScreenState();
}

class _AreaScreenState extends State<AreaScreen> {
  List<Plant?> plants = [];
  List<Plant?> selectedPlants = [];
  Criteria criteriaView = .all;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        //backgroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: const Color.fromARGB(255, 221, 245, 238),
        // Here we take the value from the GardenScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Area ${widget.areaIndex}', style: TextStyle(fontWeight: FontWeight(900), color: const Color.fromARGB(255, 8, 51, 35))),
      ),
      body: Container(
        color:  Color.fromARGB(255, 221, 245, 238),
        alignment: Alignment.center,
        child: CustomScrollView(
        slivers: <Widget>[
          SliverList.builder(
            itemCount: 1,
            itemBuilder:
            (BuildContext context, int index) {
              return Column(children: [
                  Container(height: 450, padding: EdgeInsets.all(20.0), margin: EdgeInsets.all(20), alignment: Alignment.center, color: Colors.brown, child: AreaPlantsWidget(plants: selectedPlants, areaId: widget.areaId)),
                  Text('SELECT PLANTS', style: TextStyle(fontWeight: FontWeight(600), color: Color.fromARGB(255, 10, 46, 36)), textAlign: TextAlign.center,),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: SegmentedButton<Criteria>(
                    segments: const <ButtonSegment<Criteria>>[
                      ButtonSegment<Criteria>(
                        value: Criteria.all,
                        label: Text('All'),
                      ),
                      ButtonSegment<Criteria>(
                        value: Criteria.aromatic,
                        //label: Text('aromatic'),
                        icon: FaIcon(
                          FontAwesomeIcons.leaf,
                          color: Color.fromARGB(255, 8, 51, 35),
                          semanticLabel: 'Aromatic',
                        )
                      ),
                      ButtonSegment<Criteria>(
                        value: Criteria.flower,
                        //label: Text('flower'),
                        icon: Icon(
                          Icons.local_florist,
                          color: Color.fromARGB(255, 8, 51, 35),
                          semanticLabel: 'Flower',
                        )
                      ),
                      ButtonSegment<Criteria>(
                        value: Criteria.fruit,
                        //label: Text('fruit'),
                        icon: FaIcon(
                          FontAwesomeIcons.appleWhole,
                          color: Color.fromARGB(255, 8, 51, 35),
                          semanticLabel: 'Fruit',
                        )
                      ),
                      ButtonSegment<Criteria>(
                        value: Criteria.vegetable,
                        //label: Text('vegetable'),
                        icon: FaIcon(
                          FontAwesomeIcons.carrot,
                          color: Color.fromARGB(255, 8, 51, 35),
                          semanticLabel: 'Vegetable',
                        )
                      ),
                    ],
                    selected: <Criteria>{criteriaView},
                    onSelectionChanged: (Set<Criteria> newSelection) {
                      setState(() {
                        // By default there is only a single segment that can be
                        // selected at one time, so its value is always the first
                        // item in the selected set.
                        criteriaView = newSelection.first;
                      });
                    },
                  ))
              ]);
            },
            ),
              // Expanded(
              //   child: Container(
              //     margin: EdgeInsets.all(20.0),
              //     color: Color.fromARGB(255, 238, 217, 153),
            PlantGalleryWidget(plants: plants, areaId: widget.areaId)
              // ),
                  
            ]),
    ));
  }
}
enum Criteria {all, aromatic, vegetable, fruit, flower}

class PlantWidget extends StatefulWidget {
  const PlantWidget({super.key, required this.plant});
  final Plant plant;
  @override
  State<PlantWidget> createState() => _PlantWidget();
}

class _PlantWidget extends State<PlantWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
          Text(widget.plant.name, style: TextStyle(fontWeight: FontWeight(600), color: Color.fromARGB(255, 10, 46, 36)), textAlign: TextAlign.center,), 
          Text(widget.plant.icon, textAlign: TextAlign.center)
      ]);
  }
}

class AreaPlantsWidget extends StatefulWidget {
  const AreaPlantsWidget({super.key, required this.plants, required this.areaId});
  final List<Plant?> plants;
  final int areaId;
  @override
  State<AreaPlantsWidget> createState() => _AreaPlantsWidget();
} 

class _AreaPlantsWidget extends State<AreaPlantsWidget> {
  // void deletePlantInArea(BuildContext context, Plant plant) async {
  //   final plantViewModel = PlantViewModel(plantRepository: context.read());
  //   await plantViewModel.deletePlantInArea(plant, widget.areaId);
  //   if (mounted) {
  //     setState(() {
  //       widget.plants.remove(plant);
  //     });
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Wrap (
      spacing: 20.0,
      runSpacing: 20.0,
      children: widget.plants.map((plant) => ElevatedButton(style: ButtonStyle(alignment: Alignment.center, shape: WidgetStatePropertyAll(LinearBorder.top()), elevation: WidgetStatePropertyAll(10.0), padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsetsGeometry.all(20.0)), backgroundColor: WidgetStatePropertyAll<Color>(const Color.fromRGBO(139, 238, 134, 1)), shadowColor: WidgetStatePropertyAll<Color>(const Color.fromARGB(255, 83, 65, 58))), onPressed: () => {
        //deletePlantInArea(context, plant)
      }, 
      child: PlantWidget(plant: plant!))).toList(),

    );
  }
}

class PlantGalleryWidget extends StatefulWidget {
  const PlantGalleryWidget({super.key, required this.plants, required this.areaId});
  final List<Plant?> plants;
  final int areaId;
  @override
  State<PlantGalleryWidget> createState() => _PlantGalleryWidget();
}

class _PlantGalleryWidget extends State<PlantGalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsetsGeometry.all(20.0),
      sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        childAspectRatio: 2.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final plant = widget.plants[index];
          return ElevatedButton(
            style: ButtonStyle(
              alignment: Alignment.center, 
              shape: WidgetStatePropertyAll(LinearBorder.top()), 
              elevation: WidgetStatePropertyAll(10.0),
              padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(EdgeInsetsGeometry.all(20.0)), 
              backgroundColor: WidgetStatePropertyAll<Color>(const Color.fromARGB(255, 115, 209, 121)), 
              shadowColor: WidgetStatePropertyAll<Color>(const Color.fromARGB(255, 83, 65, 58))
            ),
            onPressed: () => {},
            child: PlantWidget(plant: plant!));
          },
          childCount: widget.plants.length,
        )));    
      }
}