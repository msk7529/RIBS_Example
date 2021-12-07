//
//  Array+Utils.swift
//  MiniSuperApp
//
//  Created by kakao on 2021/11/15.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
