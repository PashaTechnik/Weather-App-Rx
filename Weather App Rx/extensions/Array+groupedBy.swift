//
//  String+countryName.swift
//  Weather App
//
//  Created by Pasha on 03.11.2022.
//

import Foundation

protocol Dated {
    var date: Date { get }
}

extension Array where Element: Dated {
    func groupedBy(dateComponents: Set<Calendar.Component>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur.date)
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}


extension Collection {
    func mostFrequent() -> Self.Element?
    where Self.Element: Hashable {
        let counts = self.reduce(into: [:]) {
            return $0[$1, default: 0] += 1
        }

        return counts.max(by: { $0.1 < $1.1 })?.key
    }
}
