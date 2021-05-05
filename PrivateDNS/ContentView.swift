//
//  ContentView.swift
//  PrivateDNS
//
//  Created by Chinmay Thosar on 01/01/21.
//

import SwiftUI
import NetworkExtension

struct ContentView: View {
    // Initialize Variable
    var body: some View {
        // Tab View showing three options.
        TabView{
            DefaultPage().tabItem {
                Image(systemName: "network")
                Text("Home")
            }
            DNSSettingsPage().tabItem {
                Image(systemName: "list.dash")
                Text("DNS")
                
            }
            CustomDNS().tabItem {
                Image(systemName: "square.and.pencil")
                Text("CustomDNS")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
