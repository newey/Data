#include "game.h"
#include <iostream>
#include <set>
#include <cstdlib>
#include <ctime>

using namespace std;

vector <coordinate> Board::neighbours(coordinate coord) {
    vector <coordinate> neigh;
    int row = coord.first;
    int col = coord.second;
    for (int dr = -1; dr <= 1 ; dr++){
        for (int dc = -1; dc <= 1; dc++) {
            if (dr != dc || dr != 0){
                neigh.push_back(make_pair(row+dr, col+dc));
            }
        }
    }
    return neigh;
}

Board::Board (int fillPercent, int Rows, int Cols) {
    rows = Rows;
    cols = Cols;
    for (int r = 0; r < rows; r ++){
        for (int c = 0; c < cols; c++){
            if (rand() % 100 < fillPercent) {
                live.insert(make_pair(r, c));
            }
        }
    }
}

Board::Board (Board &previousGen) {
    multiset < coordinate > counts;
    rows = previousGen.rows;
    cols = previousGen.cols;
    for (auto it = previousGen.live.begin(); it != previousGen.live.end(); it++){
        auto tovisit = neighbours(*it);
        for (auto it2 = tovisit.begin(); it2 < tovisit.end(); it2++){
            counts.insert(*it2);
        }
    }
    for (auto it = previousGen.live.begin(); it != previousGen.live.end(); it++){
        if (counts.count(*it) == 2 || counts.count(*it) == 3) {
            live.insert(*it);
        }
    }
    for (auto it = counts.begin(); it != counts.end(); it++){
        if (counts.count(*it) == 3){
            live.insert(*it);
        }
    }
}

void Board::print () {
    for (int row = 0; row < rows; row++){
        for (int col = 0; col < cols; col++){
            printf (live.count(make_pair(row, col)) == 0 ? "_" : "#");
        }
        printf("\n");
    }
    printf("\n");
}
