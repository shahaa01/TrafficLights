import 'package:flutter/material.dart';
import 'traffic_lights_game.dart';

void main() {
  runApp(const TrafficLightsApp());
}

class TrafficLightsApp extends StatelessWidget {
  const TrafficLightsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Lights Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TrafficLightsScreen(),
    );
  }
}

class TrafficLightsScreen extends StatefulWidget {
  const TrafficLightsScreen({super.key});

  @override
  State<TrafficLightsScreen> createState() => _TrafficLightsScreenState();
}

class _TrafficLightsScreenState extends State<TrafficLightsScreen> {
  late TrafficLightsGame game;
  bool colorblindMode = false;

  @override
  void initState() {
    super.initState();
    game = TrafficLightsGame();
  }

  Color _getColor(LightColor color) {
    switch (color) {
      case LightColor.off:
        return Colors.grey.shade300;
      case LightColor.green:
        return Colors.green;
      case LightColor.yellow:
        return Colors.yellow;
      case LightColor.red:
        return Colors.red;
    }
  }

  Widget _getColorblindPattern(LightColor color) {
    if (!colorblindMode) return const SizedBox.shrink();

    switch (color) {
      case LightColor.off:
        return const SizedBox.shrink();
      case LightColor.green:
        return const Center(
          child: Divider(
            color: Colors.black,
            thickness: 2,
            height: 2,
          ),
        );
      case LightColor.yellow:
        return const Center(
          child: VerticalDivider(
            color: Colors.black,
            thickness: 2,
            width: 2,
          ),
        );
      case LightColor.red:
        return Center(
          child: Stack(
            children: [
              Transform.rotate(
                angle: 0.785398, // 45 degrees in radians
                child: Container(
                  width: 40,
                  height: 2,
                  color: Colors.black,
                ),
              ),
              Transform.rotate(
                angle: -0.785398, // -45 degrees in radians
                child: Container(
                  width: 40,
                  height: 2,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
    }
  }

  void _handleTap(int row, int col) {
    setState(() {
      if (game.makeMove(row, col)) {
        if (game.gameOver) {
          _showWinDialog();
        }
      }
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text('Player ${game.currentPlayer} wins with ${_colorToString(game.winnerColor!)}!'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                game.reset();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Rules'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('• Players take turns clicking on the traffic lights.'),
            Text('• Each click cycles a light: Off → Green → Yellow → Red.'),
            Text('• Red lights cannot be changed.'),
            Text('• The goal is to create a line of 3 or more lights of the same color (horizontally, vertically, or diagonally).'),
            Text('• The player who creates such a line wins!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _colorToString(LightColor color) {
    switch (color) {
      case LightColor.off:
        return 'Off';
      case LightColor.green:
        return 'Green';
      case LightColor.yellow:
        return 'Yellow';
      case LightColor.red:
        return 'Red';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we're on a small screen
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Traffic Lights Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'New Game',
            onPressed: () {
              setState(() {
                game.reset();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    'Traffic Lights Game',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Colorblind Patterns
                  if (colorblindMode) _buildColorblindLegend(),

                  // Game Board
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: LayoutBuilder(
                        builder: (context, constraints) {
                          final cellSize = constraints.maxWidth / 3 - 16;

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                            ),
                            itemCount: game.rows * game.cols,
                            itemBuilder: (context, index) {
                              final row = index ~/ game.cols;
                              final col = index % game.cols;

                              return GestureDetector(
                                onTap: () => _handleTap(row, col),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _getColor(game.board[row][col]),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black26, width: 2),
                                  ),
                                  child: _getColorblindPattern(game.board[row][col]),
                                ),
                              );
                            },
                          );
                        }
                    ),
                  ),

                  // Game Info
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Current Player: Player ${game.currentPlayer}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  // Buttons
                  isSmallScreen
                      ? Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              colorblindMode = !colorblindMode;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(colorblindMode ? 'Disable Colorblind Mode' : 'Colorblind Mode'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              game.reset();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('New Game'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _showRulesDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Show Rules'),
                        ),
                      ),
                    ],
                  )
                      : Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              colorblindMode = !colorblindMode;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(colorblindMode ? 'Disable Colorblind Mode' : 'Colorblind Mode'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              game.reset();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('New Game'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _showRulesDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Show Rules'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorblindLegend() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Colorblind Patterns:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(LightColor.off, 'Off'),
              _buildLegendItem(LightColor.green, 'Green (horizontal)'),
              _buildLegendItem(LightColor.yellow, 'Yellow (vertical)'),
              _buildLegendItem(LightColor.red, 'Red (X pattern)'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(LightColor color, String label) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: _getColor(color),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black26, width: 2),
          ),
          child: _getColorblindPattern(color),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}