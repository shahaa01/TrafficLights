enum LightColor { off, green, yellow, red }

class TrafficLightsGame {
  final int rows = 4;
  final int cols = 3;
  List<List<LightColor>> board;
  int currentPlayer;
  bool gameOver;
  LightColor? winnerColor;

  TrafficLightsGame()
      : board = List.generate(4, (_) => List.filled(3, LightColor.off)),
        currentPlayer = 1,
        gameOver = false,
        winnerColor = null;

  bool makeMove(int row, int col) {
    if (gameOver || row < 0 || row >= rows || col < 0 || col >= cols) return false;

    var cell = board[row][col];
    if (cell == LightColor.red) return false;

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
      case LightColor.off:
        return LightColor.green;
      case LightColor.green:
        return LightColor.yellow;
      case LightColor.yellow:
        return LightColor.red;
      case LightColor.red:
        return LightColor.red;
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
      [[0,2], [1,1], [2,0]],
      [[1,0], [2,1], [3,2]],
      [[1,2], [2,1], [3,0]]
    ];

    for (var diag in diagonals) {
      if (diag.every((pos) => board[pos[0]][pos[1]] == color)) {
        return true;
      }
    }
    return false;
  }

  void reset() {
    board = List.generate(4, (_) => List.filled(3, LightColor.off));
    currentPlayer = 1;
    gameOver = false;
    winnerColor = null;
  }

  String _colorToString(LightColor color) {
    switch (color) {
      case LightColor.off:
        return ".";
      case LightColor.green:
        return "G";
      case LightColor.yellow:
        return "Y";
      case LightColor.red:
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