//
//  File.swift
//  
//
//  Created on 2022/01/04.
//

import Foundation
import FinanceEntity
import SnapshotTesting
import XCTest
@testable import TopupImp

final class EnterAmountViewTests: XCTestCase {
    
    func testEnterAmount() {
        // 코드작성후 첫번째 테스트시에는 실패. 이 때 __Snapshots__ 폴더내에 스냅샷 이미지가 생성되면서, 두번째 테스트 실행시부터는 이 이미지와 테스트시에 만들어지는 스냅샷과 비교하여 테스트 성공/실패가 결정된다.
        // given
        let paymentMethod = PaymentMethod(id: "0", name: "슈퍼은행", digits: "**** 9999", color: "#51AF80FF", isPrimary: false)
        let viewModel: SelectedPaymentMethodViewModel = .init(paymentMethod)
        
        // when
        let sut = EnterAmountViewController()
        sut.updateSelectedPaymentMethod(with: viewModel)
        
        // then
        assertSnapshot(matching: sut, as: .image(on: .iPhoneXsMax))
    }
    
    func testEnterAmountLoading() {
        // given
        let paymentMethod = PaymentMethod(id: "0", name: "슈퍼은행", digits: "**** 9999", color: "#51AF80FF", isPrimary: false)
        let viewModel: SelectedPaymentMethodViewModel = .init(paymentMethod)
        
        // when
        let sut = EnterAmountViewController()
        sut.updateSelectedPaymentMethod(with: viewModel)
        sut.startLoading()
        
        // then
        assertSnapshot(matching: sut, as: .image(on: .iPhoneXsMax))
    }
    
    func testEnterAmountStopLoading() {
        // given
        let paymentMethod = PaymentMethod(id: "0", name: "슈퍼은행", digits: "**** 9999", color: "#51AF80FF", isPrimary: false)
        let viewModel: SelectedPaymentMethodViewModel = .init(paymentMethod)
        
        // when
        let sut = EnterAmountViewController()
        sut.updateSelectedPaymentMethod(with: viewModel)
        sut.startLoading()
        sut.stopLoading()
        
        // then
        assertSnapshot(matching: sut, as: .image(on: .iPhoneXsMax))
    }
}
