//
//  Combine+Utils.swift
//  MiniSuperApp
//
//  Created on 2021/10/27.
//

/*
 CurrentValueSubject의 변형. subscriber들이 가장 최신의 값에 접근할 수 있도록 하되, 직접 값을 send할 수 없도록 한다.
 Combine만을 사용하면 불가능해서 CombineExt를 import
 
 */

import Combine
import CombineExt

public class ReadOnlyCurrentValuePublisher<Element>: Publisher {
    public typealias Output = Element
    public typealias Failure = Never
    
    fileprivate let currentValueRelay: CurrentValueRelay<Output>
    
    public var value: Element {
        return currentValueRelay.value
    }
    
    fileprivate init(_ initialValue: Element) {
        currentValueRelay = CurrentValueRelay(initialValue)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Element == S.Input {
        currentValueRelay.receive(subscriber: subscriber)
    }
}

public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
    typealias Output = Element
    typealias Failure = Never
    
    public override init(_ initialValue: Element) {
        super.init(initialValue)
    }
    
    public func send(_ value: Element) {
        currentValueRelay.accept(value)
    }
}
