//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by aiden_h on 2021/10/27.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
