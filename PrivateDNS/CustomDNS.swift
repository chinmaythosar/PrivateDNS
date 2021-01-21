//
//  CustomDNS.swift
//  PrivateDNS
//
//  Created by Chinmay Thosar on 01/01/21.
//

import SwiftUI
import NetworkExtension



struct CustomDNS: View {
    
    @State var alertSetting = false

    @State var dotselect: Bool = UserDefaults.standard.bool(forKey: "dotselect")
    
    @State var DNS4_1: String = UserDefaults.standard.string(forKey: "DNS4_1") ?? ""
    @State var DNS4_2: String = UserDefaults.standard.string(forKey: "DNS4_2") ?? ""
    @State var DNS6_1: String = UserDefaults.standard.string(forKey: "DNS6_1") ?? ""
    @State var DNS6_2: String = UserDefaults.standard.string(forKey: "DNS6_2") ?? ""
    @State var DNSURL: String = UserDefaults.standard.string(forKey: "DNSURL") ?? ""
    
    func applyDNS(config:configStruct,dot:Bool){
        self.alertSetting = false
        if(dot == false){
            NEDNSSettingsManager.shared().loadFromPreferences(){ loadError in
                if let loadError = loadError {
                    print(loadError)
                    return
                }
                
                let dohSettings = NEDNSOverHTTPSSettings(servers: config.servers)
                dohSettings.serverURL = URL(string: config.serverURL)
                NEDNSSettingsManager.shared().dnsSettings = dohSettings
                NEDNSSettingsManager.shared().saveToPreferences { (error:Error?) in
                    if ((error) != nil) {
                        self.alertSetting = true
                        return
                    }
                    else{
                        UserDefaults.standard.set("Custom", forKey: "Name")
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
                let dotSettings = NEDNSOverTLSSettings(servers: config.servers)
                dotSettings.serverName = config.serverURL
                NEDNSSettingsManager.shared().dnsSettings = dotSettings
                NEDNSSettingsManager.shared().saveToPreferences { (error:Error?) in
                    if ((error) != nil) {
                        self.alertSetting = true
                        return
                    }
                    else{
                        UserDefaults.standard.set("Custom", forKey: "Name")
                    }
                }
            }
        }
    }
    
    var body: some View {
        List{

            Section(header: Text("CustomConfig")) {
                TextField("DNS4", text: $DNS4_1)
                TextField("DNS4", text: $DNS4_2)
                TextField("DNS6", text: $DNS6_1)
                TextField("DNS6", text: $DNS6_2)
                
                TextField("DNS URL", text: $DNSURL)
            }
            Section{
                Toggle(isOn: self.$dotselect) {
                    Text("DoT")
                }
                Button(action: {
                    UserDefaults.standard.setValue(self.DNS4_1, forKey: "DNS4_1")
                    UserDefaults.standard.setValue(self.DNS4_2, forKey: "DNS4_2")
                    UserDefaults.standard.setValue(self.DNS6_1, forKey: "DNS6_1")
                    UserDefaults.standard.setValue(self.DNS6_2, forKey: "DNS6_2")
                    UserDefaults.standard.setValue(self.DNSURL, forKey: "DNSURL")
                    UserDefaults.standard.setValue(self.dotselect, forKey: "dotselect")

                    var serverlist = [ self.DNS4_1 , self.DNS4_2 , self.DNS6_1, self.DNS6_2]
                    serverlist = serverlist.filter({ $0 != ""})
                    let dnsConfigCustom = configStruct(servers: serverlist , serverURL: self.DNSURL)
                    if(self.dotselect == false){
                        applyDNS(config: dnsConfigCustom, dot: false )
                    }
                    else{
                        applyDNS(config: dnsConfigCustom, dot: true)
                    }
                   
                }, label: {
                    Text("Apply").alert(isPresented: $alertSetting ) {
                        Alert(title: Text("Invalid DNS Settings"), message: Text("Invalid DNS Detected. (Possible it's same DNS as current.)"), dismissButton: .default(Text("OK!")))
                    }
                })

                }

            }
        }
    }
    


struct CustomDNS_Previews: PreviewProvider {
    static var previews: some View {
        CustomDNS()
    }
}
