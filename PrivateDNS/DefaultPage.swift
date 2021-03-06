//
//  DefaultPage.swift
//  PrivateDNS
//
//  Created by Chinmay Thosar on 01/01/21.
//
/*
 This is the Default Page View.
 This page will apply a Default DNS if one hasn't been applied already.
 Also this page has a WiFi toggle button which allows you to turn off DNS Profile.
 */



import SwiftUI
import NetworkExtension

struct DefaultPage: View {
    @State private var wifiactivation = UserDefaults.standard.bool(forKey: "wifitoggle")
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Open 'Settings' and go to 'General' then to 'VPN and Network' then 'DNS' and select PrivateDNS in the List as your provider for encrypting all your DNS requests via your chosen DNS in PrivateDNS App.")
                .padding(.bottom)
            Text("Note: The Default is Cloudflare DNS over HTTPS (DoH).")
            Divider()
            //WiFi toggle setting. If wifi is toggled to On then apply dns profile to disable on all wifi networks.
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
                        
                        NEDNSSettingsManager.shared().saveToPreferences { saveError in
                            if let saveError = saveError {
                                print(saveError)
                                return
                            }
                            else{
                                UserDefaults.standard.setValue(true, forKey: "wifitoggle")
                            }
                        }
                    }
                }
                // Else apply the DNS profile for any network which inherently enables for wifi.
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
                        NEDNSSettingsManager.shared().saveToPreferences { saveError in
                            if let saveError = saveError {
                                print(saveError)
                                return
                            }
                            else{
                                UserDefaults.standard.setValue(false, forKey: "wifitoggle")
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
