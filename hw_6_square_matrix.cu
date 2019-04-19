#include <stdio.h>
#include <cuda.h>

const int N = 10;

__global__ void square(int * matrix, int * result, int size) {
	unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
        unsigned ii = id / size;
        unsigned jj = id % size;
        for (unsigned kk = 0; kk < size; ++kk) {
                result[ii * size + jj] +=
                        matrix[kk * size + ii] *
                                matrix[kk * size + jj];
        }
}


void init_matrix(int * matrix, int size) {
	for (int i = 0; i <= size; i++) {
		matrix[i] = i;
	}

	for (int i = 1; i < size; i++) {
		for (int j = i * size, k = i; j < i * size + size; j++, k++) {
			matrix[j] = k;
		}
	}
	printf("matrix initialized\n");
}

	
void print_matrix(int * matrix, int size) {
	printf("printing matrix:\n");
	for (int i = 0; i < size * size; i++) {
		if (i % size == 0 && i != 0) {
			printf("\n");
		}
		printf("%d\t", matrix[i]);
	}
	printf("\n");
}


int main(int argc, char ** argv) {
	int size = N * N;
	int space = sizeof(int) * size;
	
	int * matrix = (int *)malloc(space);
	int * result, * d_matrix, * d_result;
	
	cudaMalloc((void **) &d_matrix, space);
	cudaMalloc((void **) &d_result, space);
        cudaMemcpy(d_matrix, matrix, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_result, result, size, cudaMemcpyHostToDevice);

	init_matrix(matrix, N);
	printf("initialized out\n");
	print_matrix(matrix, N);	
        
	square<<<N, N>>>(matrix, d_result, N);

        cudaMemcpy(result, d_result, N, cudaMemcpyDeviceToHost);

	print_matrix(result, N);
	return 0;
}
