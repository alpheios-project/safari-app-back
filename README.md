# Alpheios Safari App Extension - background part

The project consists of the following folders:
- **AlpheiosV2.xcodeproj** - the folder with XCode project files
- **AlpheiosV2** - the folder with application files (I didn't touch it at all, it has only default template data)
- **AlpheiosSafariV2** - the folder with safari app extension files (here it is all my work)
- **dist** - **.app** built and **.dmg** build


## AlpheiosSafariV2 files

### Info.plist

[About Safari App Extension Default Keys](https://developer.apple.com/documentation/safariservices/safari_app_extensions/safari_app_extension_info_property_list_keys/about_safari_app_extension_default_keys)

This file consists of properties for the app extension.
I am using these keys in the **NSExtension** section:

Name | Description
------------ | -------------
SFSafariContextMenu | It contains the data for each context item that could appear using app extension. 
SFSafariStyleSheet | It contains the name for the stylesheet from safari-app-front. 
SFSafariContentScript | It contains the name for the js script from safari-app-front. 
SFSafariToolbarItem | It contains the data for toolbaritem.
SFSafariWebsiteAccess | It is for defining the access from tabs (I am using simply full access - didn't dive into it here).

### script.js, script.map.js, style.css

It is compiled data from [safari-app-front repo](https://github.com/alpheios-project/safari-app-front)

### SafariExtensionHandler.swift ([apple doc](https://developer.apple.com/documentation/safariservices/sfsafariextensionhandler))

The main file in Safari app extension structure.
There are all events comming from js part here.

Name | Description
------------ | -------------
messageReceived | This event executes on getting message from the injected js file.
toolbarItemClicked | This event is from toolbar icon clicked.
contextMenuItemSelected | This event is from context menu item selected.
validateToolbarItem | This event executes any time when the state of the toolbar icon could be changed.
validateContextMenuItem | This event executes before context menu becomes visible.
 | 
backgroundProcess | this is the variable for all alpheios custom background process (similiar to webextension background processes)