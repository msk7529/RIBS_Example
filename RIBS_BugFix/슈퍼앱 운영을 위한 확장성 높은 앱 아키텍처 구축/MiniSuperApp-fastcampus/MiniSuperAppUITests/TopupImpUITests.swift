//
//  TopupImpUITests.swift
//  MiniSuperAppUITests
//
//  Created on 2022/01/05.
//

import XCTest
import Swifter

final class TopupImpUITests: XCTestCase {

    private var app: XCUIApplication!
    private var server: HttpServer!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        server = HttpServer()
        
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTopupSuccess() throws {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // given
        let cardOnFileJSONPath = try TestUtil.path(for: "cardOnFile.json", in: type(of: self))
        server["/cards"] = shareFile(cardOnFileJSONPath)
        
        let topupResponse = try TestUtil.path(for: "topupSuccessResponse.json", in: type(of: self))
        server["/topup"] = shareFile(topupResponse)
        
        // when
        try server.start()
        app.launch()
        
        // then
        app.tabBars.buttons["superpay_home_tab_bar_item"].tap()     // 두번째 탭 선택
        app.buttons["superpay_dashboard_topup_button"].tap()    // 충전하기 버튼 선택
        
        let textField = app.textFields["topup_enteramount_textfield"]
        textField.tap()     // 텍스트필드를 탭해서 키보드를 올라오게 함
        textField.typeText("10000")
        
        app.buttons["topup_enteramount_confirm_button"].tap()   // 확인버튼 선택
        
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "superpay_dashboard_balance_label").label, "10,000") // 금액이 성공적으로 충전되었는지 확인
    }

}
