--use "let t = TextEditor "" "" "" "" "
--then "highlightall t" etc to use the text editor

--remember to test for errors? - ask alex, you might not need to

--cursor is referred to in the comments, this is the position between left and right strings

data TextEditor = TextEditor String String String String deriving (Show) --left, highlighted, right, clipboard 

--delete highlighted string and put it on clipboard
cut :: TextEditor -> TextEditor
cut (TextEditor l h r c) = TextEditor l [] r h         

--paste clipboard string on to the end of left string
paste :: TextEditor -> TextEditor
paste (TextEditor l h r c) = TextEditor (l++c) h r c  

--copys a highlighted string to clipboard
copy :: TextEditor -> TextEditor
copy (TextEditor l h r c) = TextEditor l h r h

--deletes a char to the left
backspace :: TextEditor -> TextEditor
backspace (TextEditor l h r c) = TextEditor (init l) h r c

--deletes char to the right
backspaceForward :: TextEditor -> TextEditor
backspaceForward (TextEditor l h r c) = TextEditor l h (tail r) c

--writes a string to the left of cursor
write :: String -> TextEditor -> TextEditor
write x (TextEditor l h r c) = TextEditor (l++x) h r c 

--highlights one string to the left of the cursor (or highlighted string)
highlightCharLeft :: TextEditor -> TextEditor
highlightCharLeft (TextEditor [] h r c) = TextEditor [] h r c
highlightCharLeft (TextEditor l h r c) = TextEditor l ([last l]++h) r c

highlightCharRight :: TextEditor -> TextEditor
highlightCharRight (TextEditor l h [] c) = TextEditor l h [] c
highlightCharRight (TextEditor l h r c) = TextEditor l (h++[head r]) r c

--highlights the rest of the word to the left
highlightWordLeft :: TextEditor -> TextEditor
highlightWordLeft  (TextEditor [] h r c) = TextEditor [] h r c
highlightWordLeft  (TextEditor l h r c)
    |head (reverse l) == ' '             = TextEditor (l++h) h r c --space found, add highlight back on string and return
    |otherwise                           = highlightWordLeft (TextEditor (init l) ([last l]++h) r c) 

highlightWordRight :: TextEditor -> TextEditor 
highlightWordRight  (TextEditor l h [] c) = TextEditor l h [] c
highlightWordRight  (TextEditor l h r c)
    |head r == ' '             = TextEditor l h r c
    |otherwise                 = highlightWordRight (TextEditor l (h++[head r]) (tail r) c) 

highlightAllLeft :: TextEditor -> TextEditor
highlightAllLeft (TextEditor l h r c) = TextEditor l (l++h) r c

highlightAllRight :: TextEditor -> TextEditor
highlightAllRight (TextEditor l h r c) = TextEditor l (h++r) r c

highlightAll :: TextEditor -> TextEditor
highlightAll (TextEditor l h r c) = TextEditor l (l++r) r c

clearHighlight :: TextEditor -> TextEditor
clearHighlight (TextEditor l h r c) = TextEditor (l++h) [] r c

moveCursorLeft :: TextEditor -> TextEditor
moveCursorLeft (TextEditor l h r c) = TextEditor (init l) h ([last l]++r) c --also clears highlighted when you move cursor

moveCursorRight :: TextEditor -> TextEditor
moveCursorRight (TextEditor l h r c) = TextEditor (l++[head r]) h (tail r) c --also clears highlighted when you move cursor

moveCursorWordStart :: TextEditor -> TextEditor
moveCursorWordStart (TextEditor l h r c) 
    |head (reverse l) == ' ' = TextEditor l h r c
    |otherwise = TextEditor (init l) h ([last l]++r) c

moveCursorWordEnd :: TextEditor -> TextEditor
moveCursorWordEnd (TextEditor l h r c)  
    |head r == ' ' = TextEditor l h r c
    |otherwise     = TextEditor (l++[head r]) h (tail r) c

moveCursorStart :: TextEditor -> TextEditor
moveCursorStart (TextEditor l h r c) = TextEditor (l++r) h [] c

moveCursorEnd :: TextEditor -> TextEditor
moveCursorEnd (TextEditor l h r c) = TextEditor [] h (l++r) c

save :: TextEditor -> String -> IO ()
save (TextEditor l h r c) filepath = writeFile filepath (l++r)

--load :: String -> TextEditor
--load filepath = do 
--    contents <- readFile filepath
--	return (TextEditor contents [] [] [])
--	
--loadString :: IO () -> TextEditor










