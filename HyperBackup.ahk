
; HyperBackup Changelog
; v1 - 5/1/16 - Initial Beta Release


#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; File types to save
FileTypes := Object()
FileTypes.Insert(".ini")
FileTypes.Insert(".xml")

; Window definition
Gui, Add, Text, x12 y9 w80 h20 , Source Folder :
Gui, Add, Edit, x92 y9 w330 h20 vSourceFolder, %A_ScriptDir%
Gui, Add, Button, x432 y9 w30 h20 , ...
Gui, Add, Button, x12 y39 w80 h40 , Backup
Gui, Add, Button, x102 y39 w90 h40 , Restore
Gui, Add, Text, x202 y39 w260 h40 , Backup all .XML and .INI files in a folder. Choose the folder to back up.
Gui, Show, x377 y225 h105 w483, Backup .XML and .INI files
Gui, Add, Text, x12 y89 w450 h20 vStatusResult,
Return

; Button events
Button...:
	; Save the input from the user to each control's associated variable.
	Gui, Submit, NoHide

	FileSelectFolder, chosenFolder, *%SourceFolder%, 3, Choose your path to HyperSpin
	chosenFolder := TrimPath(chosenFolder)
	If (StrLen(chosenFolder) <= 2) {
		MsgBox You cannot choose the root directory
	} else {
		GuiControl,, SourceFolder, %chosenFolder%
	}
	return

ButtonBackup:
	Gui, Submit, NoHide
	BackupFolder := GetBackupPath(SourceFolder)
	CopyFiles(FileTypes, SourceFolder, BackupFolder)

	SoundPlay *-1
	GuiControl,, StatusResult, Updated
	return

ButtonRestore:
	Gui, Submit, NoHide
	BackupFolder := GetBackupPath(SourceFolder)
	CopyFiles(FileTypes, BackupFolder, SourceFolder)

	SoundPlay *64
	GuiControl,, StatusResult, Restored
	return

GuiClose:
	ExitApp

; Support functions
TrimPath(inputPath)
{
	return RegExReplace(inputPath, "\\$")
}

GetBackupPath(inputPath)
{
	path := TrimPath(inputPath) . "_configBackup"
	return path
}

CopyFiles(fileTypes, source, destination)
{
	Loop % fileTypes.MaxIndex()
	{
		extension := fileTypes[A_Index]
		copyCommand = xcopy "%source%\*%extension%" "%destination%\" /S /Y /H /R
		RunWait %comspec% /c %copyCommand% 
	}
}