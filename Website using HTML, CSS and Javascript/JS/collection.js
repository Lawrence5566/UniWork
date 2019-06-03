//information for products is got from their actual displayed product info

var initialListOfItems = $('#collection');
var initialItems = initialListOfItems.children('li').get();

$(document).ready(function(){			//on document ready
	var initialListOfItems = $('#collection');				//gets initial list of items
	var initialItems = initialListOfItems.children('li').get();
	
	typeFilter = $("#typeFilter");
	priceFilter = $("#priceFilter");
	sortFilter = $("#sortFilter");
	sortItems(sortFilter,initialItems,initialListOfItems); //sort items initially depending on starting filters
	
	typeFilter.change(function(){		//event listener on selects
		sortItems(sortFilter,initialItems,initialListOfItems);
	});
	priceFilter.change(function(){		//event listener on selects
		sortItems(sortFilter,initialItems,initialListOfItems);
	});
	sortFilter.change(function(){		//event listener on selects
		sortItems(sortFilter,initialItems,initialListOfItems);
	});
	
});
	
function sortItems(sortFilter,initialItems,initialListOfItems){
	var noItemsHeader = $("#noItems").css("display","none");		//hides "no items" sign before filtering
	var listOfItems = initialListOfItems;
	var items = initialItems;
	
	items.sort(function(a,b){	////list is sorted into order to display(filter)
		var A = parseFloat($(a).find(".price").text().substring(1));	//substring removes '£' from price
		var B = parseFloat($(b).find(".price").text().substring(1));	//parseFloat converts string to float 
		var C = $(a).find(".productName").text();
		var D = $(b).find(".productName").text();
	
		if(sortFilter.val() == "price-ascending"){
			return (A < B) ? -1 : (A > B) ? 1 : 0;		//if, else if, else condensed to 1 line
		}
		else if(sortFilter.val() == "price-descending"){
			return (A > B) ? -1 : (A < B) ? 1 : 0;
		}
		else if(sortFilter.val() == "title-ascending"){
			return (C < D) ? -1 : (C > D) ? 1 : 0;
		}
		else if(sortFilter.val() == "title-descending"){
			return (C > D) ? -1 : (C < D) ? 1 : 0;
		}
		else{
			return 0;
		}
	});
	
	items	= items.filter(filterByType);		//filter items
	items = items.filter(filterByPrice);
	
	listOfItems.empty(); 	//empty ul ready to add only filtered items
	
	$.each(items, function(idx, itm){
	listOfItems.append(itm); });
	
	
	if (items.length == 0){		//if list is empty, display - "no products to display"
		noItemsHeader.css('display','block');
	}
	
	eventListeners(); 		//calls event listeners from "shoppingCart.js" to re-add event listeners after sorting
}

function filterByType(element){	
	//console.log(typeFilter.val());
	var type = $(element).find(".type").text();
	if (type == typeFilter.val()){		//if type is the same as type filter value
		//return type == typeFilter.val();
		return true;
	}
	else if (typeFilter.val() == "All"){
		return true;
	}
	else{
		return false;
	}
}

function filterByPrice(element){	
	var price = $(element).find(".price").text().substring(1);
	
	if (priceFilter.val() == "under 100"){		//if price is in price range
		return price <= 100;
	}
	else if (priceFilter.val() == "100-250"){
		return price > 100 && price <= 250		
	}
	else if (priceFilter.val() == "250-500"){
		return price > 250 && price <= 500;	
	}
	else if (priceFilter.val() == "over 500"){
		return price > 500;
	}
	else if (priceFilter.val() == "All"){
		return element;
	}
		
}