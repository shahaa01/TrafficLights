// traffic_lights_game.dart

enum LightColor { Off, Green, Yellow, Red }

class TrafficLightsGame {
  final int rows = 3;
  final int cols = 4;
  List<List<LightColor>> board;
  int currentPlayer;
  bool gameOver;
  LightColor? winnerColor;

  TrafficLightsGame()
      : board = List.generate(3, (_) => List.filled(4, LightColor.Off)),
        currentPlayer = 1,
        gameOver = false,
        winnerColor = null;

  bool makeMove(int row, int col) {
    if (gameOver || row < 0 || row >= rows || col < 0 || col >= cols) return false;

    var cell = board[row][col];
    if (cell == LightColor.Red) return false;

    board[row][col] = _nextColor(cell);
    if (_checkWin(row, col)) {
      gameOver = true;
      winnerColor = board[row][col];
    } else {
      _switchPlayer();
    }
    return true;
  }

  LightColor _nextColor(LightColor color) {
    switch (color) {
      case LightColor.Off:
        return LightColor.Green;
      case LightColor.Green:
        return LightColor.Yellow;
      case LightColor.Yellow:
        return LightColor.Red;
      case LightColor.Red:
        return LightColor.Red;
    }
  }

  void _switchPlayer() {
    currentPlayer = 3 - currentPlayer;
  }

  bool _checkWin(int row, int col) {
    LightColor color = board[row][col];
    return _checkRow(row, color) ||
           _checkColumn(col, color) ||
           _checkDiagonals(color);
  }

  bool _checkRow(int row, LightColor color) {
    return board[row].where((c) => c == color).length >= 3;
  }

  bool _checkColumn(int col, LightColor color) {
    int count = 0;
    for (int r = 0; r < rows; r++) {
      if (board[r][col] == color) count++;
    }
    return count >= 3;
  }

  bool _checkDiagonals(LightColor color) {
    List<List<List<int>>> diagonals = [
      [[0,0], [1,1], [2,2]],
      [[0,1], [1,2], [2,3]],
      [[0,3], [1,2], [2,1]],
      [[0,2], [1,1], [2,0]]
    ];

    for (var diag in diagonals) {
      if (diag.every((pos) => board[pos[0]][pos[1]] == color)) {
        return true;
      }
    }
    return false;
  }

  void reset() {
    board = List.generate(3, (_) => List.filled(4, LightColor.Off));
    currentPlayer = 1;
    gameOver = false;
    winnerColor = null;
  }

  void printBoard() {
    for (var row in board) {
      print(row.map((cell) => _colorToString(cell)).join(" "));
    }
  }

  String _colorToString(LightColor color) {
    switch (color) {
      case LightColor.Off:
        return ".";
      case LightColor.Green:
        return "G";
      case LightColor.Yellow:
        return "Y";
      case LightColor.Red:
        return "R";
    }
  }

  String get status {
    if (gameOver) {
      return "Player $currentPlayer wins with ${_colorToString(winnerColor!)}!";
    } else {
      return "Player $currentPlayer's turn.";
    }
  }
}
