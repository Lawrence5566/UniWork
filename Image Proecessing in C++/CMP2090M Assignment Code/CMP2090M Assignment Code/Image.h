#pragma once
//*********************************************
//Image class to hold and allow manipulation of images once read into the code
//from https://www.scratchapixel.com/
//*********************************************
#include <cstdlib> 
#include <cstdio>
#include <cmath>
#include <string>
#include <iostream>
#include <fstream>


class Image{
protected:
	std::string filename;

public:
	// Rgb structure, i.e. a pixel 
	struct Rgb
	{
		Rgb() : r(0), g(0), b(0) {}
		Rgb(float c) : r(c), g(c), b(c) {}
		Rgb(float _r, float _g, float _b) : r(_r), g(_g), b(_b) {}
		bool operator != (const Rgb &c) const
		{
			return c.r != r || c.g != g || c.b != b;
		}
		Rgb& operator *= (const Rgb &rgb)
		{
			r *= rgb.r, g *= rgb.g, b *= rgb.b; return *this;
		}
		Rgb& operator += (const Rgb &rgb)
		{
			r += rgb.r, g += rgb.g, b += rgb.b; return *this;
		}
		Rgb& operator -= (const Rgb &rgb) //new operator overload added for subtracting
		{
			r -= rgb.r, g -= rgb.g, b -= rgb.b; return *this;
		}
		Rgb& operator - (const Rgb &rgb)	//new operator overload added for subtracting
		{
			Image::Rgb newRgb;
			newRgb.r = r - rgb.r, newRgb.g = g - rgb.g, newRgb.b = b - rgb.b; return newRgb;
		}
		Rgb& operator * (const float &coefficient)	//new operator overload added for multiplication
		{
			Image::Rgb newRgb;
			newRgb.r = r * coefficient, newRgb.g = g * coefficient, newRgb.b = b * coefficient; return newRgb;
		}
		Rgb& operator /= (const float &dividend) //new operator overload added for dividing
		{		//uses float as rbg are all floats
			r /= dividend, g /= dividend, b /= dividend; return *this;
		}
		Rgb& operator /= (const Rgb &rgb) //same as above but for 2 pixels
		{		//uses float as rbg are all floats
			r /= rgb.r, g /= rgb.g, b /= rgb.b; return *this;
		}

		friend float& operator += (float &f, const Rgb rgb)
		{
			f += (rgb.r + rgb.g + rgb.b) / 3.f; return f;
		}
		Rgb& sqr() //created this for squaring
		{
			r = r*r, g = g*g, b = b*b;  return *this;
		}
		void sqrt() //created this for square rooting
		{
			r = std::sqrt(r), g = std::sqrt(g), b = std::sqrt(b);
		}

		float r, g, b;
	};

	Image() : w(0), h(0), pixels(nullptr) { /* empty image */ }
	Image(const unsigned int &_w, const unsigned int &_h, const Rgb &c = kBlack) :
		w(_w), h(_h), pixels(NULL)
	{
		pixels = new Rgb[w * h];
		for (int i = 0; i < w * h; ++i)
			pixels[i] = c;
	}

	//copy constructor (PATCH 1)
	Image(const Image &im)
	{
		w = im.w;
		h = im.h;
		pixels = new Rgb[im.w * im.h];
		for (int i = 0; i < im.w * im.h; ++i)
			pixels[i] = im.pixels[i];
	}
	//copy assignment operator (PATCH 1)
	Image& operator=(const Image& other)
	{
		w = other.w;
		h = other.h;
		pixels = new Rgb[other.w * other.h];
		for (int i = 0; i < other.w * other.h; ++i)
			pixels[i] = other.pixels[i];

		return *this;
	}

	const Rgb& operator [] (const unsigned int &i) const
	{
		return pixels[i];
	}
	Rgb& operator [] (const unsigned int &i)
	{
		return pixels[i];
	}


	void setFileName(const char *fn) {
		filename = fn;
	}

	virtual void displayInfo() { //prints out image stats and writes it to log file, made virtual for inheritance
		std::cout << "filename: " << filename << std::endl;
		std::cout << "dimensions: " << w << " x " << h << std::endl;
		std::cout << "colour depth: true colour, 24bit" << std::endl;

		//write to log file:
		std::ofstream log_file;
		log_file.open("log_file_image_" + filename.substr(filename.find("IMG_") + 1) + ".txt", std::ofstream::out | std::ofstream::trunc);
		log_file << "filename: " << filename << " , "
			<< "dimensions: " << w << " x " << h << " , "
			<< "colour depth: true colour, 24bit" << std::endl;

		log_file.close();
	}


	~Image()
	{
		if (pixels != NULL) delete[] pixels;
		//delete[] pixels;
	}
	unsigned int w, h; // Image resolution 
	Rgb *pixels; // 1D array of pixels 
	static const Rgb kBlack, kWhite, kRed, kGreen, kBlue; // Preset colors 
};

class ZoomImage : public Image {
	std::string zoomAmount;
	std::string zoomType;
public:
	ZoomImage() : w(0), h(0), pixels(nullptr) { /* empty image */ }
	ZoomImage(const unsigned int &_w, const unsigned int &_h, const Rgb &c = kBlack) :
		w(_w), h(_h), pixels(NULL)
	{
		pixels = new Rgb[w * h];
		for (int i = 0; i < w * h; ++i)
			pixels[i] = c;
	}

	void setZoomAmount(int x) {
		zoomAmount = std::to_string(x);
	}

	void setZoomType(std::string zoomtype) {
		zoomType = zoomtype;
	}

	void displayInfo() {
		std::cout << "filename: " << filename << std::endl;
		std::cout << "dimensions: " << w << " x " << h << std::endl;
		std::cout << "colour depth: true colour, 24bit" << std::endl;
		std::cout << "zoom amount: " + zoomAmount << std::endl;
		std::cout << "zoom type: " + zoomType << std::endl;

		//write to log file:
		std::ofstream log_file;
		log_file.open("log_file_image_" + filename.substr(filename.find("IMG_") + 1) + ".txt", std::ofstream::out | std::ofstream::trunc);
		log_file << "filename: " << filename << " , "
		 << "dimensions: " << w << " x " << h << " , "
		 << "colour depth: true colour, 24bit" << " , "
		 << "zoom amount: " + zoomAmount << " , "
		 << "zoom type: " + zoomType << std::endl;

		log_file.close();
	}

	~ZoomImage()
	{
		if (pixels != NULL) delete[] pixels;
		//delete[] pixels;
	}

	unsigned int w, h; // Image resolution 
	Rgb *pixels; // 1D array of pixels 
	static const Rgb kBlack, kWhite, kRed, kGreen, kBlue; // Preset colors 
};