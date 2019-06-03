var typeImages = [
	"images/Lancelot/LancelotType.png",
	"images/Typhoon/TyphoonType.png"
];

var lancelotSeatImages = [
	"images/Lancelot/LancelotSeatWhite.png",
	"images/Lancelot/LancelotSeatBlue.png",
	"images/Lancelot/LancelotSeatGreen.png",
	"images/Lancelot/LancelotSeatRed.png",
	"images/Lancelot/LancelotSeatYellow.png"
];

var lancelotWheelsImages = [
	"images/Lancelot/LancelotWheelsWhite.png",
	"images/Lancelot/LancelotWheelsBlue.png",
	"images/Lancelot/LancelotWheelsGreen.png",
	"images/Lancelot/LancelotWheelsRed.png",
	"images/Lancelot/LancelotWheelsYellow.png"
];

var lancelotBodyImages = [
	"images/Lancelot/LancelotBodyWhite.png",
	"images/Lancelot/LancelotBodyBlue.png",
	"images/Lancelot/LancelotBodyGreen.png",
	"images/Lancelot/LancelotBodyRed.png",
	"images/Lancelot/LancelotBodyYellow.png"
];

var typhoonSeatImages = [
	"images/Typhoon/TyphoonTypeSeatWhite.png",
	"images/Typhoon/TyphoonTypeSeatBlue.png",
	"images/Typhoon/TyphoonTypeSeatGreen.png",
	"images/Typhoon/TyphoonTypeSeatRed.png",
	"images/Typhoon/TyphoonTypeSeatYellow.png"
];

var typhoonWheelsImages = [
	"images/Typhoon/TyphoonTypeWheelsWhite.png",
	"images/Typhoon/TyphoonTypeWheelsBlue.png",
	"images/Typhoon/TyphoonTypeWheelsGreen.png",
	"images/Typhoon/TyphoonTypeWheelsRed.png",
	"images/Typhoon/TyphoonTypeWheelsYellow.png"
];

var typhoonBodyImages = [
	"images/Typhoon/TyphoonTypeBodyWhite.png",
	"images/Typhoon/TyphoonTypeBodyBlue.png",
	"images/Typhoon/TyphoonTypeBodyGreen.png",
	"images/Typhoon/TyphoonTypeBodyRed.png",
	"images/Typhoon/TyphoonTypeBodyYellow.png"
];

var seatImages = lancelotSeatImages;				//set default to the lancelot
var seatIndex = 0;
var seatImage;

var wheelsImages = lancelotWheelsImages;				//set default to the lancelot
var wheelsIndex = 0;
var wheelsImage;

var bodyImages = lancelotBodyImages;				//set default to the lancelot
var bodyIndex = 0;
var bodyImage;

$(document).ready(function(){
	typeImage = $("#typeImg");
	seatImage = $("#seatImg");
	wheelsImage = $("#wheelsImg");
	bodyImage = $("#bodyImg");
	
	$("#TypeSelection").change(function(){
		console.log("selection changed")
		changeType();
	});
	
	$("#seatLeftBtn").click(function(){
		changeSeat(-1);
	});
	$("#seatRightBtn").click(function(){
		changeSeat(+1);
	});
	$("#wheelsLeftBtn").click(function(){
		changeWheels(-1);
	});
	$("#wheelsRightBtn").click(function(){
		changeWheels(+1);
	});
	$("#bodyLeftBtn").click(function(){
		changeBody(-1);
	});
	$("#bodyRightBtn").click(function(){
		changeBody(+1);
	});
	
	$("#saveBtn").click(function(){
		saveBike();
	});
	$("#loadBtn").click(function(){
		loadBike();
	});
	
	changeImages();
});

function changeImages()
{
	//set images
	seatImage.attr("src",seatImages[seatIndex]);
	wheelsImage.attr("src",wheelsImages[wheelsIndex]);
	bodyImage.attr("src",bodyImages[bodyIndex]);
}

function changeSeat(offset)
{
	//Find new offset
	var offsetIndex = (seatIndex + offset);
	
	//If negative, set index to the previous image:
	if(offsetIndex < 0)
		seatIndex = seatImages.length + offset;
	
	//else add offset and modulo by the length to "wrap around" the values
	else
		seatIndex = (seatIndex + offset) % seatImages.length;
	
	changeImages();
}

function changeWheels(offset)
{
	//Find new offset
	var offsetIndex = (wheelsIndex + offset);
	
	//If negative, set index to the previous image:
	if(offsetIndex < 0)
		wheelsIndex = wheelsImages.length + offset;
	
	//else add offset and modulo by the length to "wrap around" the values
	else
		wheelsIndex = (wheelsIndex + offset) % wheelsImages.length;
	
	changeImages();
}

function changeBody(offset)
{
	//Find new offset
	var offsetIndex = (bodyIndex + offset);
	
	//If negative, set index to the previous image:
	if(offsetIndex < 0)
		bodyIndex = bodyImages.length + offset;
	
	//else add offset and modulo by the length to "wrap around" the values
	else
		bodyIndex = (bodyIndex + offset) % bodyImages.length;
	
	changeImages();
}

function changeType(){
	if ($("#TypeSelection").val() == "Custom Lancelot"){
		typeImage.attr("src",typeImages[0]);		//set main image
		
		seatIndex = 0;								//reset indexs
		wheelsIndex = 0;
		bodyIndex = 0;
		
		seatImages = lancelotSeatImages;					//change image arrays
		wheelsImages = lancelotWheelsImages;
		bodyImages = lancelotBodyImages;
		
		changeImages();								//set bike
	}
	
	else if ($("#TypeSelection").val() == "Custom Tyhoon"){
		typeImage.attr("src",typeImages[1]);		//set main image
		
		seatIndex = 0;								//reset indexs
		wheelsIndex = 0;
		bodyIndex = 0;
		
		seatImages = typhoonSeatImages;				//change image arrays
		wheelsImages = typhoonWheelsImages;
		bodyImages = typhoonBodyImages;
		
		changeImages();								//set bike
	}
}

function saveBike(){
	localStorage.setItem("seatIndex" , seatIndex);
	localStorage.setItem("wheelsIndex" , wheelsIndex);
	localStorage.setItem("bodyIndex" , bodyIndex);
	localStorage.setItem("Type", $("#TypeSelection").val());
}

function loadBike(){
	var currentType = localStorage.getItem("Type");
	$("#TypeSelection").val(currentType);
	
	changeType()			//changeType() resets indexs therefore indexs must be loaded after
	
	seatIndex  = localStorage.getItem("seatIndex");
	wheelsIndex  = localStorage.getItem("wheelsIndex");
	bodyIndex  = localStorage.getItem("bodyIndex");
	
	changeImages();
}