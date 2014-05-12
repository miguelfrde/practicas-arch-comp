#include <stdio.h>

int main(int argc, char* argv[]) {
    int A[4][3][2] = { { {1, -3}, {5, 7}, {9, 0} },
                       { {2, -4}, {6, 8}, {1, 3} },
                       { {-1, 0}, {1, 0}, {0, 0} },
                       { {-5, 7}, {9, 0}, {1, 0} }
                     };
    int B[3][4][2];
    int i;
    int j;

    for (i = 0; i < 4; i++) {
        for (j = 0; j < 3; j++) {
            B[j][i][0] = A[i][j][0];
            B[j][i][1] = -A[i][j][1];
        }
    }

    for (i = 0; i < 3; i++)
        for (j = 0; j < 4; j++)
            printf("%d %d ", B[i][j][0], B[i][j][1]);
    printf("\n");
}
