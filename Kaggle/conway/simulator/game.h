#include <set>
#include <vector>
#include <utility>

using namespace std;

typedef pair <int, int> coordinate;

class Board {
public:
    Board (int fillPercent, int rows, int cols);
    Board (Board &previousGen);
    bool isAlive() { return live.size() > 0; }
    void print();
protected:
    set < coordinate > live;
    char rows;
    char cols;
private:
    vector <coordinate> neighbours (coordinate c);
};
