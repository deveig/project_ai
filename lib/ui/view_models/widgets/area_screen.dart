import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genui/genui.dart' as dartantic;
import 'package:provider/provider.dart';
import 'package:genui/genui.dart';
import 'package:json_schema_builder/json_schema_builder.dart';

import '../../../agent/agent.dart';
import '../../../data/model/perma.dart';
import '../plant_view_model.dart';
import 'plant_screen.dart';

class AreaScreen extends StatefulWidget {
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
  late final SurfaceController _surfaceController;
  late final A2uiTransportAdapter _transportAdapter;
  late final Conversation _conversation;
  final _messageController = TextEditingController(text: 'number');
  bool _isStreaming = false;
  bool _isRequested = false;
  bool _isMessageNoPlant = false;
  void getAllPlants(BuildContext context) async {
    try {
      final viewModel = PlantViewModel(plantRepository: context.read());
      final plantsGallery = await viewModel.getAllPlants();
      if (mounted) {
        setState(() {
          plants = plantsGallery;
        });
      }
    } catch (e) {
      // Handle the error, e.g., show a snackbar or log it
      throw ('Error loading plants: $e');
    }
  }

  void getPlantsByAreaId(BuildContext context) async {
    try {
      final viewModel = PlantViewModel(plantRepository: context.read());
      final plants = await viewModel.getPlantsByAreaId(widget.areaId);
      if (plants != null) {
        if (mounted) {
          setState(() {
            selectedPlants = plants;
          });
        }
      }
    } catch (e) {
      // Handle the error, e.g., show a snackbar or log it
      throw ('Error loading plants for area: $e');
    }
  }

  void filterPlantsByCriteria(BuildContext context, String criteria) async {
    try {
      final viewModel = PlantViewModel(plantRepository: context.read());
      final galleryPlants = await viewModel.getPlantsByCriteria(criteria);
      if (galleryPlants != null) {
        if (mounted) {
          setState(() {
            plants = galleryPlants;
          });
        }
      }
    } catch (e) {
      // Handle the error, e.g., show a snackbar or log it
      throw ('Error loading plants for area: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // In initState:
    final catalog = BasicCatalogItems.asCatalog().copyWith(
      newItems: [plantAdviceCard],
    );
    _surfaceController = SurfaceController(catalogs: [catalog]);

    // Create a SurfaceController with a widget catalog.
    // The BasicCatalogItems contain basic widgets for text, markdown, and images.
    //_surfaceController = SurfaceController(catalogs: [BasicCatalogItems.asCatalog()]);
    // _surfaceController = SurfaceController(
    //   catalogs: [BasicCatalogItems.asCatalog().copyWith(newItems: [riddleCard])],
    // );
    // final catalog = BasicCatalogItems.asCatalog();
    final promptBuilder = PromptBuilder.chat(
      catalog: catalog,
      systemPromptFragments: [
        '''
        You are an expert in permaculture concept. Every time I give you a list of plants,
        you should generate UI that displays advices following permaculture concept and crop rotation culture concept by recommand adding other plant in order to enhance the given list of plants.
        Each advice should have a plant name given by find_plants tool, a plant icon given by find_plants tool and an advice about how the plant can help actual list of plants by permaculture concept. Don't include title and description in component.
        ''',
      ],
    );

    // The Conversation wires transport -> controller internally.
    _transportAdapter = A2uiTransportAdapter(
      onSend: (message) async {
        // Implement sending to LLM and pipe chunks back.
        final prompt = promptBuilder.systemPromptJoined();
        final agent = DartanticAgent();
        try {
          final stream = agent.agent.sendStream(
            message.text,
            history: [dartantic.ChatMessage.user(prompt)],
          );
          await for (final result in stream) {
            if (result.output.isNotEmpty) {
              _transportAdapter.addChunk(result.output);
            }
          }
        } catch (err) {
          print('Failed to generate: $err');
        } finally {
          if (mounted) setState(() => _isStreaming = false);
        }
      },
    );
    // ... initialize your LLM Client of choice using promptBuilder.systemPromptJoined()
    // Create the Conversation to orchestrate everything.
    _conversation = Conversation(
      controller: _surfaceController,
      transport: _transportAdapter,
    );

    // Listen for surface lifecycle events:
    _conversation.events.listen((event) {
      if (event is ConversationSurfaceAdded) {
        _onSurfaceAdded(event);
      } else if (event is ConversationSurfaceRemoved) {
        _onSurfaceDeleted(event);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _conversation.dispose();
    _transportAdapter.dispose();
    super.dispose();
  }

  Future<void> _generatePlantAdviceList() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isStreaming) return;
    if (mounted) {
      setState(() {
        //_riddles = null;
        _isStreaming = true;
      });
    }
    await _conversation.sendRequest(ChatMessage.user(message));
  }

  //final _textController = TextEditingController();
  final _surfaceIds = <String>[];

  // Invoked by the events stream listener when a new
  // UI surface is generated. Here, the ID is stored so the
  // build method can create a Surface to display it.
  void _onSurfaceAdded(ConversationSurfaceAdded update) {
    setState(() {
      _surfaceIds.add(update.surfaceId);
    });
  }

  // Invoked by the events stream listener when a UI surface is removed.
  void _onSurfaceDeleted(ConversationSurfaceRemoved update) {
    setState(() {
      _surfaceIds.remove(update.surfaceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    criteriaView == .all
        ? getAllPlants(context)
        : filterPlantsByCriteria(context, criteriaView.name);
    getPlantsByAreaId(context);
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
          'Area ${widget.areaIndex}',
          style: TextStyle(
            fontWeight: FontWeight(900),
            color: const Color.fromARGB(255, 8, 51, 35),
          ),
        ),
      ),
      body: Container(
        color: Color.fromARGB(255, 221, 245, 238),
        alignment: Alignment.center,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      height: 450,
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      color: Colors.brown,
                      child: AreaPlantsWidget(
                        plants: selectedPlants,
                        areaId: widget.areaId,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (selectedPlants.length > 0) {
                          _generatePlantAdviceList();
                          if (mounted) {
                            setState(() {
                              _isRequested = true;
                            });
                          }
                        } else {
                          if (mounted) {
                            setState(() {
                              _isMessageNoPlant = true;
                            });
                          }
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10.0,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.assistant,
                                color: Color.fromARGB(255, 8, 51, 35),
                                size: 24.0,
                                semanticLabel:
                                    'Ask generative AI for permaculture advice',
                              ),
                              Text(
                                'permaculture advice',
                                style: TextStyle(
                                  fontWeight: FontWeight(900),
                                  color: const Color.fromARGB(255, 8, 51, 35),
                                ),
                              ),
                            ],
                          ),
                          _isMessageNoPlant
                              ? Text(
                                  'Add a plant to the area',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight(700),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    _isRequested
                        ? Container(
                            padding: EdgeInsets.all(20.0),
                            height: 400.0,
                            child: ListView.builder(
                              itemCount: _surfaceIds.length,
                              itemBuilder: (context, index) {
                                // For each surface, create a Surface to display it.
                                final id = _surfaceIds[index];
                                return Surface(
                                  surfaceContext: _surfaceController.contextFor(
                                    id,
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(),
                    Text(
                      'SELECT PLANTS',
                      style: TextStyle(
                        fontWeight: FontWeight(600),
                        color: Color.fromARGB(255, 10, 46, 36),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: SegmentedButton<Criteria>(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            Color.fromARGB(255, 202, 227, 161),
                          ),
                        ),
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
                            ),
                          ),
                          ButtonSegment<Criteria>(
                            value: Criteria.flower,
                            //label: Text('flower'),
                            icon: Icon(
                              Icons.local_florist,
                              color: Color.fromARGB(255, 8, 51, 35),
                              semanticLabel: 'Flower',
                            ),
                          ),
                          ButtonSegment<Criteria>(
                            value: Criteria.fruit,
                            //label: Text('fruit'),
                            icon: FaIcon(
                              FontAwesomeIcons.appleWhole,
                              color: Color.fromARGB(255, 8, 51, 35),
                              semanticLabel: 'Fruit',
                            ),
                          ),
                          ButtonSegment<Criteria>(
                            value: Criteria.vegetable,
                            //label: Text('vegetable'),
                            icon: FaIcon(
                              FontAwesomeIcons.carrot,
                              color: Color.fromARGB(255, 8, 51, 35),
                              semanticLabel: 'Vegetable',
                            ),
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
                          filterPlantsByCriteria(context, criteriaView.name);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            PlantGalleryWidget(plants: plants, areaId: widget.areaId),
          ],
        ),
      ),
    );
  }
}

enum Criteria { all, aromatic, vegetable, fruit, flower }

final _schema = S.object(
  properties: {
    'plantName': S.string(description: 'The name of the plant'),
    'plantIcon': S.string(description: 'The icon of the plant.'),
    'advice': S.string(
      description: 'The advice about assistance provided by the plant.',
    ),
  },
  required: ['plantName', 'plantIcon', 'advice'],
);

final plantAdviceCard = CatalogItem(
  name: 'PlantAdviceCard',
  dataSchema: _schema,
  widgetBuilder: (itemContext) {
    final json = itemContext.data as Map<String, Object?>;
    final plantName = json['plantName'] as String;
    final plantIcon = json['plantIcon'] as String;
    final advice = json['advice'] as String;

    final context = itemContext.buildContext;

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      //decoration: BoxDecoration(border: Border.all()),
      color: const Color.fromARGB(255, 229, 218, 179),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(plantName),
          const SizedBox(height: 8.0),
          Text(plantIcon),
          const SizedBox(height: 8.0),
          Text(advice),
        ],
      ),
    );
  },
);

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
        Text(
          widget.plant.name,
          style: TextStyle(
            fontWeight: FontWeight(600),
            color: Color.fromARGB(255, 10, 46, 36),
          ),
          textAlign: TextAlign.center,
        ),
        Text(widget.plant.icon, textAlign: TextAlign.center),
      ],
    );
  }
}

class AreaPlantsWidget extends StatefulWidget {
  const AreaPlantsWidget({
    super.key,
    required this.plants,
    required this.areaId,
  });
  final List<Plant?> plants;
  final int areaId;
  @override
  State<AreaPlantsWidget> createState() => _AreaPlantsWidget();
}

class _AreaPlantsWidget extends State<AreaPlantsWidget> {
  void deletePlantInArea(BuildContext context, Plant plant) async {
    final plantViewModel = PlantViewModel(plantRepository: context.read());
    await plantViewModel.deletePlantInArea(plant, widget.areaId);
    if (mounted) {
      setState(() {
        widget.plants.remove(plant);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20.0,
      runSpacing: 20.0,
      children: widget.plants
          .map(
            (plant) => ElevatedButton(
              style: ButtonStyle(
                alignment: Alignment.center,
                shape: WidgetStatePropertyAll(LinearBorder.top()),
                elevation: WidgetStatePropertyAll(10.0),
                padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                  EdgeInsetsGeometry.all(20.0),
                ),
                backgroundColor: WidgetStatePropertyAll<Color>(
                  const Color.fromRGBO(139, 238, 134, 1),
                ),
                shadowColor: WidgetStatePropertyAll<Color>(
                  const Color.fromARGB(255, 83, 65, 58),
                ),
              ),
              onPressed: () => {deletePlantInArea(context, plant)},
              child: PlantWidget(plant: plant!),
            ),
          )
          .toList(),
    );
  }
}

class PlantGalleryWidget extends StatefulWidget {
  const PlantGalleryWidget({
    super.key,
    required this.plants,
    required this.areaId,
  });
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
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          final plant = widget.plants[index];
          return ElevatedButton(
            style: ButtonStyle(
              alignment: Alignment.center,
              shape: WidgetStatePropertyAll(LinearBorder.top()),
              elevation: WidgetStatePropertyAll(10.0),
              padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
                EdgeInsetsGeometry.all(20.0),
              ),
              backgroundColor: WidgetStatePropertyAll<Color>(
                const Color.fromARGB(255, 115, 209, 121),
              ),
              shadowColor: WidgetStatePropertyAll<Color>(
                const Color.fromARGB(255, 83, 65, 58),
              ),
            ),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (context) =>
                      PlantScreen(plantId: plant.id!, areaId: widget.areaId),
                ),
              ),
            },
            child: PlantWidget(plant: plant!),
          );
        }, childCount: widget.plants.length),
      ),
    );
  }
}
