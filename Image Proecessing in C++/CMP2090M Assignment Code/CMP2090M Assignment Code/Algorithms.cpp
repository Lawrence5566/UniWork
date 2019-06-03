#include "ImageHandling.h"

Image* algorithms::mean(int maxWidth, int maxHeight) {

	imageHandle handle; //create on stack as its deleted when function closes anyway
	Image *NewImage = new Image(maxWidth, maxHeight); //creates a new image, same size as others

	std::cout << std::endl;
	std::cout << "finding mean..." << std::endl;
	std::cout << std::endl;

	for (int i = 0; i < 13; i++) {
		//load in a image:
		Image *curImage = handle.readPPM(("Images/ImageStacker_set1/IMG_" + std::to_string(i + 1) + ".ppm").c_str()); //.c_str converts to const char* / char array

		//add all pixels to new image, as a running total:
		for (int n = 0; n < (maxWidth*maxHeight); ++n) {	//for each pixel i of NewImage, sizeof won't work here.
			NewImage->pixels[n] += curImage->pixels[n];
		}

		delete curImage; //delete the image that was loaded in ready for the next one

		std::cout << "image " << i << " added to mean" << std::endl;
	}

	std::cout << "calculating mean..." << std::endl;
	//after all images have been done, calculate mean:
	for (int i = 0; i < (maxWidth*maxHeight); ++i) {	//for each pixel i of NewImage, sizeof won't work here.
		NewImage->pixels[i] /= 13.0f;
	} 

	std::cout << "done!" << std::endl;
	return NewImage;	//return by value, the new image (most optimal way) as newImage is destroyed when function exits and stops 'dangling' pointer
}

Image* algorithms::median(int maxWidth, int maxHeight) {
	imageHandle handle;
	std::vector<float> allRedValues;	//can't store them all in a rbg vector as STL::sort won't work on them
	std::vector<float> allBlueValues;
	std::vector<float> allGreenValues;

	Image *NewImage = new Image(maxWidth, maxHeight);

	std::cout << std::endl;
	std::cout << "finding median..." << std::endl;
	std::cout << std::endl;

	std::vector<Image*> images;
	std::cout << "loading images..." << std::endl;
	for (int i = 0; i < 13; i++) {
		//load in a image:
		Image *curImage = handle.readPPM(("Images/ImageStacker_set1/IMG_" + std::to_string(i + 1) + ".ppm").c_str()); //.c_str converts to const char*
		images.push_back(curImage);
	}

	std::cout << "reading values..." << std::endl;

	for (int i = 0; i < (maxWidth*maxHeight); ++i) {
		std::vector<Image*>::iterator it;
		for (it = images.begin(); it != images.end(); it++) { //for each image n in images vector
			allRedValues.push_back((*it)->pixels[i].r); // all red values for i pixel
			allBlueValues.push_back((*it)->pixels[i].b); //add to sum all red values for i pixel
			allGreenValues.push_back((*it)->pixels[i].g); //add to sum all red values for i pixel
		}

		std::sort(allRedValues.begin(), allRedValues.end());		//sort floats
		std::sort(allBlueValues.begin(), allBlueValues.end());
		std::sort(allGreenValues.begin(), allGreenValues.end());

		NewImage->pixels[i].r = allRedValues[((allRedValues.size() + 1) / 2) - 1];		//return median value
		NewImage->pixels[i].b = allBlueValues[((allBlueValues.size() + 1) / 2) - 1];
		NewImage->pixels[i].g = allGreenValues[((allGreenValues.size() + 1) / 2) - 1];

		allRedValues.clear();		//empty vectors
		allBlueValues.clear();
		allGreenValues.clear();
	}
	for (int i = 0; i < 13; i++) {		//release dynamic memory
		delete images[i];
	}

	std::cout << "done!" << std::endl;
	return NewImage;	//return by value, the new image (most optimal way) as newImage is destroyed when function exits and stops 'dangling' pointer

}

Image* algorithms::sigma(int maxWidth, int maxHeight) {		//might have to load al the images in to save going through all the pixels more than 13 times
	imageHandle handle;
	Image *NewImage = new Image(maxWidth, maxHeight); //creates a image same size as others, maybe this should be a empty image?(for memory space optimization)
	Image *stdDev = new Image(maxWidth, maxHeight);

	std::cout << std::endl;
	std::cout << "finding sigma..." << std::endl;
	std::cout << std::endl;

	std::vector<Image*> images;
	Image *meanImg = mean(maxWidth, maxHeight);		//get a mean image for reference

	std::cout << "calculating standard deviation..." << std::endl;
	for (int i = 0; i < 13; i++) {
		//load in a image:
		Image *curImage = handle.readPPM(("Images/ImageStacker_set1/IMG_" + std::to_string(i + 1) + ".ppm").c_str()); //.c_str converts to const char*
		images.push_back(curImage);

		for (int n = 0; n < (maxWidth*maxHeight); ++n) {	//for each pixel i of stdDev, sizeof won't work here.
			Image::Rgb tempPixel = curImage->pixels[n] - meanImg->pixels[n];
			stdDev->pixels[n] += tempPixel.sqr();  //store running mean in stdDev
		}
	}

	std::cout << "rejecting values... " << std::endl;

	for (int i = 0; i < (maxWidth*maxHeight); ++i) {	//for each pixel i of newImage
		stdDev->pixels[i] /= 13; //setting newimage pixels to mean of deviations
		stdDev->pixels[i].sqrt(); //square root to find standard dev
		//stdDev pixel rgb value now holds standard dev
		
		Image::Rgb min = stdDev->pixels[i] * 2.45f; //sigma is 2.45 here
		min = meanImg->pixels[i] - min;
		Image::Rgb max = stdDev->pixels[i] * 2.45f;
		max += meanImg->pixels[i];

		Image::Rgb pixelCount(0.f,0.f,0.f);
		std::vector<Image*>::iterator it;
		for (it = images.begin(); it != images.end(); it++) {	//reject values
			if ((*it)->pixels[i].r <= max.r && (*it)->pixels[i].r >= min.r) { //within range, therefore include
				NewImage->pixels[i].r += (*it)->pixels[i].r;		//add to running mean
				pixelCount.r++;
			}
			if ((*it)->pixels[i].b <= max.b && (*it)->pixels[i].b >= min.b) {
				NewImage->pixels[i].b += (*it)->pixels[i].b;
				pixelCount.b++;
			}
			if ((*it)->pixels[i].g <= max.g && (*it)->pixels[i].g >= min.g) {
				NewImage->pixels[i].g += (*it)->pixels[i].g;
				pixelCount.g++;
			}
		}
		NewImage->pixels[i] /= pixelCount;		//divide running mean by the number of values added to find mean
	}

	delete stdDev;
	delete meanImg;
	for (int i = 0; i < 13; i++) {		//release dynamic memory
		delete images[i];
	}

	return NewImage;
}

ZoomImage* algorithms::zoom(int ZoomAmount) {

		std::cout << std::endl;
		std::cout << "calculating zoom..." << std::endl;
		std::cout << std::endl;

		imageHandle handle;
		Image *oldImage = handle.readPPM("Images/Zoom/zIMG_1.ppm");

		int oldWidth = oldImage->h;		//get the original image dimensions
		int oldHeight = oldImage->w;

		int newWidth = oldWidth*ZoomAmount;
		int newHeight = oldHeight*ZoomAmount;
		ZoomImage *NewImage = new ZoomImage(newWidth, newHeight);

		NewImage->setZoomAmount(ZoomAmount);
		NewImage->setZoomType("Nearest Neighbour");

		float Xratio = oldWidth / (float)newWidth; //in this case scale ratios are the same
		float Yratio = oldHeight / (float)newHeight;
		float x, y;
		for (int i = 0; i < newHeight; i++) {
			for (int j = 0; j < newWidth; j++) {
				x = std::floor(j * Xratio);			//find x and y of current pixel to scale to
				y = std::floor(i * Yratio);
				NewImage->pixels[(i*newWidth) + j] = oldImage->pixels[(int)((y*oldWidth) + x)];
			}
		}

		delete oldImage;
		return NewImage;
}

ZoomImage* algorithms::BiLinZoom(int ZoomAmount) {
	std::cout << std::endl;
	std::cout << "calculating bilinear scaling zoom..." << std::endl;
	std::cout << std::endl;

	imageHandle handle;
	Image *oldImage = handle.readPPM("Images/Zoom/zIMG_1.ppm");

	int oldWidth = oldImage->h;		//get the original image dimensions
	int oldHeight = oldImage->w;

	int newWidth = oldWidth*ZoomAmount;
	int newHeight = oldHeight*ZoomAmount;
	ZoomImage *NewImage = new ZoomImage(newWidth, newHeight);

	NewImage->setZoomAmount(ZoomAmount);
	NewImage->setZoomType("Bilnear scaling");

	int x, y, index;
	int newImagePixelPos = 0;
	float x_ratio = ((float)(oldWidth - 1)) / newWidth;
	float y_ratio = ((float)(oldHeight - 1)) / newHeight;
	float x_diff, y_diff, blue, red, green;
	
	for (int i = 0; i < newHeight; i++) {
		for (int j = 0; j < newWidth; j++) {
			x = (int)(x_ratio * j);
			y = (int)(y_ratio * i);
			x_diff = (x_ratio * j) - x;
			y_diff = (y_ratio * i) - y;
			index = (y*oldWidth + x);
			Image::Rgb a = oldImage->pixels[index];		//pick 4 positions
			Image::Rgb b = oldImage->pixels[index + 1];
			Image::Rgb c = oldImage->pixels[index + oldWidth];
			Image::Rgb d = oldImage->pixels[index + oldWidth + 1];

			//scale up
			//use formula: Y = A(1-w)(1-h) + B(w)(1-h) + C(h)(1-w) + D(wh)
			red = a.r*(1 - x_diff)*(1 - y_diff) + b.r*(x_diff)*(1 - y_diff) +
				c.r*(y_diff)*(1 - x_diff) + d.r*(x_diff*y_diff);

			blue = a.b*(1 - x_diff)*(1 - y_diff)  +  b.b*(x_diff)*(1 - y_diff) +
				c.b*(y_diff)*(1 - x_diff) + d.b*(x_diff*y_diff);

			green = a.g*(1 - x_diff)*(1 - y_diff)  +  b.g*(x_diff)*(1 - y_diff) +
				c.g*(y_diff)*(1 - x_diff)  +  d.g*(x_diff*y_diff);

			NewImage->pixels[newImagePixelPos].r = red;
			NewImage->pixels[newImagePixelPos].b = blue;
			NewImage->pixels[newImagePixelPos].g = green;
			newImagePixelPos++;		//increment offset

		}
	}


	delete oldImage;
	return NewImage;
}