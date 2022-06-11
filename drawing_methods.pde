static float unit = 50;
static float rows = 25;
static float cols = 25;
static float subdivisions = 8;
final float gridWidth = cols * unit;
final float gridHeight = rows * unit;

void drawGrid() {
  setGridStroke();
  
  for(int col = 0; col < cols; col++) {
    setHighlightedGridStroke();
    float colWidth = col * unit;
    line(colWidth, 0, colWidth, gridHeight); 
    setGridStroke();
    for(int sub = 1; sub < subdivisions; sub++) {
      float subColWidth = colWidth + (sub * unit / subdivisions);
      line(subColWidth, 0, subColWidth, gridHeight);
      // for a good time: line(subColWidth, 0, gridHeight, subColWidth);
    }
  }
  
  for(int row = 0; row < rows; row++) {
    setHighlightedGridStroke();
    float rowHeight = row * unit;
    line(0, rowHeight, gridWidth, rowHeight);
    
    setGridStroke();
    for(int sub = 1; sub < subdivisions; sub++) {
      float subRowHeight = rowHeight + (sub * unit / subdivisions);
      line(0, subRowHeight, gridWidth, subRowHeight);
    }
  }
}
