/*stores const values from image class, in header file would lead to a multiply defining 
values because all files that include the header will generate a value.
Instead, definitions are moved to single cpp file*/

#include "Image.h"

const Image::Rgb Image::kBlack = Image::Rgb(0);
const Image::Rgb Image::kWhite = Image::Rgb(1);
const Image::Rgb Image::kRed = Image::Rgb(1, 0, 0);
const Image::Rgb Image::kGreen = Image::Rgb(0, 1, 0);
const Image::Rgb Image::kBlue = Image::Rgb(0, 0, 1);

const Image::Rgb ZoomImage::kBlack = Image::Rgb(0);
const Image::Rgb ZoomImage::kWhite = Image::Rgb(1);
const Image::Rgb ZoomImage::kRed = Image::Rgb(1, 0, 0);
const Image::Rgb ZoomImage::kGreen = Image::Rgb(0, 1, 0);
const Image::Rgb ZoomImage::kBlue = Image::Rgb(0, 0, 1);