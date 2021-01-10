//
//  DNSStruct.swift
//  PrivateDNS
//
//  Created by Chinmay Thosar on 01/01/21.
//

import Foundation
//DNS Passing structure IP adress array and String as URLS

struct configStruct {
    var servers: Array<String>
    var serverURL: String
}

struct dnsName: Identifiable {
        let id = UUID().uuidString
        var name: String
        var no: Int
    }

