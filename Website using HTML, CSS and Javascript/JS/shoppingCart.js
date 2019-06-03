
obj = getStore();
var cartArray = obj.cart;
var totalCost = obj.total;

$(document).ready(function(){
	$(".addToBasketBtn").click(function(){
		var productName = $(this).parent().find('.productName').text();
		var price = $(this).parent().find('.price').text().substring(1);
		addProduct(productName,price)		//add to cart	
	});
	
	$("#clearCart").click(function(){				//event listener on button click
		emptyArray = [];
		store(emptyArray,0);						//empty localstorage cart
		cartArray = [];								//empty cart array
		totalCost = 0;								//empty cost variable
		$("tbody").empty();							//empty table
		$("#total").html('Total: £' + totalCost);	//empty total
	});
	
	eventListeners();
});

function eventListeners(){
	$('.item').draggable({
		revert:true,							//makes product go back to original position after being dropped
		helper:'clone',							//creates clone to move on top of product
		drag: resizeContainer,
		refreshPositions: true
	});
	
	$(".cart").droppable({
		hoverClass: "ui-state-hover",
		drop: function(event,ui){				//on drop
			var productName = $(ui.draggable).find('.productName').text();
			var price = $(ui.draggable).find('.price').text().substring(1);
			
			addProduct(productName,price)		//add to cart
		}
	});
	
	displayTable(cartArray,totalCost);			//displays table initially
}

function resizeContainer(e, ui){
	$(ui.helper).width(200);
	$(ui.helper).height(260);
}

function addProduct(productName,price){
	item = {
		productName:productName,
		price:price,
		quantity:1
	};
	
	if (containsObject(item, cartArray)){		//if true, item already in cart
		$.each(cartArray, function(){			//foreach item in cartArray
			if (this.productName == item.productName){
				this.quantity += 1;
				this.price = parseInt(this.price) + parseInt(item.price);
			}
		});
    }
	else{
		//added to cartArray
		cartArray.push(item);					//add to cart array
	}
	
	totalCost += parseInt(item.price);
	
	displayTable(cartArray,totalCost);
	store(cartArray,totalCost);					//store into localstorage
}

function displayTable(cartArray,totalCost){
	$("tbody").empty();							//wipe table
	
	$.each(cartArray,function(index,item){		//display array as table
		var newRow = "<tr>"
			+ "<td>" + item.productName + "</td>"		//productName
			+ "<td>" + item.quantity + "</td>"		//Price
			+ "<td>" + item.price + "</td>"		//quantity
			+ "</tr>";
		$("#tbody").append(newRow);				//add to body of table
	});
	$("#total").html('Total: £' + totalCost); 	//amend total
}

function containsObject(obj, array) {
    var i;
    for (i = 0; i < array.length; i++) {
        if (array[i].productName == obj.productName) {
            return true;
        }
    }

    return false;
}

function store(cartArray,totalCost){
	var storingObject = {cart : cartArray, total : totalCost}
	JSONstore = JSON.stringify(storingObject);
	localStorage.setItem("cartStore", JSONstore);
}

function getStore(){
	text = localStorage.getItem("cartStore");
	if (text === null){
		emptyArray = [];
		//returns empty object if localstorage is empty
		var loadingObject = {cart: emptyArray,total: 0};
		return loadingObject;
	}
	else{
		var loadingObject = JSON.parse(text);
		return loadingObject;
	}
}