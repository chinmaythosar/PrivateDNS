//
//  DNSSettingsPage.swift
//  PrivateDNS
//
//  Created by Chinmay Thosar on 01/01/21.
//

import SwiftUI
import NetworkExtension


// Identifiable Struct for List Method
struct DNSData: Identifiable{
    let id = UUID()
    let name: String
    let ip:Array<String>
    let url:String
    let dot:Bool
}

//DNS Servers List as Static types.


let cloudflaredoh = DNSData(name: "CloudFlare DoH", ip: [ "1.1.1.1","1.0.0.1","2606:4700:4700::1111","2606:4700:4700::1001" ], url: "https://cloudflare-dns.com/dns-query", dot: false)

let cloudflaredot = DNSData(name: "CloudFlare DoT", ip: [ "1.1.1.1","1.0.0.1","2606:4700:4700::1111","2606:4700:4700::1001" ], url: "cloudflare-dns.com", dot: true)

let googledoh = DNSData(name: "Google DoH", ip: ["8.8.8.8","8.8.4.4","2001:4860:4860::8888","2001:4860:4860::8844"], url: "https://dns.google/dns-query", dot: false)

let googledot = DNSData(name: "Google DoT", ip: ["8.8.8.8","8.8.4.4","2001:4860:4860::8888","2001:4860:4860::8844"], url: "dns.google", dot: true)

let quad9doh = DNSData(name: "Quad9 DoH", ip: ["9.9.9.9","149.112.112.112","2620:fe::fe","2620:fe::9"], url: "https://dns.quad9.net/dns-query", dot: false)

let quad9dot = DNSData(name: "Quad9 DoT", ip: ["9.9.9.9","149.112.112.112","2620:fe::fe","2620:fe::9"], url: "ns.quad9.net", dot: true)

let cleanbrowsingsecdoh = DNSData(name: "Clean Browsing Security Filter DoH", ip: ["185.228.168.9","185.228.169.9","2a0d:2a00:1::2","2a0d:2a00:2::2"], url: "https://doh.cleanbrowsing.org/doh/security-filter/", dot: false)

let cleanbrowsingsecdot = DNSData(name: "Clean Browsing Security Filter DoT", ip: ["185.228.168.9","185.228.169.9","2a0d:2a00:1::2","2a0d:2a00:2::2"], url: "security-filter-dns.cleanbrowsing.org", dot: true)

let cleanbrowsingfamdoh = DNSData(name: "Clean Browsing Family Filter DoH", ip: ["185.228.168.168","185.228.169.168","2a0d:2a00:1::","2a0d:2a00:2::"], url: "https://doh.cleanbrowsing.org/doh/family-filter/", dot: false)

let cleanbrowsingfamdot = DNSData(name: "Clean Browsing Family Filter DoT", ip: ["185.228.168.168","185.228.169.168","2a0d:2a00:1::","2a0d:2a00:2::"], url: "family-filter-dns.cleanbrowsing.org", dot: true)

let cleanbrowsingadultdoh = DNSData(name: "Clean Browsing Adult Filter DoH", ip: ["185.228.168.10","185.228.169.11","2a0d:2a00:1::1","2a0d:2a00:2::1"], url: "https://doh.cleanbrowsing.org/doh/adult-filter/", dot: false)

let cleanbrowsingadultdot = DNSData(name: "Clean Browsing Adult Filter DoT", ip: ["185.228.168.10","185.228.169.11","2a0d:2a00:1::1","2a0d:2a00:2::1"], url: "adult-filter-dns.cleanbrowsing.org", dot: true)

let adguarddefaultdoh = DNSData(name: "Adguard Default DoH", ip: ["94.140.14.14","94.140.15.15","2a10:50c0::ad1:ff","2a10:50c0::ad2:ff"] , url: "https://dns.adguard.com/dns-query", dot: false)

let adguarddefaultdot = DNSData(name: "Adguard Default DoT", ip: ["94.140.14.14","94.140.15.15","2a10:50c0::ad1:ff","2a10:50c0::ad2:ff"] , url: "dns.adguard.com", dot: true)

let adguardfamilydoh = DNSData(name: "Adguard Family Protection DoH", ip: ["94.140.14.15","94.140.15.16","2a10:50c0::bad1:ff","2a10:50c0::bad2:ff"] , url: "https://dns-family.adguard.com/dns-query", dot: false)

let adguardfamilydot = DNSData(name: "Adguard Family Protection DoT", ip: ["94.140.14.15","94.140.15.16","2a10:50c0::bad1:ff","2a10:50c0::bad2:ff"] , url: "dns-family.adguard.com", dot: true)

let adguardnonfilteringdoh = DNSData(name: "Adguard Non-Filtering DoH", ip: ["94.140.14.140","94.140.14.141","2a10:50c0::1:ff","2a10:50c0::2:ff"] , url: "https://dns-unfiltered.adguard.com/dns-query", dot: false)

let adguardnonfilteringdot = DNSData(name: "Adguard Non-Filtering DoT", ip: ["94.140.14.140","94.140.14.141","2a10:50c0::1:ff","2a10:50c0::2:ff"] , url: "dns-unfiltered.adguard.com", dot: true)

struct DNSSettingsPage: View {
    //Get current DNS State for View
    @State var currentDNS = UserDefaults.standard.string(forKey: "Name") ?? "Default - CloudFlare DoH"

    //Apply DNS input servers and url with bool to select DoT or DoH
    //Use NEDNSSettingsManager Don't create object
    //Also pass DNSData as argument that is the struct defined containing all DNS Data
    func applyDNS(DNSData:DNSData){
        
        if(DNSData.dot == false){ //DoH function
            // Load current profile for applying - required every time profile needs to be changed.
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
                        //If save is successful update current DNS
                        UserDefaults.standard.set(DNSData.name, forKey: "Name")
                        self.currentDNS = UserDefaults.standard.string(forKey: "Name") ?? "Default - CloudFlare DoH"
                    }
                }
                
                
            }
        }
        else{ // Else DoT
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
                    else{
                        UserDefaults.standard.set(DNSData.name, forKey: "Name")
                        self.currentDNS = UserDefaults.standard.string(forKey: "Name") ?? "Default - CloudFlare DoH"
                    }
                }
                
            }
        }
        
    }
    
    
    
    //DNS List array
    let dnslist:[DNSData] = [cloudflaredoh,cloudflaredot,googledoh,googledot,quad9doh,quad9dot
                             ,cleanbrowsingsecdoh,cleanbrowsingsecdot,cleanbrowsingfamdoh,cleanbrowsingfamdot,cleanbrowsingadultdoh,cleanbrowsingadultdot
                             ,adguarddefaultdoh,adguarddefaultdot,adguardfamilydoh,adguardfamilydot,adguardnonfilteringdoh,adguardnonfilteringdot]
    
    
    
   var body: some View {
        VStack{
            Divider()
            //Top Text box as Header.
            Text("DNS: \(self.currentDNS)")
            Divider()
            List{
                //List view. Pick a List item from dnslist array and display.
                ForEach(dnslist){ temp in
                    Text(temp.name).onTapGesture {
                        applyDNS(DNSData: temp)
                    }.contentShape(Rectangle()) //On Tapping a DNS Iten perform onTapGesture.
                }
            }.onAppear(){
                self.currentDNS = UserDefaults.standard.string(forKey: "Name") ?? "Default - CloudFlare DoH"
                //On List appear update currentDNS variable for header
            }
        }
    }
    
    
        

}

struct DNSSettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        DNSSettingsPage()
    }
}

