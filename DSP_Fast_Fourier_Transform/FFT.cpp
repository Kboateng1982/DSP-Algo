// Basic implementation of Cooley-Tukey FFT algorithm in C++
// An easy way to build the FFT that works. This is not the Area or speed efficient-way to program the FFT
// We will use a recursive method to program the FFT Algorithm. 
// The function will recursively split all of the discrete-time domain samples until we have only one sample left and then work backwards 
// Through each level, combining the values until we arrive at our Frequency Bins. 
// * https://rosettacode.org/wiki/Fast_Fourier_transform#C++ */ https://cplusplus.com/forum/general/265589/


#include <complex>
#include <iostream>
#include <valarray>
using namespace std;

const double PI = 3.141592653589793238460;

typedef complex<double> Complex;
typedef valarray<Complex> CArray;

// Cooley–Tukey FFT (in-place, divide-and-conquer)
// Higher memory requirements and redundancy although more intuitive
// We create an FFT function whose input is a complex vector
void fft(CArray& x)
{
    // Find the number of samples we have 
    const size_t N = x.size();
    if (N <= 1) return;

    // Step 1: We find half the total number of samples 	
    int M = N / 2;

    // Stept 2: We split the samples into even and odd subsums 
    CArray even = x[slice(0, M, 2)];
    CArray  odd = x[slice(1, M, 2)];

    // Step 3: Perform the recursive FFT on the Even and Odd subsamples 
    fft(even);
    fft(odd);
    //*  The Recursion Step end here *//

    // Step 4. The vector x stores and combines all of the frequency bins 
    for (size_t k = 0; k < M; ++k)
    {
        // Step 5: For each split set, we need to multiply a k-dependent complex number by the odd subsums
        Complex t = polar(1.0, -2 * PI * k / N) * odd[k];
        x[k] = even[k] + t;

        // Step 6: Everytime you add PI, the complex exponential changes sign
        x[k + M] = even[k] - t;
    }
}

// inverse fft (in-place)
void ifft(CArray& x)
{
    // conjugate the complex numbers
    x = x.apply(conj);

    // forward fft
    fft(x);

    // conjugate the complex numbers again
    x = x.apply(conj);

    // scale the numbers
    x /= x.size();
}

int main()
{
    const Complex test[] = { 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0 };
    CArray data(test, 8);

    // forward fft
    fft(data);

    cout << "fft" << endl;
    for (int i = 0; i < 8; ++i)
    {
        cout << data[i] << endl;
    }

    // inverse fft
    ifft(data);

    cout << endl << "ifft" << endl;
    for (int i = 0; i < 8; ++i)
    {
        cout << data[i] << endl;
    }
    return 0;
}