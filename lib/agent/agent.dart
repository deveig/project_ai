import 'package:dartantic_ai/dartantic_ai.dart' as dartantic;
import '../data/plants.dart' as plants_data;

class DartanticAgent {
  DartanticAgent();
  final tool = 
    dartantic.Tool(
      name: 'find_plants',
      description: 'Finds plants for permaculture advices',
      onCall: (_) => {
        'plants': plants_data.plants
      }
    );
  late final agent = dartantic.Agent.forProvider(
    dartantic.GoogleProvider(apiKey: 'GEMINI_API_KEY'),
    chatModelName: 'gemini-3.5-flash',
    tools: [tool]
  ); 
}