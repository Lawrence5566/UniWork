
#include "ImageHandling.h"	//imageHandling also includes image.h

int main(){
	std::cout << "************************************" << std::endl;
	std::cout << "Image Stacker / Image Scaler" << std::endl;
	std::cout << "************************************" << std::endl;

	imageHandle handle;			//create image handle object, using automatic storage allocation
	algorithms algorithmObj;
	
	//calcualte and return mean
	Image *MeanImageBlend = algorithmObj.mean(3264, 2448);
	handle.writePPM(*MeanImageBlend, "meanPPM.ppm"); //write to file
	delete MeanImageBlend;				//release memory

	//calcualte and return median
	Image *MeadianImageBlend = algorithmObj.median(3264, 2448);
	handle.writePPM(*MeadianImageBlend, "MedianPPM.ppm");
	delete MeadianImageBlend;

	//calcualte and return sigma and output logfile
	Image *SigmaImageBlend = algorithmObj.sigma(3264, 2448);
	handle.writePPM(*SigmaImageBlend, "SigmaPPM.ppm");
	SigmaImageBlend->displayInfo();
	delete SigmaImageBlend;

	//zoom image x2 and output info to log file
	ZoomImage *zoomImage = algorithmObj.zoom(2); //pass in zoom amount
	handle.writePPM(*zoomImage, "2xZoomPPM.ppm");
	zoomImage->displayInfo();
	delete zoomImage;

	//zoom image x4 and output info to log file
	ZoomImage *zoomImage2 = algorithmObj.zoom(4);
	handle.writePPM(*zoomImage2, "4xZoomPPM.ppm");
	zoomImage2->displayInfo();
	delete zoomImage2;
	
	//zoom image x2 using bilinear
	ZoomImage *zoomImage3 = algorithmObj.BiLinZoom(2);
	handle.writePPM(*zoomImage3, "2xBilnZoomPPM.ppm");
	zoomImage3->displayInfo();
	delete zoomImage3;

	system("pause");
	return 0;
}
