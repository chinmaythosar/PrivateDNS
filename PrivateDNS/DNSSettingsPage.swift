//
//  DNSSettingsPage.swift
//  PrivateDNS
//
//  Created by Chinmay Thosar on 01/01/21.
//

import SwiftUI
import NetworkExtension





struct DNSSettingsPage: View {
    //Apply DNS input servers and url with bool to select DoT or DoH
    //Use NEDNSSettingsManager Don't create object
    func applyDNS(servers:Array<String>,serverURL:String,dot:Bool){
        
        if(dot == false){
            NEDNSSettingsManager.shared().loadFromPreferences(){ loadError in
                if let loadError = loadError {
                    print(loadError)
                    return
                }
                
                let dohSettings = NEDNSOverHTTPSSettings(servers: servers)
                dohSettings.serverURL = URL(string: serverURL)
                NEDNSSettingsManager.shared().dnsSettings = dohSettings
                NEDNSSettingsManager.shared().saveToPreferences { saveError in
                    if let saveError = saveError {
                        print(saveError)
                        return
                    }
                    else{
                        
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
                let dotSettings = NEDNSOverTLSSettings(servers: servers)
                dotSettings.serverName = serverURL
                NEDNSSettingsManager.shared().dnsSettings = dotSettings
                NEDNSSettingsManager.shared().saveToPreferences { saveError in
                    if let saveError = saveError {
                        print(saveError)
                        return
                    }
                }
                
            }
        }
        
    }
    
    
    //
    @State var currentString = UserDefaults.standard.string(forKey: "Name") ?? "Default - CloudFlare DoH"
    

    
    var body: some View {
            List{
                Text("DNS: \(self.currentString)").font(Font.title.weight(.bold)).contentShape(Rectangle())
                    Spacer()
                    Text("CloudFlare DNS over HTTPS").contentShape(Rectangle())
                .onTapGesture {
                applyDNS(servers: [ "1.1.1.1","1.0.0.1","2606:4700:4700::1111","2606:4700:4700::1001" ], serverURL: "https://cloudflare-dns.com/dns-query",dot: false)
                UserDefaults.standard.set("CloudFlare DoH", forKey: "Name")
                self.currentString = "CloudFlare DoH"
                }
                    Text("CloudFlare DNS over TLS")
                .onTapGesture {
                    applyDNS(servers: [ "1.1.1.1","1.0.0.1","2606:4700:4700::1111","2606:4700:4700::1001" ], serverURL: "cloudflare-dns.com", dot: true)
                    UserDefaults.standard.set("CloudFlare DoT", forKey: "Name")
                    self.currentString = "CloudFlare DoT"
                }.contentShape(Rectangle())
                
                    Text("Google DNS over HTTPS")
                .onTapGesture {
                    applyDNS(servers: ["8.8.8.8","8.8.4.4","2001:4860:4860::8888","2001:4860:4860::8844"], serverURL: "https://dns.google/dns-query", dot: false)
                    UserDefaults.standard.set("Google DoH", forKey: "Name")
                    self.currentString = "Google DoH"

                }.contentShape(Rectangle())
                
                    Text("Google DNS over TLS")
                .onTapGesture {
                    applyDNS(servers: ["8.8.8.8","8.8.4.4","2001:4860:4860::8888","2001:4860:4860::8844"], serverURL: "dns.google", dot: true)
                    UserDefaults.standard.set("Google DoT", forKey: "Name")
                    self.currentString = "Google DoT"

                }.contentShape(Rectangle())
                
                    Text("Quad9 DNS over HTTPS")
                .onTapGesture {
                    applyDNS(servers:["9.9.9.9","149.112.112.112","2620:fe::fe","2620:fe::9"], serverURL: "https://dns.quad9.net/dns-query", dot: false)
                    UserDefaults.standard.set("Quad9 DoH", forKey: "Name")
                    self.currentString = "Quad9 DoH"

                }.contentShape(Rectangle())
                
                    Text("Quad9 DNS over TLS")
                .onTapGesture {
                    applyDNS(servers: ["9.9.9.9","149.112.112.112","2620:fe::fe","2620:fe::9"], serverURL: "ns.quad9.net", dot: true)
                    UserDefaults.standard.set("Quad9 DoT", forKey: "Name")
                    self.currentString = "Quad9 DoT"

                }.contentShape(Rectangle())
            }
        
        .onAppear(){
            self.currentString = UserDefaults.standard.string(forKey: "Name") ?? "Default - CloudFlare DoH"
        }
    }
}

struct DNSSettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        DNSSettingsPage()
    }
}

