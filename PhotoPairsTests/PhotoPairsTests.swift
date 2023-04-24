//
//  PhotoPairsTests.swift
//  PhotoPairsTests
//
//  Created by Mijo Gracanin on 31.12.2022..
//

import XCTest
@testable import PhotoPairs

@MainActor final class PhotoPairsTests: XCTestCase {

    var board: Board!
    
    override func setUp() async throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        board = Board(configuration: .test)
        board.availableSize = CGSize(width: 300, height: 300)
        try? await board.loadCards()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        board = nil
    }
    

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCardRevealedAfterRevealingAndNoActiveCard() async {
        XCTAssertFalse(board.cards.first!.isRevealed)
        
        
        await board.reveal(card: board.cards.first!)
        
        
        XCTAssertTrue(board.cards.first!.isRevealed)
    }
    
    func testNoChangeAfterRevealingRevealedCard() async {
        XCTAssertFalse(board.cards.first!.isRevealed)
        await board.reveal(card: board.cards.first!)
        XCTAssertTrue(board.cards.first!.isRevealed)
        
        
        await board.reveal(card: board.cards.first!)
        
        
        XCTAssertTrue(board.cards.first!.isRevealed)
    }
    
    func testCardRevealedAndUnrevealedIfActiveCardIsNotMatch() async {
        await board.reveal(card: board.cards[0])
        
        
        let expectation = waitUntil(board.cards[2].$isRevealed, equals: true)
        await board.reveal(card: board.cards[2])
        
        
        await fulfillment(of: [expectation], timeout: 5)
        XCTAssertFalse(board.cards[0].isRevealed)
        XCTAssertFalse(board.cards[2].isRevealed)
    }
    
    func testCardStaysRevealedIfActiveCardIsMatch() async {
        await board.reveal(card: board.cards[0])
        
        
        await board.reveal(card: board.cards[1])
        
        
        XCTAssertTrue(board.cards[1].isRevealed)
    }
    }
