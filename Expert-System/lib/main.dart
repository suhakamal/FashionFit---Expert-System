import 'package:flutter/material.dart';

class Rule {
  final bool Function(int) condition;
  final List<String> recommendation;
  final List<String> avoidance;

  const Rule({
    required this.condition,
    required this.recommendation,
    required this.avoidance,
  });
}

final rules = [
  Rule(
    condition: (skin) => skin >= 1 && skin <= 3,
    recommendation: [
      'cool (such as blues, greens, and purples)',
      'neutral (such as grays and whites)'
    ],
    avoidance: ['warm (such as reds, oranges, and yellows)'],
  ),
  Rule(
    condition: (skin) => skin == 4,
    recommendation: [
      'warm (such as reds, oranges, and yellows)',
      'neutral (such as grays and whites)'
    ],
    avoidance: ['cool (such as blues, greens, and purples)'],
  ),
  Rule(
    condition: (skin) => skin >= 5 && skin <= 6,
    recommendation: [
      'deep warm (such as deep reds, burgundies, and mustards)',
      'neutral (such as grays and whites)'
    ],
    avoidance: ['light (such as pastels and pale colors)'],
  ),
];

class ColorRecommendationEngine {
  final int skinTone;

  ColorRecommendationEngine(this.skinTone);

  List<String> getRecommendations() {
    final recommendations = <String>[];
    final avoidances = <String>[];

    for (final rule in rules) {
      if (rule.condition(skinTone)) {
        recommendations.addAll(rule.recommendation);
        avoidances.addAll(rule.avoidance);
      }
    }

    return recommendations;
  }

  List<String> getAvoidances() {
    final avoidances = <String>[];

    for (final rule in rules) {
      if (rule.condition(skinTone)) {
        avoidances.addAll(rule.avoidance);
      }
    }

    return avoidances;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Recommendation Engine',
      home: ColorRecommendationPage(),
    );
  }
}

class ColorRecommendationPage extends StatefulWidget {
  @override
  _ColorRecommendationPageState createState() =>
      _ColorRecommendationPageState();
}

class _ColorRecommendationPageState extends State<ColorRecommendationPage> {
  int _skinTone = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Recommendation Engine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('To determine your skin tone, consider the following:'),
            SizedBox(height: 8.0),
            Text(
                '- If your veins appear more blue/purple, you have a cool skin tone (1-3).'),
            Text('    1. Pale.'
                '     2. Fair.'
                '     3. Medium.\n'),
            Text(
                '- If your veins appear more green, you have a warm skin tone.(4)'),
            Text('    4. Warm.\n'),
            Text(
                '- If your veins appear a mix of blue/purple and green, you have a neutral skin tone.(5-6)'),
            Text('    5. Golden.'
                '     6. Deep.\n'),
            SizedBox(height: 16.0),
            Text('Enter your skin tone (1-6):'),
            Slider(
              value: _skinTone.toDouble(),
              min: 1,
              max: 6,
              divisions: 5,
              onChanged: (value) {
                setState(() {
                  _skinTone = value.toInt();
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final engine = ColorRecommendationEngine(_skinTone);
                final recommendations = engine.getRecommendations();
                final avoidances = engine.getAvoidances();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Color Recommendations'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Recommended colors:'),
                        SizedBox(height: 8.0),
                        ...recommendations
                            .map((color) => Text('- $color'))
                            .toList(),
                        SizedBox(height: 16.0),
                        Text('Colors to avoid:'),
                        SizedBox(height: 8.0),
                        ...avoidances.map((color) => Text('- $color')).toList(),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Get Recommendations'),
            ),
          ],
        ),
      ),
    );
  }
}
