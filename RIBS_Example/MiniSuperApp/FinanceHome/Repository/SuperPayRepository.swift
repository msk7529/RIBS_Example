//
//  SuperPayRepository.swift
//  MiniSuperApp
//
//  Created by on 2021/11/21.
//

import Combine
import Foundation

protocol SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> { get }
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error>
}

final class SuperPayRepositoryImp: SuperPayRepository {
    var balance: ReadOnlyCurrentValuePublisher<Double> {
        return balanceSubject
    }
    
    private let balanceSubject: CurrentValuePublisher<Double> = .init(0)
    
    private let bgQueue = DispatchQueue(label: "topup.repository.queue")
    
    func topup(amount: Double, paymentMethodID: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            self?.bgQueue.async {
                Thread.sleep(forTimeInterval: 2)
                promise(.success(()))
                let newBalance = (self?.balanceSubject.value).map { $0 + amount }
                newBalance.map { self?.balanceSubject.send($0) }
            }
        }.eraseToAnyPublisher()
    }
}
