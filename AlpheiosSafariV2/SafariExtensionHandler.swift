//
//  SafariExtensionHandler.swift
//  AlpheiosSafariV2
//
//  Created by Irina Sklyarova on 11/09/2018.
//  Copyright © 2018 Irina Sklyarova. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {
    static let browserIcons: [String: String] = [
        "active": "cat.pdf",
        "nonactive": "ToolbarItemIcon.pdf"
    ]
    
    static var tabs: [Int: TabScript] = [:]
    
    func updateIcon(active: Bool, window: SFSafariWindow) {
        window.getToolbarItem { toolbarItem in
            var icon = SafariExtensionHandler.browserIcons["nonactive"]
            
            if (active) {
              icon = SafariExtensionHandler.browserIcons["active"]
            }
            
            toolbarItem?.setImage(NSImage.init(named: NSImage.Name(rawValue: icon!)))
        }
    }
    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
//        page.getPropertiesWithCompletionHandler { properties in
//            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
//        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        window.getActiveTab(completionHandler: { (activeTab) in
            activeTab?.getActivePage(completionHandler: { (activePage) in
                activePage?.getPropertiesWithCompletionHandler { properties in
                    let curTab = self.getTabFromTabsByHash(hashValue: (activePage?.hashValue)!)
                    curTab.changeActiveStatus()
                    
                    if (curTab.isActive) {
                        self.activateContent(tab: curTab, window: window)
                    } else {
                        self.deactivateContent(tab: curTab, window: window)
                    }
                    
                }
            })
        })
        
    }
    
    override func contextMenuItemSelected(withCommand command: String, in page: SFSafariPage, userInfo: [String : Any]? = nil) {
        if command == "OpenPanel" {
            self.openPanel(page: page)
        }
    }
    
    func openPanel(page: SFSafariPage) {
        let curTab = self.getTabFromTabsByHash(hashValue: page.hashValue)
        if curTab.isActive {
            curTab.setPanelOpen()
            self.setContentState(tab: curTab, page: page)
        }
    }
    
    func activateContent(tab: TabScript, window: SFSafariWindow) {
        window.getActiveTab(completionHandler: { (activeTab) in
            activeTab?.getActivePage(completionHandler: { (activePage) in
                self.setContentState(tab: tab, page: activePage!)
                self.updateIcon(active: true, window: window)
            })
        })
    }
    
    func deactivateContent(tab: TabScript, window: SFSafariWindow) {
        window.getActiveTab(completionHandler: { (activeTab) in
            activeTab?.getActivePage(completionHandler: { (activePage) in
                self.setContentState(tab: tab, page: activePage!)
                self.updateIcon(active: false, window: window)
            })
        })
    }
    
    func setContentState(tab: TabScript, page: SFSafariPage) {
        page.getPropertiesWithCompletionHandler { properties in
           let stateRequestMess = StateRequest(body: tab.convertForMessage())
           print(stateRequestMess.convertForMessage())
           page.dispatchMessageToScript(withName: "fromBackground", userInfo: stateRequestMess.convertForMessage())
        }
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }
    
    func getTabFromTabsByHash(hashValue: Int) -> TabScript {
        if (SafariExtensionHandler.tabs[hashValue] == nil) {
            let curPage = TabScript(hashValue: hashValue)
            SafariExtensionHandler.tabs[hashValue] = curPage
        }
        return SafariExtensionHandler.tabs[hashValue]!
    }
    
}
