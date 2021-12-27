//
//  TopupMock.swift
//  
//
//  Created on 2021/12/28.
//

import Foundation
import Topup

public final class TopupListenerMock: TopupListener {
    
    public var topupDidCloseCallCount: Int = 0
    public func topupDidClose() {
        topupDidCloseCallCount += 1
    }
    
    public var topupDidFinishCallCount: Int = 0
    public func topupDidFinish() {
        topupDidFinishCallCount += 1
    }
    
    public init() { }
}
