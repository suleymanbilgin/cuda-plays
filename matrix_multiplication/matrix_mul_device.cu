#include <iostream>
#include <cstdlib>

using namespace std;

__global__
void MatrixMultiplication(unsigned long* Md, unsigned long* Nd, unsigned long* Pd, int width) {
    int tx = threadIdx.x; // x-index of threads
    int ty = threadIdx.y; // y-index of threads

    // Pvalue stores the Pd element that is computed by thread
    unsigned long Pvalue = 0;

    for(int k = 0; k < width; k++) {
        unsigned long Mdelement = Md[ty * width + k];
        unsigned long Ndelement = Nd[k * width + tx];
        Pvalue += Mdelement * Ndelement;
    }

    // Write the matrix to device memory
    // Each thread write one element
    Pd[ty * width + tx] = Pvalue;
}

int main(int argc, char **argv) {


    int width = 1500;
    
    cout << width << " x " << width << endl;
    
    unsigned long size = width * width * sizeof(unsigned long);
    unsigned long* A;
    unsigned long* B;
    unsigned long* C;

    A = (unsigned long*) malloc(size);
    B = (unsigned long*) malloc(size);
    C = (unsigned long*) malloc(size);
    srand (time(NULL));
    
    for (int i = 0; i < width; i++) {
        for (int j = 0; j < width; j++) {
            A[i * width + j] = (rand() % 100) + 1;
            B[i * width + j] = (rand() % 200) + 1;
        }
    }

    unsigned long* Ad;
    unsigned long* Bd;
    unsigned long* Cd;

    // transfer A and B to device memory
    cudaMalloc((void**) &Ad, size);
    cudaMemcpy(Ad, A, size, cudaMemcpyHostToDevice);
    cudaMalloc((void**) &Bd, size);
    cudaMemcpy(Bd, B, size, cudaMemcpyHostToDevice);

    // allocate c on the device
    // C is a result of matrix multiplication
    cudaMalloc((void**) &Cd, size);

    dim3 dimBlock(width, width);
    dim3 dimGrid(1,1);
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);
    MatrixMultiplication<<<dimGrid,dimBlock>>>(Ad, Bd, Cd, width);
    cudaEventRecord(stop);

    cudaMemcpy(C, Cd, size, cudaMemcpyDeviceToHost);
    cudaEventSynchronize(stop);
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    cout << endl;
    cout << milliseconds << endl;

    // for (int i = 0; i < width; i++) {
    //     for (int j = 0; j < width; j++) {
    //         cout << C[i * width + j] << "\t";
    //     }
    //     cout << endl;
    // }

    return 0;
}