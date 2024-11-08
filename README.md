<p align="center">
	<img width="256" height="256" src="https://github.com/techrisdev/Snap/raw/main/Snap/Assets/Assets.xcassets/AppIcon.appiconset/Icon-512.png">
</p>

<h1 align="center">Snap</h1>
<h3 align="center">A better Spotlight search.</h4>
<h1 align="center">
<p>
  <a href="https://www.paypal.me/chrissklei">
      <img src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" alt="paypal">
  </a>
</p>
</h1>

## Introduction

Snap is an application which searches your Files, Contacts and Calendar events using Spotlight Metadata. It has many customization options as well as the ability to speed up your workflow by providing features like music control, clipboard history, snippet expansion and system commands like sleeping, restarting and shutting down the computer. It is inspired by [Alfred](https://alfredapp.com).

## Features

* File search
* Calendar event search
* Contact search
* Generally faster than Spotlight
* Customizable
* Custom applications like a Music Controller
* Clipboard History
* Snippet Expansion
* Actions like restarting the computer
* User Defined Actions (custom Apple Scripts)
* Web search<!-- Not Working? * Quick Look previews -->
* Uses SwiftUI
* Very customizable
* Completely open source
* Not using any libraries to make the project precise and easy to read

## Installation
If you want to install a precompiled .app file, download and extract the zip file from the [Releases](https://github.com/techrisdev/Snap/releases) page.

Be warned though: This app is in an alpha stage! Bugs will occur!

## Comparison
|Feature|Snap|Spotlight|Alfred (Free)|Alfred (Paid)|
|:---|:---:|:---:|:---:|:---:|
|Searching Files|✅|✅|✅|✅|
|Searching the Web|✅|✅|✅|✅|
|Quick Look Previews|✅|✅|✅|✅|
|Calendar Search|✅|✅|||
|Contact Search|✅|✅||✅|
|Reminder Search||✅|||
|Restarting, Sleeping etc.|✅| |✅|✅|
|User Definded Actions|✅|||✅|
|Clipboard History|✅|||✅|
|Snippet Expansion|✅|||✅|
|Music Controller|✅|||✅|
|Dictionary||✅|✅|✅|
|Completely Open Source|✅||||
|Free License|✅||||
|Customizable|✅||✅|✅|
|Free|✅|✅|✅||

## Building

Snap doesn't have any dependencies, you can just build the project in Xcode.

## Contributing
All contributions are welcome!
Please read [CONTRIBUTING.md](./CONTRIBUTING.md).

## Planned Features

* Reminder Search
* Custom Names for Actions, for example "Reboot" for "Restart"
* Make User Definded Actions easier (with a GUI and not only through a JSON file)
* Fix Bookmark Search
* Importing Configuration File through GUI instead of copying it manually 

## Known Bugs

* Sometimes, the Snippet Expansion doesn't work (for example, if you press the 'o' key in Vim to create a new line)
* Calculator not showing results with decimal places
* When a new Setting gets added, the old configuration file becomes invalid

## Screenshots
![](screenshots/Search.jpg?raw=true)
![](screenshots/Preferences.jpg?raw=true)
