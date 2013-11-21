#SingleInstance force
;Delay time for hiding the notification windows
_DelayTime = 1000

;Opacity for the notification window
_NotiOpacity = 200
;Top coordinate of the notification windows
_NotiTop = 20

;INI settings
_iniFilename := "settings.ini"

;INI settings - web
_webHotKeyPrefix := "web_"
_webModeHotKeySection := _webHotKeyPrefix . "mode"
_webHotKeySection := _webHotKeyPrefix . "hotkey"
	;Array of webhotkeys
	;[hotkeys][var]
_arrayWebKeys := {}
_arrayWebName :={}
	;List of webhotkeys seperated by ,
_strWebHotKeys := ""

;INI settings - app
_appHotKeyPrefix := "app_"
_appModeHotKeySection := _appHotKeyPrefix . "mode"
_appHotKeySection := _appHotKeyPrefix . "hotkey"
_arrayAppPath := {}
_arrayAppName := {}
_strAppHotKeys := ""

;INI settings - settings
_settingsHotKeyPrefix := "settings_"
_settingsModeHotKeySection := _settingsHotKeyPrefix . "mode"
_settingsHotKeySection := _settingsHotKeyPrefix . "hotkey"
_strSettingsHotKeys := ""
_arraySettingsName := {}
_arraySettingsCommand := {}

;Modes keyword
_arrayModeKeyword := {}
_strAvailableModes := ""
;Control ID for the Notification
_NotificationID := ""

;Back one level msg
_strBackOneLevel := "`nPress backspace key to go back"
;Hide msg
_strQuit := "`nPress escape key to hide"

loadSettings()

^!+n::
{
	Loop
	{
		inputReturn := getUserInput(UserInput,"[ Mode Selection ]" . _strAvailableModes . _strQuit)
		userMode := _arrayModeKeyword[UserInput]
		if (inputReturn = "endkey:escape" || inputReturn = "endkey:backspace")
		{
			Break
		}
		if (userMode = "web_mode")
		{
			inputReturn := getUserInput(UserInput, "[ web_mode ]`n" . _strWebHotKeys . _strBackOneLevel . _strQuit)
			webURL := _arrayWebKeys[UserInput]
			if (inputReturn = "endkey:escape")
			{
				Break
			}
			if (webURL != "")
			{
				Run %webURL%
				showNotification("Launching " . _arrayWebName[UserInput] . " with default browser")
				Sleep, %_DelayTime%
				showNotification(,False)
				Break
			}
			else 
			{
				Continue
			}
		}
		else if (userMode = "app_mode")
		{
			inputReturn := getUserInput(UserInput, "[ app_mode ]`n" . _strAppHotKeys . _strBackOneLevel . _strQuit)
			path := _arrayAppPath[UserInput]
			if (inputReturn = "endkey:escape")
			{
				Break
			}
			if (path != "" && FileExist(path) != "")
			{
				Run %path%
				showNotification("Launching " . _arrayAppName[UserInput])
				Sleep, %_DelayTime%
				showNotification(,False)
				Break
			}
			else 
			{
				Continue
			}
		}
		else if (userMode = "settings_mode")
		{
			inputReturn := getUserInput(UserInput,"[ settings ]`n" . _strSettingsHotKeys . _strBackOneLevel . _strQuit)
			settingsName := _arraySettingsName[UserInput]
			settingsCmd := _arraySettingsCommand[UserInput]

			if (settingsCmd = "exit")
			{
				showNotification("Exiting app")
				Sleep, %_DelayTime%
				ExitApp
			}
			else if (settingsCmd = "reload")
			{
				loadSettings()
				Break
			}
		}
		else 
		{
			Continue
		}
	}
	Return
}

showNotification(strNoti = "", isShow = True, fontSize = 24)
{
	global _NotiOpacity
	global _NotiTop
	global NotiBack
	global NotiFore

	if (isShow = True)
	{
		Gui, -Caption +ToolWindow +LastFound +AlwaysOnTop
		Gui, Color, 303030
		Gui, Font, cWhite
		Gui, Font, S%fontSize%, Segoe UI
		Gui, Add, Text, v_NotificationID +Center,%strNoti% 
		WinSet, Transparent , %_NotiOpacity%
		Gui, Show, y%_NotiTop%`
	}
	else 
	{
		fadeWinCount := _NotiOpacity
		While, fadeWinCount>0
		{
			Gui, +LastFound
			fadeWinCount-=10
			WinSet,Transparent, %fadeWinCount%
			Sleep, 10
		}
		Gui, Destroy
	}
}

getUserInput(ByRef outputVar, notiString)
{
	showNotification(notiString,,10)
	Input, outputVar,M, {Enter}{Escape}{BackSpace},
	Gui, Destroy
	StringLower, out, ErrorLevel
	return %out%
	;Endkey:*
}

loadSettings()
{

	global _iniFilename

	loadWebHotKeys(_iniFilename)
	loadAppHotKeys(_iniFilename)
	loadModeKeyWord(_iniFilename)
	loadSettingsHotKeys(_iniFilename)
}

loadAppHotKeys(filename)
{
	global _strAppHotKeys
	global _appHotKeyPrefix
	global _appHotKeySection
	global _arrayAppPath := {}
	global _arrayAppName := {}

	IniRead, _strAppHotKeys, %filename%, %_appHotKeySection%, Keyword
	splitHotKeys(_arrayAppPath, _arrayAppName, _strAppHotKeys, _appHotKeyPrefix, filename, "Path", "Name")

	_strAppHotKeys := ""
	combineKeywordArray(_strAppHotKeys,_arrayAppPath)
}

loadWebHotKeys(filename)
{
	global _strWebHotKeys
	global _webHotKeyPrefix
	global _webHotKeySection
	global _arrayWebKeys := {}
	global _arrayWebName := {}

	IniRead, _strWebHotKeys, %filename%, %_webHotKeySection%, Keyword
	splitHotKeys(_arrayWebKeys, _arrayWebName, _strWebHotKeys, _webHotKeyPrefix, filename, "Link", "Name")

	_strWebHotKeys := ""
	combineKeywordArray(_strWebHotKeys,_arrayWebKeys)
}

loadSettingsHotKeys(filename)
{
	global _settingsHotKeyPrefix
	global _settingsModeHotKeySection
	global _settingsHotKeySection
	global _strSettingsHotKeys
	global _arraySettingsName := {}
	global _arraySettingsCommand := {}

	IniRead, _strSettingsHotKeys, %filename%, %_settingsHotKeySection%, Keyword
	splitHotKeys(_arraySettingsCommand, _arraySettingsName, _strSettingsHotKeys, _settingsHotKeyPrefix, filename, "Cmd", "Name")

	_strSettingsHotKeys := ""
	combineKeywordArray(_strSettingsHotKeys, _arraySettingsName)
}

combineKeywordArray(ByRef string, array)
{
	i := 0
	arrCount := arrayCount(array)
	For keys, value in array
	{
		if (i > 0 && Mod(i,3) = 0)
		{
			string.= "`n"
		}
		string.= keys
		if (Mod(i,3) != 2 && i != arrCount-1)
		{
			 string.= " , "
		}
		i++
	}
}

arrayCount(array)
{
	arrCount := 0
	For keys, value in array
	{
		arrCount++
	}
	return arrCount
}

loadModeKeyWord(filename)
{
	global _webModeHotKeySection
	global _appModeHotKeySection
	global _arrayModeKeyword
	global _strAvailableModes

	IniRead, modeList, %filename%, mode, List
	StringSplit, modeTmp, modeList, `,
	Loop, %modeTmp0%
	{
		str:= modeTmp%A_Index%
		IniRead, key, %filename%, %str%, Keyword
		if (key != "ERROR")
		{
			_arrayModeKeyword[key] := str
			_strAvailableModes .= "`n" . key . " : " . str
		}
	}
}

splitHotKeys(ByRef outputArray, ByRef outputNameArray, inputString, prefix, iniFilename, keyName, keyTitle)
{
	StringSplit, tmp, inputString, `,
	Loop, %tmp0%
	{
		str:= tmp%A_Index%
		strPrefix := prefix . str
		IniRead, key, %iniFilename%, %strPrefix%, %keyName%
		IniRead, name, %iniFilename%, %strPrefix%, %keyTitle%

		if (key != "ERROR")
		{
			outputArray[str] := key
		}
		if (name != "ERROR")
		{
			outputNameArray[str] := name
		}
	}
}