; INSTRUCTIONS ##########################################
;Sublime-Text Autocomplete Adder
;By Avi Aryan
;
;Place in it in directory of Sublime-Text.exe
;Tested with Sublime-Text 2
;Absolutely No guarranty
;Make sure to create a backup before going
;Dont worry about Duplicates, they will not be added again.
;########################################################
;Write your completes in listed form, one auto-complete in a line.
;
;You can also drag files which has list of auto-completes to get its
;contents.
;########################################################
;See Also - http://www.autohotkey.com/board/topic/91066-sublime-4-autohotkey/
;########################################################
 
SetWorkingDir, %a_scriptdir%
SetBatchLines, -1
 
;SETTINGS **********************************
CompletionPath = Autohotkey.sublime-completions
 
;********************************************
Gui, Font, S12 CRed, Verdana
Gui, Add, Text, x2 y0 w490 h30 , Drag a file in Edit Box below to load its completetions.
Gui, Add, Text, x2 y30 w490 h20 , Note - The Contents of Edit Field will not be overwritten
Gui, Add, Text, x3 y60 w490 h30 , You can add you Custom list also - one word/line
Gui, Add, Text, x2 y90 w500 h30 , Duplicates will not be added
Gui, Font, S10 CBlack, Verdana
Gui, Add, Edit, x2 y130 w490 h420 vlist,
Gui, Add, Button, x192 y560 w90 h30 , Add
Gui, Show, w501 h597, Avis Sublime-Text Autocomplete Adder
return
 
GuiClose:
ExitApp
 
ButtonAdd:
IfExist, %CompletionPath%
{
FileRead,filetoadd,%Completionpath%
FileCopy,%CompletionPath%,%A_WorkingDir%/Old_Completions.sublime-completions,1
 
StringGetPos,closingbracket,filetoadd,],R
StringLeft,firstpart,filetoadd,%closingbracket%
StringTrimLeft,secondpart,filetoadd,%closingbracket%
StringGetPos,posofcurly,firstpart,},R
posofcurly+=1
StringLeft,firstpart,firstpart,%posofcurly%
firstpart = %firstpart%,
 
Gui,submit,nohide
 
loop,parse,list,`n
{
StringReplace,loopsave,a_loopfield,",,All    						;Dont use " in completions
IfNotEqual,loopsave
	IfNotInString,firstpart,{ "trigger": "%loopsave%"
		firstpart = %firstpart%`r`n%a_tab%%a_tab%{ "trigger": "%loopsave%", "contents": "%loopsave%" },
}
 
StringTrimright,firstpart,firstpart,1
filetoadd = %firstpart%`r`n%secondpart%
FileDelete,%Completionpath%
FileAppend,%filetoadd%,%Completionpath%
MsgBox, 64, Hello, Completions Added!`n`nA backup of original file created as --`nOld_Completions.sublime-completions
filetoadd = 
firstpart = 
secondpart = 
GuiControl,,list,
}
else
	MsgBox, 16, WTF, Listen the file doesnt exist !`nSee your settings.
return
 
GuiDropFiles:
Loop, parse, A_GuiEvent, `n
{
    FileRead,contents,%a_loopfield%
    Break
}
Gui, submit, nohide
GuiControl,,list,%list%`n%contents%
return
