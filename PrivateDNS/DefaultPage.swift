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
            /*Toggle("Disable on WiFi", isOn: self.$wifiactivation).onReceive([self.wifiactivation].publisher.first(), perform: { _ in
                if self.wifiactivation {
                    let wifitoggle = NEOnDemandRuleDisconnect()
                    wifitoggle.interfaceTypeMatch = .wiFi
                    
                    NEDNSSettingsManager.shared().onDemandRules = [
                        wifitoggle
                    ]
                }
                else{
                    let enableByDefault = NEOnDemandRuleConnect()
                    enableByDefault.interfaceTypeMatch = .any
                    
                    NEDNSSettingsManager.shared().onDemandRules = [
                        enableByDefault
                    ]
 
                }
            })*/
        }.padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
        
    }
    
    
    
    
}


struct DefaultPage_Previews: PreviewProvider {
    static var previews: some View {
        DefaultPage()
    }
}
