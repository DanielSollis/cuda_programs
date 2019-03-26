#include <stdio.h>
#include <cuda.h>

__device__ void add_i(int * arr) { 
	arr[blockIdx.x] += blockIdx.x;
}


__global__ void initialize(int * arr) {
	arr[blockIdx.x] = 0;
	add_i(arr);
}

int main(int argc, char ** argv) {
	int * arr;
	int * d_arr;
	int n = 1024;
	int size = n * sizeof(int);
	
	arr = (int *)malloc(size);
	cudaMalloc((void **) &d_arr, size);
	cudaMemcpy(d_arr, arr, size, cudaMemcpyHostToDevice);
	initialize<<<n, 1>>>(d_arr);
	cudaMemcpy(arr, d_arr, size, cudaMemcpyDeviceToHost);
	
	for (int i = 0; i < n; i++) {
		printf("%d ", arr[i]);
		if (i % 16 == 0 && i != 0) {
			printf("\n");
		}
	}
	printf("\n");
}
