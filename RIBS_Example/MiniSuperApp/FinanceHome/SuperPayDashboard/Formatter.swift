//
//  Formatter.swift
//  MiniSuperApp
//
//

import Foundation

struct Formatter {
    static let balacneFormatter: NumberFormatter = {
        let formatter: NumberFormatter = .init()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
