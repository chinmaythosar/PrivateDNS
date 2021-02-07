//
//  DNSSettingsPage.swift
//  PrivateDNS
//
//  Created by Chinmay Thosar on 01/01/21.
//

import SwiftUI
import NetworkExtension


struct DNSData: Identifiable{
    let id = UUID()
    let name: String
    let ip:Array<String>
    let url:String
    let dot:Bool
}

let cloudflaredoh = DNSData(name: "CloudFlare DoH", ip: [ "1.1.1.1","1.0.0.1","2606:4700:4700::1111","2606:4700:4700::1001" ], url: "https://cloudflare-dns.com/dns-query", dot: false)

let cloudflaredot = DNSData(name: "CloudFlare DoT", ip: [ "1.1.1.1","1.0.0.1","2606:4700:4700::1111","2606:4700:4700::1001" ], url: "cloudflare-dns.com", dot: true)


let googledoh = DNSData(name: "Google DoH", ip: ["8.8.8.8","8.8.4.4","2001:4860:4860::8888","2001:4860:4860::8844"], url: "https://dns.google/dns-query", dot: false)

let googledot = DNSData(name: "Google DoT", ip: ["8.8.8.8","8.8.4.4","2001:4860:4860::8888","2001:4860:4860::8844"], url: "dns.google", dot: true)

let quad9doh = DNSData(name: "Quad9 DoH", ip: ["9.9.9.9","149.112.112.112","2620:fe::fe","2620:fe::9"], url: "https://dns.quad9.net/dns-query", dot: false)

let quad9dot = DNSData(name: "Quad9 DoT", ip: ["9.9.9.9","149.112.112.112","2620:fe::fe","2620:fe::9"], url: "ns.quad9.net", dot: true)

struct DNSSettingsPage: View {
    //Apply DNS input servers and url with bool to select DoT or DoH
    //Use NEDNSSettingsManager Don't create object
    func applyDNS(DNSData:DNSData){
        
        if(DNSData.dot == false){
            NEDNSSettingsManager.shared().loadFromPreferences(){ loadError in
                if let loadError = loadError {
                    print(loadError)
                    return
                }
                
                let dohSettings = NEDNSOverHTTPSSettings(servers: DNSData.ip)
                dohSettings.serverURL = URL(string: DNSData.url)
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
                let dotSettings = NEDNSOverTLSSettings(servers: DNSData.ip)
                dotSettings.serverName = DNSData.url
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
    
    let dnslist:[DNSData] = [cloudflaredoh,cloudflaredot,googledoh,googledot,quad9doh,quad9dot]
    
    
    var body: some View {
        List{
            ForEach(dnslist){ temp in
                Text(temp.name).onTapGesture {
                    applyDNS(DNSData: temp)
                }.contentShape(Rectangle())
            }
        }
        
        
        
        
        
        
    }
}

struct DNSSettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        DNSSettingsPage()
    }
}

