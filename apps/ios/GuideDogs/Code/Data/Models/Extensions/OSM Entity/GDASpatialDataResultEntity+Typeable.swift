//
//  GDASpatialDataResultEntity+Typeable.swift
//  Soundscape
//
//  Copyright (c) Microsoft Corporation.
//  Licensed under the MIT License.
//

import Foundation

extension GDASpatialDataResultEntity: Typeable {
    
    func isOfType(_ type: PrimaryType) -> Bool {
        switch type {
        case .transit: return isOfType(.transitStop)
        case .finance: return isOfType(.financialService)
        }
    }

    func isOfType(_ type: SecondaryType) -> Bool {
        switch type {
        case .transitStop: return isTransitStop()
        case .financialService: return confirmType(for: .financial, with: type.tags)
        }
    }

    // Have kept this function for the moment since it applies an && filter
    // since the mobility case is added to many POIs currently
    // Prefer confirmType(for: with tags:) when adding new cases
    private func isTransitStop() -> Bool {
        guard let category = SuperCategory(rawValue: superCategory) else {
            return false
        }

        return category == .mobility && localizedName.lowercased().contains(GDLocalizedString("osm.tag.bus_stop").lowercased())
    }

    private func confirmType(for desiredCategory: SuperCategory, with tags: [String]) -> Bool {
        guard let category = SuperCategory(rawValue: superCategory) else {
            return false
        }

        return category == desiredCategory || tags.contains { GDLocalizedString($0).lowercased() == localizedName.lowercased() }
    }
}
