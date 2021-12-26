//
//  TransportHomeInterface.swift
//  
//
//  Created by aiden_h on 2021/12/07.
//

import ModernRIBs

public protocol TransportHomeBuildable: Buildable {
    func build(withListener listener: TransportHomeListener) -> ViewableRouting
}

public protocol TransportHomeListener: AnyObject {
    func transportHomeDidTapClose()
}
