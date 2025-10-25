![MATLAB](https://img.shields.io/badge/language-MATLAB-blue)
![Status](https://img.shields.io/badge/Stage-Under_Review-orange)
![MIT License](https://img.shields.io/badge/license-MIT-green)

# CPD-Deblur

## Fast Blind Image Deblurring Based on Cross Partial Derivative

MATLAB implementation of CPD based blind image deblurring.

This repository provides the implementation and demo code for a blind image deblurring method based on cross partial derivative (CPD). The method estimates blur kernels from derivative responses and restores images using non-blind deconvolution.

> 📌 **Note:**  
> The associated paper is currently under peer review.  
> Citation information will be updated after acceptance.

---

## 🔍 Highlights
- 📌 Blind kernel estimation using CPD features  
- ⚡ Fast computation — CPU friendly   
- 📈 Works on real and synthetic motion-blurred images  

---

## 🎬 Demo

### MATLAB Script
Run the following file to reproduce the main results:
**Demo_CPD_v01.m**

### Steps
1. Choose the test image in the “Image Index” section.
2. Set number of kernel candidates in the “Parameter” section. (default: 5)  
3. Select one candidate for reconstruction in the “Parameter” section. (default: 1)  
4. Run and compare results  

---

## 🗂️ Folder Structure
CPD-Deblur/

  Function --- Sub-functions for CPD and kernel estimation

  Parameter --- Parameter settings (Excel format)
  
  Test Image --- Demo test images
  
  Demo_CPD_v01.m --- Main executable script
  
  f_00_Estimate_Kernel.m --- Main function: Estimate kernel
  
  f_00_Reconstruct_Image.m --- Main function: Non-blind deconvolution

---

## 📌 Requirements
- MATLAB **R2019a** or later
- No additional toolbox required

---

## ⚠️ Academic Use Only
This repository is shared for **peer-review** purposes and non-commercial academic use.  
Please do not redistribute without permission.

---

p.s. Because the description and explanation of the sub-functions are not yet complete, we have initially released the .p file for readers' reference. 
     We will complete the description and explanation of the sub-functions as soon as possible and gradually release the .m file for readers' reference.
