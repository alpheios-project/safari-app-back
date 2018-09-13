//
//  content-process.swift
//  AlpheiosSafariV2
//
//  Created by Irina Sklyarova on 13/09/2018.
//  Copyright © 2018 Irina Sklyarova. All rights reserved.
//
import SafariServices

class BackgroundProcess {
    static let browserIcons: [String: String] = [
        "active": "cat.pdf",
        "nonactive": "ToolbarItemIcon.pdf"
    ]
    
    var tabs: [Int: TabScript] = [:]
    
    func updateIcon(active: Bool, window: SFSafariWindow) {
        window.getToolbarItem { toolbarItem in
            var icon = BackgroundProcess.browserIcons["nonactive"]
            
            if (active) {
                icon = BackgroundProcess.browserIcons["active"]
            }
            
            toolbarItem?.setImage(NSImage.init(named: NSImage.Name(rawValue: icon!)))
        }
    }
    
    func getTabFromTabsByHash(hashValue: Int) -> TabScript {
        if (self.tabs[hashValue] == nil) {
            let curPage = TabScript(hashValue: hashValue)
            self.tabs[hashValue] = curPage
        }
        return self.tabs[hashValue]!
    }
    
    func setContentState(tab: TabScript, page: SFSafariPage) {
        page.getPropertiesWithCompletionHandler { properties in
            let stateRequestMess = StateRequest(body: tab.convertForMessage())
            // print(stateRequestMess.convertForMessage())
            page.dispatchMessageToScript(withName: "fromBackground", userInfo: stateRequestMess.convertForMessage())
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
    
    func openPanel(page: SFSafariPage) {
        let curTab = self.getTabFromTabsByHash(hashValue: page.hashValue)
        if curTab.isActive {
            curTab.setPanelOpen()
            self.setContentState(tab: curTab, page: page)
        }
    }
    
    func changeActiveTabStatus(page: SFSafariPage, window: SFSafariWindow) {
        let curTab = self.getTabFromTabsByHash(hashValue: (page.hashValue))
        curTab.changeActiveStatus()
        
        if (curTab.isActive) {
            self.activateContent(tab: curTab, window: window)
        } else {
            self.deactivateContent(tab: curTab, window: window)
        }
    }
}
