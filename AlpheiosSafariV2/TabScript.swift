//
//  TabScript.swift
//  AlpheiosSafariV1
//
//  Created by Irina Sklyarova on 11/09/2018.
//  Copyright © 2018 Irina Sklyarova. All rights reserved.
//

class TabScript {
    var ID: Int
    var status: String = ""
    var panelStatus: String = ""
    var savedStatus: String = ""
    var uiActive: String = ""
    var tab: String = "info"
    
    static let props: [String: String] = [
        "status_panel_open": "Alpheios_Status_PanelOpen",
        "status_panel_closed": "Alpheios_Status_PanelClosed",
        "status_pending": "Alpheios_Status_Pending",
        "status_active": "Alpheios_Status_Active",
        "status_deactivated": "Alpheios_Status_Deactivated"
    ]
    
    var isActive: Bool {
        get {
            return self.status == TabScript.props["status_active"]
        }
    }

    var isDeactivated: Bool {
        get {
            return self.status == TabScript.props["status_deactivated"]
        }
    }
    
    var isPanelOpen: Bool {
        get {
            return self.panelStatus == TabScript.props["status_panel_open"]
        }
    }
 
    var isPanelClosed: Bool {
        get {
            return self.panelStatus == TabScript.props["status_panel_closed"]
        }
    }
    
    init(hashValue: Int) {
        self.ID = hashValue
    }

    static func createTabPending(hashValue: Int) -> TabScript {
        let tab = TabScript(hashValue: hashValue)
        tab.status = TabScript.props["status_pending"]!
        return tab
    }
    
    func setPanelOpen() {
        self.panelStatus = TabScript.props["status_panel_open"]!
    }

    func setPanelClosed() {
        self.panelStatus = TabScript.props["status_panel_closed"]!
    }

    func activate() {
        self.status = TabScript.props["status_active"]!
    }

    func deactivate() {
        self.status = TabScript.props["status_deactivated"]!
    }
    
    func changeActiveStatus() {
        if self.isActive {
            self.deactivate()
        } else {
            self.activate()
        }
    }
    
    func convertForMessage() -> [String: String] {
        return [
            "ID": String(self.ID),
            "status": self.status,
            "panelStatus": self.panelStatus,
            "savedStatus": self.savedStatus,
            "uiActive": self.uiActive,
            "tab": self.tab
        ]
    }
    
    func toString() -> String {
        return "ID: \(self.ID), status: \(self.status), panelStatus: \(self.panelStatus), savedStatus: \(self.savedStatus), uiActive: \(self.uiActive)"
    }
    
}
