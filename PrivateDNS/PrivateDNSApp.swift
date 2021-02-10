//
//  PrivateDNSApp.swift
//  PrivateDNS
//
//  Created by Chinmay Thosar on 01/01/21.
//

import SwiftUI
import NetworkExtension

@main
struct PrivateDNSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear(){
                if(UserDefaults.standard.string(forKey: "Name") == nil){
                NEDNSSettingsManager.shared().loadFromPreferences { loadError in
                    if let loadError = loadError {
                        print(loadError)
                        return
                    }

                    let dohDefaultSettings = NEDNSOverHTTPSSettings(servers: [ "1.1.1.1","1.0.0.1","2606:4700:4700::1111","2606:4700:4700::1001" ])
                    dohDefaultSettings.serverURL = URL(string: "https://cloudflare-dns.com/dns-query")
                    NEDNSSettingsManager.shared().dnsSettings = dohDefaultSettings
                    NEDNSSettingsManager.shared().saveToPreferences { saveError in
                        if let saveError = saveError {
                            print(saveError)
                            return
                        }
                    }
                }   //Set UserDefaults on first launch for applied DNS and Custom Settings
                    UserDefaults.standard.set("Default - CloudFlare DoH", forKey: "Name")
                    
                    UserDefaults.standard.set("", forKey: "DNS4_1")
                    UserDefaults.standard.set("", forKey: "DNS4_2")
                    UserDefaults.standard.set("", forKey: "DNS6_1")
                    UserDefaults.standard.set("", forKey: "DNS6_2")
                    UserDefaults.standard.set("", forKey: "DNSURL")
                    UserDefaults.standard.set(false, forKey: "dotselect")
                    UserDefaults.standard.set(false, forKey: "wifitoggle")


                    
                }
                
            }
        }
    }
}



