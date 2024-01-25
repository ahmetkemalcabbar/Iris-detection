# Iris-detection

Step-1 : Input Human Eye color image. 


![image](https://github.com/ahmetkemalcabbar/Iris-detection/assets/110349401/161bc2de-b4ca-4f78-9ba2-b4c6353fab8f)



Step-2: Convert RGB image into grey.


![image](https://github.com/ahmetkemalcabbar/Iris-detection/assets/110349401/c33e0afa-5662-457f-a3b1-e24ef1416fbe)



Step-3: Finds the iris and pupil circle.

First, we soften the grey-scale image with a Gauss filter. The reason we do this is to get better results. For the Gaussian filter, we take the sigma value to be 3.


![image](https://github.com/ahmetkemalcabbar/Iris-detection/assets/110349401/f53f457b-1a23-40ac-a8df-c08a702d8159)



Then, we apply the Canny edge detection function to the image to which we applied the Gauss filter and detect the edges in the image.


![image](https://github.com/ahmetkemalcabbar/Iris-detection/assets/110349401/ee39167a-6deb-4e4d-a531-0d931153e262)



Then, Circular Hough Transform is applied to the Canny binary image and the circle of the iris and pupil is determined.

The center location is same for both circles. 

While detecting circles, function min and max radius values are given. The purpose of this is to shorten the processing time by narrowing the processing area.

The circles are then displayed on the original image. We do this with the showCircules function.


<img width="331" alt="image" src="https://github.com/ahmetkemalcabbar/Iris-detection/assets/110349401/27248447-dc23-404c-bb5f-f0836dce1934">


Step-4: Unwraps the iris.
Then, using Daugman Rubber Sheet Modal, we transform the iris into a rectangular image.
Here, this process is applied to both the color image and the black-and-white image, and an unwrapped image is created accordingly.


![image](https://github.com/ahmetkemalcabbar/Iris-detection/assets/110349401/a959e31e-bfa6-49e6-aafa-dec4b599db8e)



Step-5: Saves the unwrapped image.
Finally, the output image is saved to the file path entered when calling the function.
.pgm --> grayscale image
.ppm --> rgb image

Inputs:
- url_of_input_image,
- min_radius,
- max_radius, 
- directory_url_of_output_images 

Outputs:
- Shows the Iris and Pupil circle on the original image
- Saves the unwrapped image to the specified file location



<img width="331" alt="image" src="https://github.com/ahmetkemalcabbar/Iris-detection/assets/110349401/cda856b5-5115-4028-9dc3-62b895e03185">


