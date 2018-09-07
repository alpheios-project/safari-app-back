//
//  SafariExtensionHandler.swift
//  AlpheiosSafariV1
//
//  Created by Irina Sklyarova on 28/08/2018.
//  Copyright © 2018 Irina Sklyarova. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String: Any]?) {
        page.dispatchMessageToScript(withName: "helloFromBackground", userInfo: ["message": messageName, "type": "Alpheios_StateRequest", "body": userInfo]);
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        
//        window.getActiveTab(completionHandler: { (activeTab) in
//            activeTab?.getActivePage(completionHandler: { (activePage) in
//                activePage?.dispatchMessageToScript(withName: "toolbarItemClicked", userInfo: nil)
//            })
//        })
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
