var imgPos = 0;
var imgs = [];

$(document).ready(function(){
	imgs = $("img.slides");  //creates an array, and fills it with all images with 'slides' class
	changeImage(0);                     //called so that images(except first one) are hidden intially

	$("#slideshowCtrlButnLeft").click(function(){
		changeImage(1);
	});
	$("#slideshowCtrlButnRight").click(function(){
		changeImage(-1)
	});
});

function changeImage(x) {
    imgPos += x;                    //x will be either -1 or +1

	if (imgPos + 1 > imgs.length){		//if user goes beyond last img
		imgPos = 0;					//go to first img
	}
	if (imgPos < 0){					//if user goes before first img
		imgPos = imgs.length - 1;
	}
	
    for (let i = 0; i < imgs.length; i++) {
        imgs[i].style.display = "none";     //this hides all the images
    }
    imgs[imgPos].style.display = "block";   //this then displays the image we want to see
	
}