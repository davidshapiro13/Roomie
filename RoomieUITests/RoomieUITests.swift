//
//  RoomieUITests.swift
//  RoomieUITests
//
//  Created by David Shapiro on 8/28/24.
//

import XCTest

final class RoomieUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        //Wheel Page
        let wheelTab = app.buttons["Wheel"]
        wheelTab.tap()

        let spinButton = app.buttons["Spin"]
        XCTAssertTrue(spinButton.exists, "Spin Button should exist")
        
        for i in 0..<100 {
            let firstRotation = app.staticTexts["RotationAngle"]
            spinButton.tap()
            
            let expected = expectation(description: "Waiting for spin")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        expected.fulfill()
            }
            waitForExpectations(timeout: 1.5)
            
            let winner = app.staticTexts["Result"]
            XCTAssertTrue(winner.exists, "winner should exist.")
            
            let resultRotation = app.staticTexts["RotationAngle"]
            XCTAssertNotEqual(firstRotation, resultRotation, "Rotation should change after spinning.")
            
        }
    }
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

/*
 If needed later
 
 //Get there
 
 //Login Page
 let joinButton = app.buttons["JoinRoom"]
 joinButton.tap()
 
 //Joining Page
 let codeTextField = app.textFields["CodeField"]
     codeTextField.tap()
     codeTextField.typeText("KBHPN")
 
 let nameTextField = app.textFields["NameField"]
     nameTextField.tap()
     nameTextField.typeText("UI-Test")
 let loginButton = app.buttons["login"]
 loginButton.tap()
 */
