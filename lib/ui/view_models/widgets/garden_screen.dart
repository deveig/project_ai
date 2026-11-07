import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/model/perma.dart';
import '../garden_view_model.dart';

class GardenScreen extends StatefulWidget {
  const GardenScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  @override
  State<GardenScreen> createState() => _GardenScreenState();
}

class _GardenScreenState extends State<GardenScreen> {
  Garden garden = Garden(id: 1);
  List<Area>? areas = [];
  void getGarden(BuildContext context) async {
    try {
      final gardenViewModel = GardenViewModel(gardenRepository: context.read());
      final stockedGarden = await gardenViewModel.load();
      if(mounted) {
        setState(() {
          garden = stockedGarden!;
        });
      }
    } catch (e) {
      // Handle the error, e.g., show a snackbar or log it
      throw ('Error loading garden: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    getGarden(context);
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        //backgroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: const Color.fromARGB(255, 221, 245, 238),
        // Here we take the value from the GardenScreen object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight(900),
            color: const Color.fromARGB(255, 8, 51, 35),
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 221, 245, 238),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            //spacing: 5.0,
            children: [
              Container(
                height: 450.0,
                padding: EdgeInsets.all(20.0),
                margin: EdgeInsets.all(20),
                alignment: Alignment.center,
                color: Colors.brown,
                child: AreaWidget(areas: areas ?? []),
              ),
              Container(
                margin: EdgeInsets.all(20),
                alignment: Alignment.bottomCenter,
                width: 200.0,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(
                      Colors.brown,
                    ),
                  ),
                  onPressed: () {
                    // addArea(context);
                    // getAreasByGarden(context);
                  },
                  child: Text(
                    'Add an area to the garden',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 237, 225, 221),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AreaWidget extends StatefulWidget {
  const AreaWidget({super.key, required this.areas});
  final List<Area> areas;
  @override
  State<AreaWidget> createState() => _AreaWidget();
}

class _AreaWidget extends State<AreaWidget> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20.0,
      runSpacing: 20.0,
      children: widget.areas
          .map(
            (area) => ElevatedButton(
              style: ButtonStyle(
                alignment: Alignment.center,
                shape: WidgetStatePropertyAll(LinearBorder.top()),
                elevation: WidgetStatePropertyAll(10.0),
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsetsGeometry.all(20.0),
                ),
                backgroundColor: WidgetStatePropertyAll<Color>(
                  const Color.fromARGB(255, 185, 152, 140),
                ),
                shadowColor: WidgetStatePropertyAll<Color>(
                  const Color.fromARGB(255, 83, 65, 58),
                ),
              ),
              onPressed: () => {},
              child: Column(
                children: [
                  Text(
                    'Area ${widget.areas.indexOf(area) + 1}',
                    style: TextStyle(
                      fontWeight: FontWeight(600),
                      color: Color.fromARGB(255, 237, 225, 221),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //deleteArea(context, area);
                    },
                    child: Text(
                      'Delete area',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 237, 225, 221),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
