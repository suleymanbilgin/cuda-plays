#include <iostream>
#include <stdio.h>
#include <cstdlib>
#include <ctime> 

using namespace std;

void matrix_multiplication(float* M, float* N, float* P, int witdh) {
    for (int i = 0; i < witdh; i++) {
        for (int j = 0; j < witdh; j++) {
            int sum = 0;
            for (int k = 0; k < witdh; k++) {
                float a = M[i * witdh + k];
                float b = N[k * witdh + j];
                
                sum += a * b;
            }
            P[i * witdh + j] = sum;
        }
    }
}

int main(int argc, char **argv) {
    int witdh = 200;

    float* A;
    float* B;
    float* C;

    A = (float*) malloc(witdh * witdh * sizeof(float));
    B = (float*) malloc(witdh * witdh * sizeof(float));
    C = (float*) malloc(witdh * witdh * sizeof(float));
    srand (time(NULL));

    // for (int i = 0; i < witdh; i++) {
    //     for (int j = 0; j < witdh; j++) {
    //         A[i * witdh + j] = (rand() % 100) + 1;
    //         B[i * witdh + j] = (rand() % 200) + 1;
    //     }
    // }
    // cout << endl;
    // for (int i = 0; i < witdh; i++) {
    //     for (int j = 0; j < witdh; j++) {
    //         cout << A[i * witdh + j] << "\t";
    //     }
    //     cout << endl;
    // }

    // cout << endl;

    // for (int i = 0; i < witdh; i++) {
    //     for (int j = 0; j < witdh; j++) {
    //         cout << B[i * witdh + j] << "\t";
    //     }
    //     cout << endl;
    // }

    matrix_multiplication(A, B, C, witdh);

    /*for (int i = 0; i < witdh; i++) {
        for (int j = 0; j < witdh; j++) {
            cout << C[i * witdh + j] << "\t";
        }
        cout << endl;
    }*/

    return 0;
}
