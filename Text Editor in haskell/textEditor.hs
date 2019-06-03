
--cursor is referred to in the comments. This is the position between left and right strings

import System.IO.Unsafe (unsafePerformIO) --used to convert impure input to pure function

data TextEditor = TextEditor String String String String deriving (Show) --left, highlighted, right, clipboard 

--delete highlighted string and put it on clipboard
cut :: TextEditor -> TextEditor
cut (TextEditor l h r c) = TextEditor l [] r h         

--paste clipboard string on to the end of left string
paste :: TextEditor -> TextEditor
paste (TextEditor l h r c) = TextEditor (l++c) [] r c  ----paste clipboard, & clear highlighted string if not empty

--deletes a string that is highlighted or backspaces the character to the left
backspace :: TextEditor -> TextEditor
backspace (TextEditor [] h r c) = TextEditor [] h r c --can't backspace anything, as nothing is to the left of the cursor
backspace (TextEditor l [] r c) = TextEditor (init l) [] r c 
backspace (TextEditor l h r c)  = TextEditor l [] r c                   --remove the highlighted string

--deletes a string that is highlighted or backspaces the character to the right using pattern matching
backspaceForward  :: TextEditor -> TextEditor
backspaceForward (TextEditor l h [] c) = TextEditor l h [] c 
backspaceForward (TextEditor l [] r c) = TextEditor l [] (tail r) c 
backspaceForward (TextEditor l h r c)  = TextEditor l [] r c               

--copys a highlighted string to clipboard
copy :: TextEditor -> TextEditor
copy (TextEditor l h r c) = TextEditor l h r h

--writes a string to the left of cursor
write :: String -> TextEditor -> TextEditor
write x (TextEditor l h r c) = TextEditor (l++x) h r c 

--highlights one string to the left of the cursor (or highlighted string)
highlightCharLeft :: TextEditor -> TextEditor
highlightCharLeft (TextEditor [] h r c) = TextEditor [] h r c
highlightCharLeft (TextEditor l h r c) = TextEditor (init l) ([last l]++h) r c

highlightCharRight :: TextEditor -> TextEditor
highlightCharRight (TextEditor l h [] c) = TextEditor l h [] c
highlightCharRight (TextEditor l h r c) = TextEditor l (h++[head r]) (tail r) c

--highlights the next word to the left (ignores spaces)
highlightWordLeft :: TextEditor -> TextEditor
highlightWordLeft  (TextEditor [] h r c) = TextEditor [] h r c
highlightWordLeft  (TextEditor l h r c)
    |last l == ' ' && h == " " = highlightWordLeft (TextEditor (init l) h ([last l]++r) c) --removes initial space between next word and cursor
    |last l == ' ' && h == []  = highlightWordLeft (TextEditor (init l) h ([last l]++r) c) --removes initial space between next word and cursor
    |last l == ' '             = TextEditor l h r c                                        --space found
    |otherwise                 = highlightWordLeft (highlightCharLeft(TextEditor l h r c)) --highlight one character then move keep going

highlightWordRight :: TextEditor -> TextEditor --will the text editor use other special characters than space?
highlightWordRight  (TextEditor l h [] c) = TextEditor l h [] c
highlightWordRight  (TextEditor l h r c)
    |head r == ' ' && h == " " = highlightWordRight (TextEditor (l++[head r]) h (tail r) c) 
    |head r == ' ' && h == []  = highlightWordRight (TextEditor (l++[head r]) h (tail r) c) 
    |head r == ' '             = TextEditor l h r c
    |otherwise                 = highlightWordRight (highlightCharRight(TextEditor l h r c)) 

highlightAllLeft :: TextEditor -> TextEditor
highlightAllLeft (TextEditor l h r c) = TextEditor [] (l++h) r c

highlightAllRight :: TextEditor -> TextEditor
highlightAllRight (TextEditor l h r c) = TextEditor l (h++r) [] c

highlightAll :: TextEditor -> TextEditor
highlightAll (TextEditor l h r c) = TextEditor [] (l++h++r) [] c

clearHighlighted :: TextEditor -> TextEditor
clearHighlighted (TextEditor l h r c) = TextEditor (l++h) [] r c

moveCursorLeft :: TextEditor -> TextEditor
moveCursorLeft (TextEditor l h r c) = TextEditor (init l) [] ([last l]++h++r) c --also clears highlighted when you move cursor

moveCursorRight :: TextEditor -> TextEditor
moveCursorRight (TextEditor l h r c) = TextEditor (l++h++[head r]) [] (tail r) c --also clears highlighted when you move cursor

moveCursorWordStart :: TextEditor -> TextEditor
moveCursorWordStart (TextEditor [] h r c) = TextEditor [] h r c 
moveCursorWordStart (TextEditor l [] r c) 
    |last l == ' ' = TextEditor l [] r c
    |otherwise = moveCursorWordStart (TextEditor (init l) [] ([last l]++r) c)
moveCursorWordStart (TextEditor l h r c) =  moveCursorWordStart (TextEditor (l++h) [] r c)   --make sure highlighted is cleared when moving cursor

moveCursorWordEnd :: TextEditor -> TextEditor
moveCursorWordEnd (TextEditor l h [] c) = (TextEditor l h [] c)
moveCursorWordEnd (TextEditor l [] r c)  
    |head r == ' ' = TextEditor l [] r c
    |otherwise     = moveCursorWordEnd (TextEditor (l++[head r]) [] (tail r) c)
moveCursorWordEnd (TextEditor l h r c) =  moveCursorWordEnd (TextEditor (l++h) [] r c) --if highlighted isn't empty, recurse and clear it

moveCursorStart :: TextEditor -> TextEditor
moveCursorStart (TextEditor l h r c) = TextEditor [] [] (l++h++r) c

moveCursorEnd :: TextEditor -> TextEditor
moveCursorEnd (TextEditor l h r c) = TextEditor (l++h++r) [] [] c

save :: TextEditor -> String -> IO ()  --saves a single string to a text file
save (TextEditor l h r c) filepath = writeFile filepath (l++h++r)

load :: String -> TextEditor   --loads a string from a text file
load x = TextEditor (unsafePerformIO (readFile x)) [] [] [] 














