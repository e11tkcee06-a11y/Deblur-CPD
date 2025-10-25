# Fast Blind Image Deblurring Based on Cross Partial Derivative #
MATLAB implementation of CPD based blind image deblurring

**Abstract:** In this paper, based on second-order cross-partial derivative (CPD), we propose an efficient blind image deblurring algorithm for uniform blur. The proposed method consists of two stages. We first apply a novel blur kernel estimation method to quickly estimate the blur kernel. Then, we use the estimated kernel to perform non-blind deconvolution to restore the image. A key discovery of the proposed kernel estimation method is that the blur kernel information is usually embedded in the cross-partial-derivative (CPD) image of the blurred image. By exploiting this property, we propose a pipeline to extract a set of kernel candidates directly from the CPD image and then select the most suitable kernel as the estimated blur kernel. Since our kernel estimation method can obtain a fairly accurate blur kernel, we can achieve effective image restoration using a relatively simple Tikhonov regularization in the subsequent non-blind deconvolution process. To improve the quality of the restored image, we further adopt an efficient filtering technique to suppress periodic artifacts that may appear in the restored images. Experimental results demonstrate that our algorithm can efficiently restore high-quality sharp images on standard CPUs without relying on GPU acceleration or parallel computation. For blurred images of approximately $800\times800$ resolution, the proposed method can complete image deblurring within 1 to 5 seconds, which is significantly faster than most state-of-the-art methods.

## Demo ##

A. The program is currently executable and is for academic use only.

B. Executable file: Demo_CPD_v01.m

C. Recommended Matlab version: 2019a or later

D. Instructions for Use

    Step 1: Select a test image in the "Image Index" section.
    
    Step 2: In the "Parameter" section,
            a. Determine the number of candidates (default is 5).
            b. Specify which candidate to use as the estimated kernel (default is 1).

    Step 3: Run the program.

E. Folder Description:

    1. Test Image: Places the test image.
    
    2. Parameter: Places the parameter file (.xlsx) used for the test image.
    
    3. Function: Places the sub-functions used by the algorithm.

p.s. Because the description and explanation of the sub-functions are not yet complete, we have initially released the .p file for readers' reference. 
     We will complete the description and explanation of the sub-functions as soon as possible and gradually release the .m file for readers' reference.
