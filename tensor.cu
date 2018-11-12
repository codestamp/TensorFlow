#include <iostream>
#include <algorithm>

using namespace std;

class Net {
private:
	int rows, cols;
	int** inputTensor;
	int** outputTensor;
public:
	Net(int, int);
	int relulayer();
	void poolingFunction(int, int, bool);
	void filterConvolve(int);
	void printArray();

};

Net::Net(int r, int c) {
	rows = r;
	cols = c;
	cout << "\n\nInitialization of " << rows << " x " << cols
			<< " 2D array with random values between -9 and 9\n\n";
	//input tensor initialization
	inputTensor = new int*[rows];
	for (int k = 0; k < rows; k++)
		inputTensor[k] = new int[cols];

	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			inputTensor[i][j] = rand() % 19 + (-9);
		}
	}

	//output tensor initialization to zero
	outputTensor = new int*[rows];
	for (int k = 0; k < rows; k++)
		outputTensor[k] = new int[cols];

	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			outputTensor[i][j] = 0;
		}
	}

}

int Net::relulayer() {
	/*
	 * A `ReLULayer` is the identity function for
	 * non-negative inputs, and gives zero for negative inputs.
	 */
	cout
			<< "\n\nReluLayer Identity Function converts negative inputs to zero\n\n";
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			if (inputTensor[i][j] < 0)
				outputTensor[i][j] = 0;
			else
				outputTensor[i][j] = inputTensor[i][j];
		}
	}
	return 0;
}

void Net::printArray() {

	cout << "\n\nINPUT TENSOR\n\n";
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			cout << inputTensor[i][j] << '\t';
		}
		cout << "\n";
	}

	cout << "\n\nOUTPUT TENSOR\n\n";
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			cout << outputTensor[i][j] << '\t';
		}
		cout << "\n";
	}
}

void Net::poolingFunction(int stride, int windowSize, bool minMax)
{

	//output matrix calculation
	//bool minMax=true implied min else max operation
	cout << "\n\nPooling function -- find on min/max operations\n\n";
	if (minMax == true)
		cout << "Pools using min operation, stride is " << stride
				<< " and window size is " << windowSize << endl;
	else
		cout << "Pools using max operation, stride is " << stride
				<< " and window size is " << windowSize << endl;


	int kernelSize = windowSize / 2;
	int minimum=999,maximum=-999;
	for (int y = 1; y < rows - 1; y++) {
		for (int x = 1; x < cols - 1; x++) {
			for (int k = -kernelSize; k <= kernelSize; k++) {
				for (int j = -kernelSize; j <= kernelSize; j++) {
					if (minMax == true)
						minimum = min(inputTensor[j + 1][k + 1],
								inputTensor[y - j][x - k]);
					else
						maximum = max(inputTensor[j + 1][k + 1],
								inputTensor[y - j][x - k]);
				}
			}
			if (minMax == true)
				outputTensor[y][x] = minimum;
			else
				outputTensor[y][x] = maximum;

		}
	}
}

void Net::filterConvolve(int windowSize) {
	cout << "\n\nConvolution function \n\n";
	int sum;
	int kernelSize = windowSize / 2;
	for (int y = 1; y < rows - 1; y++) {
		for (int x = 1; x < cols - 1; x++) {
			sum = 0;
			for (int k = -kernelSize; k <= kernelSize; k++) {
				for (int j = -kernelSize; j <= kernelSize; j++) {
					sum = sum
							+ inputTensor[j + 1][k + 1]
									* inputTensor[y - j][x - k];
				}
			}
			outputTensor[y][x] = sum;
		}
	}
}

int main() {
	Net net(3, 6);
	net.printArray();
	net.relulayer();
	net.printArray();
	net.poolingFunction(3, 3, false);
	net.printArray();
	net.filterConvolve(3);
	net.printArray();

	return 0;
}

