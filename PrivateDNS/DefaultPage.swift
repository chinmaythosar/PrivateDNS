//
//  DefaultPage.swift
//  PrivateDNS
//
//  Created by Chinmay Thosar on 01/01/21.
//

import SwiftUI
import NetworkExtension

struct DefaultPage: View {
    @State private var wifiactivation = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Open 'Settings' and go to 'General' then to 'VPN and Network' then 'DNS' and select PrivateDNS in the List as your provider for encrypting all your DNS requests via your chosen DNS in PrivateDNS App.")
                .padding(.bottom)
            Text("Note: The Default is Cloudflare DNS over HTTPS (DoH).")
            Divider()
            Toggle("Disable on WiFi", isOn: self.$wifiactivation).onReceive([self.wifiactivation].publisher.first(), perform: { _ in
                if self.wifiactivation {
                    NEDNSSettingsManager.shared().loadFromPreferences(){ loadError in
                        if let loadError = loadError {
                            print(loadError)
                            return
                        }
                        
                        let wifitoggle = NEOnDemandRuleDisconnect()
                        wifitoggle.interfaceTypeMatch = .wiFi
                        
                        NEDNSSettingsManager.shared().onDemandRules = [
                            wifitoggle
                        ]
                        UserDefaults.standard.set(true, forKey: "wifitoggle")
                        NEDNSSettingsManager.shared().saveToPreferences { saveError in
                            if let saveError = saveError {
                                print(saveError)
                                return
                            }
                        }
                    }
                }
                else{
                    NEDNSSettingsManager.shared().loadFromPreferences(){ loadError in
                        if let loadError = loadError {
                            print(loadError)
                            return
                        }
                        let enableByDefault = NEOnDemandRuleConnect()
                        enableByDefault.interfaceTypeMatch = .any
                        
                        NEDNSSettingsManager.shared().onDemandRules = [
                            enableByDefault
                        ]
                        UserDefaults.standard.set(false, forKey: "wifitoggle")
                        NEDNSSettingsManager.shared().saveToPreferences { saveError in
                            if let saveError = saveError {
                                print(saveError)
                                return
                            }
                        }
                    }
                }
            })
        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        
    }
    
    
    
    
}


struct DefaultPage_Previews: PreviewProvider {
    static var previews: some View {
        DefaultPage()
    }
}
