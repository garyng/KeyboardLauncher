KeyboardLauncher
================

A simple AutoHotKey script to launch things with only keyboard

_There is some programs like : FARR, Launchy which provide almost the same functionality with this script_


Prerequisites
===========
You need [AutoHotKey](http://www.autohotkey.com/) installed if you want to run the .ahk script

Or you can just run the .exe compiled without the AutoHotKey installed


Help
====

You can customize the hotkey that open a program/website in the settings.ini file

The default hotkey is `Ctrl + Shift + Alt + N`

INI File
========

- `[mode]` contain a list of available modes, currently only :-
	- `web_mode`
		
		Open a URL with the default browser

	- `app_mode`

		Launch a program

	- `settings_mode`
		
		Currently just two options:

		- `exit` which exit the program
		- `reload` which reload the settings file

- `[settings|web|app_mode]`
	- `Keyword` which contain the hotkey for entering specific mode

- `[settings|web|app_hotkey]`
	- `Keyword` which contain the key binding for lauching a program/website or do a specific action

- `[web_*]`
	
	Launch a specific website

	- `Name` which contain the name of the website (will show on the notification area)
	- `Link` which contain the URL to a specific website
- `[app_*]`
	
	Launch a specific program

	- `Name` which contain the name of the program
	- `Path` which contain the path to the program

.ahk File
=========
Contain the source code for the main script (with some comments!)