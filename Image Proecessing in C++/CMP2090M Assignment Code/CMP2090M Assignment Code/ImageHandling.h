#include "image.h"
#include <sstream>
#include <vector>
#include <algorithm>

class imageHandle {
public:
	Image* readPPM(const char* file);
	void writePPM(Image &img, const char* file);
	void writePPM(ZoomImage &img, const char* file);
};

class algorithms {
public:
	Image* mean(int maxWidth, int maxHeight);
	Image* median(int maxWidth, int maxHeight);
	Image* sigma(int maxWidth, int maxHeight);
	ZoomImage* zoom(int ZoomAmount);
	ZoomImage* BiLinZoom(int ZoomAmount);
};