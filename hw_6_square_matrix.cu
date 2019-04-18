#include <stdio.h>
#include <cuda.h>

const int N = 10;

void init_matrix(int * matrix, int size) {
	for (int i = 0; i < size; i++) {
                for (int j = 0; j < size; j++) {        
			matrix[i][j] = i + j;
			printf("%d ", matrix[i][j]);
                }
		printf("\n");
        }
	printf("\n\n");
}


void print_matrix(int * matrix, int size) {
	for (int i = 0; i < size; i++) {
                printf("%d", matrix[i]);
	}
}

__global__ void square(int * matrix, int * result, int size) {
	unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
	unsigned i = id / size;
	unsigned j = id % size;
	for (unsigned k = 0; k < size; ++k) {
		result[i * size + j] += 
			matrix[i * size + k] * 
				matrix[k * size + j];
	}
}

int main(int argc, char ** argv) {
	int * matrix, * result;
	init_matrix(matrix, N);
	square<<<N, N>>>(matrix, result, N);
	print_matrix(matrix, N);
	return 0;
}
