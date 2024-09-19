//
//  RoomieTests.swift
//  RoomieTests
//
//  Created by David Shapiro on 8/28/24.
//

import XCTest
@testable import Roomie

final class RoomieTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    /// Tests that length of code if 5 by default
    func testGenCodeLength() {
        let expectedLength = 5
        let code = genCode()
        
        XCTAssertEqual(code.count, expectedLength, "Generated Code Length is Incorrect")
    }
    
    /// Tests that code can have a custom length
    func testGenCodeCustomLength() {
        let expectedLength = 50
        let code = genCode(length: 50)
        
        XCTAssertEqual(code.count, expectedLength, "Generated Code Length is Incorrect")
    }
    
    /// Tests that codes have valid characters
    func testValidChars() {
        let code = genCode(length: 200)
        let valid = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        for char in code {
            XCTAssertTrue(valid.contains(char), "Invalid Character " + String(char))
        }
    }
    
    /// Tests that you can add data to database
    func testAddData() {
        let testRef = TestDatabaseReference()
        let label = "Name"
        let value = "David"
        let path = ["example", "testing"]
        let id = "ID"
        
        addData(ref: testRef, label: label, path: path, value: value, id: id)
        
        XCTAssertEqual(testRef.childPaths, ["rooms", "ID", "example", "testing"], "Paths not correct"
        )
        XCTAssertEqual(testRef.updatedValues?[label] as? String, value, "value not correct")
        XCTAssertTrue(testRef.didCallUpdate, "update child values not called")
    }
    
    /// Tests the linking of code to room ID
    func testCodeToID() {
        let testRef = TestDatabaseReference()
        let code = "TEST-CODE"
        let roomID = "TEST-ID"
        
        linkCodeToID(ref: testRef, code: code, roomID: roomID)

        XCTAssertEqual(testRef.updatedValues? [code] as? String, roomID, "Error linkinf code and roomID")
    }
    
    func testGetRoomID() async throws {
        let expectation = XCTestExpectation(description: "Waiting for room ID")
        
        let testRef = TestDatabaseReference()
        let code = "test-code"
        let roomID = "test-roomID"
        var result = "error"
        linkCodeToID(ref: testRef, code: code, roomID: roomID)
        
        do {
            result = try await getRoomID(ref: testRef, code: code)
            expectation.fulfill()
        }
        catch {
            XCTFail("Failed with error: \(error)")
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 5.0)
        XCTAssertEqual(result, roomID, "Error retrieving roomID")
    }
    
    /// Tests that room does not exist when it should not
    func testRoomDoesntExist() async {
        //Setup
        let testRef = TestDatabaseReference()
        let code = "test-code"
        var exists = true
        
        do {
            exists = try await roomExists(ref: testRef, code: code)
        }
        catch {
            print("room exists but should not")
        }
        XCTAssertEqual(exists, false)
    }
    
    /// Tests room exists when it should
    func testRoomExists() async {
        let testRef = TestDatabaseReference()
        let code = "test-code"
        let roomID = "test-ID"
        var exists = false
        
        linkCodeToID(ref: testRef, code: code, roomID: roomID)
        
        do {
            exists = try await roomExists(ref: testRef, code: code)
        }
        catch {
            print("room does not exist but should")
        }
        XCTAssertEqual(exists, false)
    }
    
    func testGetWinner() {
        let item1 = MovieItem(movie: "Movie 1", index: 1, total: 4)
        let item2 = MovieItem(movie: "Movie 2", index: 2, total: 4)
        let item3 = MovieItem(movie: "Movie 3", index: 3, total: 4)
        let item4 = MovieItem(movie: "Movie 4", index: 4, total: 4)
        let items = [item1, item2, item3, item4]
        
        //Regular cases
        var rotate = 10.0
        var winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 4")
        
        rotate = 100.0
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 3")
        
        rotate = 200.0
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 2")
        
        rotate = 320.0
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 1")
        
        //Edge cases
        rotate = 0.0
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 1")
        
        rotate = 90.0
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 4")
        
        rotate = 180.0
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 3")
        
        rotate = 270.0
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 2")
        
        rotate = 359.9
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 1")
        
        //Expanded cases
        rotate = 410.0
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 4")
        
        rotate = 460.0
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 3")
        
        rotate = 910.0
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 2")
        
        rotate = 1000.0
        winner = getWinner(rotation: rotate, movieItems: items)
        XCTAssertEqual(winner, "Movie 1")
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
