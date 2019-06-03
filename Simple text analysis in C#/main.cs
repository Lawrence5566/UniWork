using System;
using System.Linq; 					//for .Contains
using System.Collections.Generic; 	//for List<T> (generic lists)
using System.IO; 					//to read from text file

class TextAnalyzer{
	public static void Main(){
		bool endOfInput = false;								
		List<string> inputStringList = new List<string>();		//stores all the input strings for option1
		string inputText;
		
		Console.WriteLine("1. Do you want to enter the text via the keyboard?");
		Console.WriteLine("2. Do you want to read in the text from a file?");
		Console.WriteLine("enter a '1' for option 1 and '2' for option 2: ");
		string userInput = Console.ReadLine();
		
		userInput = Validate(userInput);
		
		if (Convert.ToInt32(userInput) == 1){      //option 1
			Console.Write("input string, enter a * to stop input: ");
			do{
				inputText = Console.ReadLine();
				if (inputText.Contains("*")){
					endOfInput = true;	
					inputText = inputText.Remove(inputText.IndexOf("*"));//removes the "*" from the string so that its not counted in the text
				}
				inputStringList.Add(inputText);
			} while (endOfInput == false);
			inputText = String.Join(" ",inputStringList);				//combine all strings
		}
	    else{       //option2
			inputText = string.Join(" ",File.ReadAllLines("TextFile.txt"));  //read lines so that return characters are ignored (lines need to turn into string)
		} 
		
		AnalyzeText(inputText);			//function that analyses a string given to it
		CreateLongWords(inputText);		//function that creates long words text file
		AnalyzeTextMood(inputText);		//function that determines the mood of the text
		Console.ReadLine();
	}
	
	
	public static string Validate(string userInput){		//validates users input to ensure a y or n is pressed
		int userInputInt;
		bool valid = false;
		while (valid == false){		
			try{		//check to make sure you can convert string to int
				userInputInt = Convert.ToInt32(userInput);
				
				if (userInputInt != 1 && userInputInt !=2 ){	//check to make sure a 1 or 2 is entered
					Console.Write("enter a '1' for option 1 and '2' for option 2: ");
					userInput = Console.ReadLine();
				}
				else{
					valid = true;
				}
			}
			catch(Exception){
				Console.Write("enter a '1' for option 1 and '2' for option 2: ");
				userInput = Console.ReadLine();
			}
			
		}
		return userInput;
	}
	
	
	public static void AnalyzeText(string userInput){
		char[] vowels = "aeiou".ToCharArray();		//used arrays due to fixed length
		char[] Consonants = "bcdfghjklmnpqrstvwxyz".ToCharArray();
		char[] lowerLetters = "abcdefghijklmnopqrstuvwxyz".ToCharArray();
		char[] upperLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".ToCharArray();
		List<char> listOfLetters = new List<char>(); 	//create empty "generic" list, list needed as length alters
		int numberOfVowels = 0;
		int numberOfConsonants = 0;
		int numberOfUpperCase = 0;
		int numberOfLowerCase = 0;
		int numberOfSentances = 0;
		
		foreach (char i in userInput){ //loop through string
			if (vowels.Contains(char.ToLower(i))){  //if i is in vowels
				numberOfVowels += 1;
			}
			if (Consonants.Contains(char.ToLower(i))){
				numberOfConsonants += 1;
			}
			if (upperLetters.Contains(i)){ 
				numberOfUpperCase += 1;
				listOfLetters.Add(char.ToLower(i)); //add letter to list of letters
			}
			if (lowerLetters.Contains(i)){
				numberOfLowerCase += 1;
				listOfLetters.Add(i); 				//add letter to list of letters
			}
			if (i == Convert.ToChar(".") || i == Convert.ToChar("!") || i == Convert.ToChar("?")){		//".","!","?" denotes the end of a sentance
				numberOfSentances += 1;
			}
		}
		
		if (numberOfSentances == 0){		//if no "." are entered
			numberOfSentances = 1;
		}
		
		numberOfSentances = numberOfSentances - findNonPeriods(userInput);		//subtracts all non periods found
		
		listOfLetters.Sort();
        listOfLetters.Add(Convert.ToChar("a"));		// adds a "a" at the end so program knows its come to end of array
		
        char prevLetter = Convert.ToChar(" ");      //prev letter needs to be set as "a" so the first letter doesnt compare to "blank"
        int noOfEachLetter = 1;     //i kept these variables here as this is the only place i will use them and keeps it tidy?
        
		Console.WriteLine("Frequency of each letter in the text: ");
		foreach(char i in listOfLetters){    //loop through sorted list of all letters
			if (i == prevLetter){
                noOfEachLetter += 1;         //keep track of number of same letters
            }
            else if (i != prevLetter && prevLetter != Convert.ToChar(" ")){             //therefore letter has changed (" " bit in is for first runthrough, when prevLetter is just " "(blank))
				Console.WriteLine("no. of {0}'s = {1} ",prevLetter,noOfEachLetter);
				noOfEachLetter = 1;       
			}
            prevLetter = i;
        }
		
		Console.WriteLine("number of sentances: {0}", numberOfSentances);
		Console.WriteLine("number of vowels: {0}", numberOfVowels);
		Console.WriteLine("number of consonants: {0}", numberOfConsonants);
		Console.WriteLine("number of upper case letters: {0}", numberOfUpperCase);
		Console.WriteLine("number of lower case letters: {0}", numberOfLowerCase);
	}
	
	public static int findNonPeriods(string userInput){		//returns a number of non period periods.
		int nonSentanceClosers = 0;			//keeps track of non sentance closers
		char prevChar = Convert.ToChar(" ");
		userInput = userInput + " ";		//adds a " "(space) to the end of the string so that the last "." can be picked up
		foreach (char i in userInput){
			if (i != Convert.ToChar(" ")){
				if (prevChar == Convert.ToChar(".") || prevChar == Convert.ToChar("!") || prevChar == Convert.ToChar("?")){
					nonSentanceClosers += 1;
				}
			}
			prevChar = i;
		}

		return nonSentanceClosers;
	}
	
	public static void CreateLongWords(string userInput){
		List<string> listOfLongWords = new List<string>();
		List<char> wordLetters = new List<char>();		//list of letters that will form a word
		char[] wordSymbols = "abcdefghijklmnopqrstuvwxyz'-".ToCharArray(); //(list of all characters that can be in a word)
		int wordLength = 0;
		
		foreach (char i in userInput){
			if (wordSymbols.Contains(char.ToLower(i))){
				wordLetters.Add(i);
				wordLength += 1;
			}
			else{		//therefore character isn't one that normaly in a english word
				//end of word, now need to check if the words a long one:
				if (wordLength >= 7){
					listOfLongWords.Add(String.Join("", wordLetters));		// "" is joining character
				}
				wordLetters.Clear();		//wipe word
				wordLength = 0;
			}	
		}
		
		string[] arrayOfLongWords = listOfLongWords.ToArray();		//need to convert genric list to array to write to file
		File.WriteAllLines("long words.txt", arrayOfLongWords);
	}
	
	public static void AnalyzeTextMood(string userInput){		//returns the positivity of the text
		string[] listOfWords; 		//this will contain all the words in the text
		List<char> newUserInput = new List<char>();  		//will contain all character in user input that are not special characters
		char[] nonSpecialChars = "abcdefghijklmnopqrstuvwxyz'- ".ToCharArray(); //list of non special characters
		List<string> positiveWords =  new List<string>(File.ReadAllLines("PositiveWords.txt"));
		List<string> negativeWords = new List<string>(File.ReadAllLines("NegativeWords.txt"));
		
		int Positivity = 0;
		int noOfsentimentWords = 0;
		
		foreach (char i in userInput){ 		//need to remove ?,!,. so that the words dont contain them in the list.
			if (nonSpecialChars.Contains(char.ToLower(i))){
				newUserInput.Add(char.ToLower(i));		//every char needs to be lower case so no words have upper case
			}
		}
		
		userInput = string.Join("", newUserInput.ToArray());		//turns char list to array then combines array to form one string
		listOfWords = userInput.Split(' '); 		//splits the string on every " "(space) into string list
		
		foreach (string word in listOfWords){		//compare each word to list of positive words
			if (positiveWords.Contains(word)){
				Positivity += 1;
				noOfsentimentWords += 1;
			}
			if (negativeWords.Contains(word)){
				Positivity -= 1;
				noOfsentimentWords += 1;
			}
		}
		Console.WriteLine("\nThe positivity of the text has a rating of {0}", Positivity);
		Console.WriteLine("higher values makes the text more positive, while lower makes it more negative");
		Console.WriteLine("this value is in proportion with how many neg&pos words used");
		if (Positivity == 0){
			Console.WriteLine("Therefore The text is neutral");
		}
		else if (Positivity >= noOfsentimentWords/4 || -(Positivity) >= noOfsentimentWords/4){			//then very positive/neg
			Console.Write("Therefore The text is very ");
			if (Positivity > 0){
				Console.Write("positive");
			}
			else{
				Console.Write("negative");
			}
		}
		else if (Positivity >= noOfsentimentWords/8 || -(Positivity) >= noOfsentimentWords/8){ 		//then positive/neg
			Console.Write("Therefore The text is ");
			if (Positivity > 0){
				Console.Write("positive");
			}
			else{
				Console.Write("negative");
			}
		}
		else{
			Console.WriteLine("Therefore The text is neutral");
		}
	}
}