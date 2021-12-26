//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by aiden_h on 2021/12/07.
//

import Foundation

struct Formatter {
    static let balanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
}
