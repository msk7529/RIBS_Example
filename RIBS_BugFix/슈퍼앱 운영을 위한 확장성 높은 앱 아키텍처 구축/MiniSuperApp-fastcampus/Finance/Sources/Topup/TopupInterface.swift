//
//  TopupInterface.swift
//  
//
//  Created by aiden_h on 2021/12/07.
//

import ModernRIBs

public protocol TopupBuildable: Buildable {
    func build(withListener listener: TopupListener) -> Routing
}

public protocol TopupListener: AnyObject {
    func topupDidClose()
    func topupDidFinish()
}
