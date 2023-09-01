//
//  SecondaryType.swift
//  Soundscape
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.
//

import Foundation

enum SecondaryType: Type {
    
    case transitStop
    case financialService
    
    func matches(poi: POI) -> Bool {
        guard let typeable = poi as? Typeable else {
            return false
        }
        
        return typeable.isOfType(self)
    }

    var tags: [String] {
        switch self {
        case .transitStop: return ["osm.tag.bus_stop"]
        case .financialService: return ["osm.tag.bank", "osm.tag.atm", "osm.tag.atm.named", "osm.tag.atm.refed"]
        }
    }
}
