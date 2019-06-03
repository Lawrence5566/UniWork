using System;
using System.IO;
using System.Collections.Generic;
using System.Linq;
using System.Globalization;

public enum months{ January,February,March,April,May,June,July,
	August,September,October,November,December};

class anaylser{
	public static void Main(){
		List<string> fileNames = new List<string>();	//creating list of array names
		List<List<string>> data1 = new List<List<string>>();
		List<List<string>> data2 = new List<List<string>>();
		List<item> dataItems1 = new List<item>();		//for region1
		List<item> dataItems2 = new List<item>();		//for region2
		List<item> dataItems3 = new List<item>();		//for merge
		List<item> dataItems = new List<item>();
		
		string currentDir = Directory.GetCurrentDirectory() + "/files"; //get directory of where the files are
		string[] longFileNames = Directory.GetFiles(currentDir); //gets names of all files in directory
		foreach(string file in longFileNames){	//ensures only file name is added to fileNames. not whole path
			fileNames.Add(Path.GetFileName(file));
		}
		
		foreach(string fileName in fileNames){ //foreach file in dir,
			string filepath = "files/" + fileName;
			List<string> currentFile = new List<string>();
			foreach (string line in File.ReadLines(filepath)){	//foreach line in file
					currentFile.Add(line);	//add to temp array
				}
			if (fileName.Contains("1")){	//add temp array to data1 or data2
				data1.Add(currentFile);
			}
			else{
				data2.Add(currentFile);
			}
		}
		
		//currently have 2 2D arrays containing 11 600 item arrays.
		
		for(int i=0; i < 600; i++){	//creating 600 item objects for data1
			item newItem = new item(
			Convert.ToInt32(data1[0][i]),
			Convert.ToDouble(data1[1][i]),
			Convert.ToInt32(data1[2][i]),
			Convert.ToDouble(data1[3][i]),
			Convert.ToDouble(data1[4][i]),
			Convert.ToDouble(data1[5][i]),
			(months) Enum.Parse(typeof(months), data1[6][i]), //month
			data1[7][i].Replace(",",""), //removes commas from regions
			Convert.ToDouble(data1[8][i]), //timestamp
			data1[9][i], //time
			Convert.ToInt32(data1[10][i]));
			
			dataItems1.Add(newItem);
			dataItems3.Add(newItem); //adds to "merge" array
		}
		
		for(int i=0; i < 600; i++){	//creating 600 item objects for data2
			item newItem = new item(
			Convert.ToInt32(data2[0][i]),
			Convert.ToDouble(data2[1][i]),
			Convert.ToInt32(data2[2][i]),
			Convert.ToDouble(data2[3][i]),
			Convert.ToDouble(data2[4][i]),
			Convert.ToDouble(data2[5][i]),
			(months) Enum.Parse(typeof(months), data2[6][i]),
			data2[7][i].Replace(",",""), //removes commas from regions 
			Convert.ToDouble(data2[8][i]), //timestamp
			data2[9][i], //time
			Convert.ToInt32(data2[10][i]));
			
			dataItems2.Add(newItem);
			dataItems3.Add(newItem);
		}
		
		// main code steps //
		
		Console.WriteLine("select region to work with, or 3 for merge(1/2/3): ");
		while (true){
			string userInput = Console.ReadLine();
			if (userInput == "1"){ //add in a merge option here somewhere 
				dataItems = dataItems1;
				break;
			}
			else if (userInput == "2"){
				dataItems = dataItems2;
				break;
			}
			else if (userInput == "3"){
				dataItems = dataItems3;
				break;
			}
			else{
				Console.WriteLine("please enter a 1/2/3: ");
			}
		}
		
		// sorting single array(others move with it)  //
		Console.WriteLine("select an array to sort");
		string key = selectArray();
		displayArray(dataItems, key); 	//before sorting
		sort(dataItems, key);	//user selects an array, and it is sorted
		displayArray(dataItems, key); //after sorting
		
		// searching arrays //
		Console.WriteLine("--------------------------------");
		Console.WriteLine("Next, select an array to search by: ");
		key = selectArray();
		searchBy(dataItems,key);
		
		// min and max values //
		Console.WriteLine("--------------------------------");
		Console.WriteLine("Next, select an array of which to find min and max values: ");
		key = selectArray();
		minMax(dataItems, key);
		
		Console.ReadLine();
		
	}
	
	public static string selectArray(){//user can select array to sort
		Console.WriteLine("which array would you like to select?");
		Console.WriteLine("day");
		Console.WriteLine("depth");
		Console.WriteLine("IRIS");
		Console.WriteLine("lat");
		Console.WriteLine("lng");
		Console.WriteLine("mag");
		Console.WriteLine("month");
		Console.WriteLine("region");
		Console.WriteLine("timestamp");
		Console.WriteLine("time");
		Console.WriteLine("year");
		Console.WriteLine("----------------------------");
		
		string[] names = new string[]{"day","depth","IRIS","lat","lng","mag","month","region",
		"timestamp","time","year"};
		while (true){
			string userInput = Console.ReadLine();
			if (names.Contains(userInput)){
				return userInput;
			}
			else{
				Console.WriteLine("please enter exactly as they appear");
			}
		}
	}
	
	public static void displayArray(List<item> array,string key){ //displays any single array
		Console.WriteLine("");
		foreach (item i in array){ //printing the days, sorted for testing
			Console.Write(i.getFromSortKey(key));
			Console.Write(", ");
		}
	}
	
	public static void sort(List<item> dataItems, string key){ //decides what sort method to call based on key
		Console.WriteLine("what order? ASCE/DESC: ");
		string order;
		while(true){
			order = Console.ReadLine();
			if (order == "ASCE" || order == "DESC"){
				break;
			}
			else{
				Console.WriteLine("enter either ASCE/DESC: ");
			}
		}
		
		quicksort(dataItems, 0, dataItems.Count-1, key);
		
		if (order == "DESC"){	//reorder array for decending
			for (int i = 0; i < dataItems.Count() / 2; i++){
			   item temp = dataItems[i];
			   dataItems[i] = dataItems[dataItems.Count() - i - 1];
			   dataItems[dataItems.Count() - i - 1] = temp;
			}
		}
	}
	
	public static void quicksort(List<item> array, int left, int right, string key){
		if (left < right){
			int pivot = Part(array, left, right, key);
			quicksort(array, left, pivot - 1, key);
			quicksort(array, pivot + 1, right,key);
		}
	}
	
	public static int Part(List<item> array, int left, int right, string key){
		Random rnd = new Random();
		int pivotIndex = rnd.Next(left,right);
		item pivot = array[pivotIndex]; //pivot chosen randomly, this is to reduce n^2 time compleixty chance
		int leftwall = left;

		for (int i = left; i <= right; i++){
			double l;	//array[i].getFromSortKey(key)
			double j;	//pivot.getFromSortKey(key))
			
			if (key == "month"){ //if key is month, convert values to month, then to doubles
				months n = (months) Enum.Parse(typeof(months), array[i].getFromSortKey(key)); //convert month string to months enum
				months r = (months) Enum.Parse(typeof(months), pivot.getFromSortKey(key));
				l = Convert.ToDouble(n);
				j = Convert.ToDouble(r);
			
			}
			else if(key == "time"){ //if key is time, convert time string to double
				string[] temp = array[i].getFromSortKey(key).Split(':');
				l = double.Parse(temp[0]) + double.Parse(temp[1])/60 + double.Parse(temp[2])/6000;
				temp = pivot.getFromSortKey(key).Split(':');
				j = double.Parse(temp[0]) + double.Parse(temp[1])/60 + double.Parse(temp[2])/6000;
			}
			else if (key == "region"){
				//compare string method changes l acordingly
				l = compareStrings(array[i].getFromSortKey(key), pivot.getFromSortKey(key));
				j = 2;
			}
			else{ //normal quicksort
				l = Convert.ToDouble(array[i].getFromSortKey(key));
				j = Convert.ToDouble(pivot.getFromSortKey(key));
			}
			
			if (l < j){
				//swap A[i] & A[leftwall]
				item temp = array[i];
				array[i] = array[leftwall];
				array[leftwall] = temp;
				leftwall += 1;
			}
		}
		array[leftwall] = pivot;

		return (leftwall);
	}
	
	public static double compareStrings(string st1, string st2){
		//return 1 if st1 < st2, otherwise return 3
		st1 = st1.Replace(" ",""); //removes spaces
		st2 = st2.Replace(" ","");
		st1 = st1.Replace("-",""); //removes dashes
		st2 = st2.Replace("-","");
		
		int n;
		if (st1.Length > st2.Length){	//find the shortest string and set it to 1 char longer, so that a proper comparison can be made
			st2 = st2+" "; //" " is smaller than any alphabet character
			n = st2.Length;
		}
		else if (st1.Length < st2.Length){
			st1 = st1+" ";
			n = st1.Length;
		}
		else{ //strings are same length
			n = st1.Length;
		}
	
		int st1Char = 0;
		int st2Char = 0;
		
		for (int i=0; i <= n-1; i++){ 	//cycle through each char in shortest string
			st1Char = Convert.ToInt32(st1[i]); 	//cast char to ascii int
			st2Char = Convert.ToInt32(st2[i]);
			if (st1Char < st2Char){		//if true, alphabetically, st1 comes first
				return 1.0;
			}
			else if (st2Char < st1Char){
				return 3.0;
			}
		}
		
		return 4.0; 		//they are the same word
	}
	
	public static void searchBy(List<item> dataItems, string key){
		string value;
		
		Console.WriteLine("input a {0} value to search by: ", key);
		value = validateInput(key);
		quicksort(dataItems, 0, dataItems.Count - 1, key); //sort items first by the key
		int index = binarySearch(dataItems, value, key, 0, dataItems.Count - 1); //search for index of one of the items
		
		//now finding and displaying all those that match the value searched for:
		if (index == -1){
			Console.WriteLine("not present in array");
		}
		else{
			int left = index;
			int right = index;

			while (dataItems[left].getFromSortKey(key) == dataItems[index].getFromSortKey(key)){
				//left bound not found
				left -= 1;
				if (left < 0){
					//index out of range (too small)
					break;
				}
			}
			//left bound found 
			left += 1;
			
			while (dataItems[right].getFromSortKey(key) == dataItems[index].getFromSortKey(key)){
				//right bound not found
				right += 1;
				if (right == dataItems.Count){
					//index out of range (too large)
					break;
				}
			}
			//right bound found 
			right -= 1;
			
			Console.WriteLine("displaying: year,month,day,time,mag,lat,lng,depth,region,IRIS,timestamp");
			for (int i = left; i <= right; i++){
				dataItems[i].printValues();
			}
			
		}
	}
	
	public static int binarySearch(List<item> array, string value, string key, int min, int max){ //returns index of item in array       
		double valueDouble = 0.0;
	   
		if (min > max){
			return -1; //not present in array
		}
		else{
			int midpoint = min + (max - min)/2;
			string midpointItemString = array[midpoint].getFromSortKey(key);
			double midpointInArray = 0.0;
			
			if (key == "month"){ //if key is month, convert values to month, then to doubles
					months  midpointitemMonth = (months) Enum.Parse(typeof(months), midpointItemString); //convert month string to months enum
					months monthValue = (months) Enum.Parse(typeof(months), value); //convert value string into month
					midpointInArray = Convert.ToDouble(midpointitemMonth); //convert to double
					valueDouble = Convert.ToDouble(monthValue);
				}
			else if(key == "time"){ //if key is time, convert time string to double
				string[] temp = midpointItemString.Split(':');
				string[] valueTemp = value.Split(':');
				midpointInArray = double.Parse(temp[0]) + double.Parse(temp[1])/60 + double.Parse(temp[2])/6000;
				valueDouble = double.Parse(valueTemp[0]) + double.Parse(valueTemp[1])/60 + double.Parse(valueTemp[2])/6000;
			}
			else if (key == "region"){
				double conditionNumber = compareStrings(midpointItemString, value); //returns 1 if array[bound] < value, 4 if they are equal
				if (conditionNumber == 4.0){                    
					return midpoint; 				//returns index of found item
				}
				else if (conditionNumber == 3.0){	//value is in lower subarray
					return binarySearch(array, value, key,min, midpoint - 1);
				}
				else{								//value is in upper sub array
					return binarySearch(array, value, key,midpoint + 1, max);
				}
			}
			else{ //if property of object is double or int
				midpointInArray = Convert.ToDouble(midpointItemString);
				valueDouble = Convert.ToDouble(value);
			}

			// check to see if value is equal to item in array
			if (valueDouble == midpointInArray && key != "region"){                    
				return midpoint; //returns index of found item
			}
			else if (valueDouble < midpointInArray && key != "region"){ //value is in lower subarray
				return binarySearch(array, value, key,min, midpoint - 1);
			}
			else if (key != "region"){ //value is in upper sub array
				return binarySearch(array, value, key,midpoint + 1, max);
			}
		}
		
		return 0;
	}
	
	public static void minMax(List<item> dataItems, string key){
		quicksort(dataItems, 0, dataItems.Count - 1, key); //sort by the key first
		int n = 0;
		Console.WriteLine("min values: ");
		while (dataItems[n].getFromSortKey(key) == dataItems[n+1].getFromSortKey(key)){
			//while item in array is the same as the one after it
			dataItems[n].printValues();
			n += 1;
		}
		dataItems[n].printValues(); //prints n, as while loop breaks if the one after is not the same
	
		n = dataItems.Count() - 1; //index of last value
		Console.WriteLine("max values: ");
		while (dataItems[n].getFromSortKey(key) == dataItems[n-1].getFromSortKey(key)){
			//while item in array is the same as the one after it
			dataItems[n].printValues();
			n -= 1;
		}
		dataItems[n].printValues(); 
	}
	
	public static string validateInput(string key){
		CultureInfo timeFormat = new CultureInfo("en-US");
		string userInput = "";
		while (true){
			userInput = Console.ReadLine();
			if (key == "month"){
				if (months.IsDefined(typeof(months), userInput)){
					break;
				}
				else{
					Console.WriteLine("please enter a month: ");
				}
			}
			else if (key == "region"){
				break;
				}
			else if (key == "time"){
				if (userInput.Length != 8){
					Console.WriteLine("please enter time in XX:XX:XX format: ");
				}
				else{
					try{
						userInput = TimeSpan.Parse(userInput, timeFormat).ToString();
						break;
					}
					catch{
						Console.WriteLine("please enter a correct time in XX:XX:XX format: ");
					}
				}
			}
			else{//all ints and doubles
				try{
					Convert.ToDouble(userInput);
					break;
				}
				catch{
					Console.WriteLine("please enter in the correct format: ");
				}
			}
		}
		return userInput;
	}
}

class item{
	int day { get; set; }
	double depth { get; set; }
	int IRIS { get; set; }
	double lat { get; set; }
	double lng { get; set; }
	double mag { get; set; }
	months month { get; set; }
	string region { get; set; }
	string time { get; set; }
	double timestamp { get; set; }
	int year { get; set; }
	
	public item(int day1,double depth1,int IRIS1,double lat1,double lng1,double mag1,months month1,string region1,double timestamp1,string time1,int year1){
		day = day1;
		depth = depth1;
		IRIS = IRIS1;
		lat = lat1;
		lng = lng1;
		mag = mag1;
		month = month1;
		region = region1;
		timestamp = timestamp1;
		time = time1;
		year = year1;
	}
	
	public string getFromSortKey(string key){
		switch(key){
			case "day":
				return Convert.ToString(day);
			case "IRIS":
				return Convert.ToString(IRIS);
			case "year":
				return Convert.ToString(year);
			case "depth":
				return Convert.ToString(depth);
			case "lat":
				return Convert.ToString(lat);
			case "lng":
				return Convert.ToString(lng);
			case "mag":
				return Convert.ToString(mag);
			case "timestamp":
				return Convert.ToString(timestamp);
			case "month":
				return Convert.ToString(month);
			case "region":
				return region;
			case "time":
				return time;
			default:
				return "";
		}
	}
	
	public void printValues(){
		Console.WriteLine("{0},   {1},   {2},   {3},   {4},   {5},   {6},   {7},   {8},   {9},   {10}",
		year,month,day,time,mag,lat,lng,depth,region,IRIS,timestamp );
	}
}