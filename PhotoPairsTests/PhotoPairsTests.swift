//
//  PhotoPairsTests.swift
//  PhotoPairsTests
//
//  Created by Mijo Gracanin on 31.12.2022..
//

import XCTest
@testable import PhotoPairs

final class PhotoPairsTests: XCTestCase {

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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_Board_AfterRevealingRevealedCard_NoChange() {
        let board = Board()
        board.cards = [Card(isRevealed: true, image: UIImage(), number: 0)]
        
        board.reveal(card: board.cards.first!)
        
        XCTAssertTrue(board.cards.first!.isRevealed)
    }
    
    func test_Board_AfterRevealingUnrevealedCardAndNoActiveCard_CardRevealed() {
        let board = Board()
        board.cards = [Card(isRevealed: false, image: UIImage(), number: 0),
                       Card(isRevealed: true, image: UIImage(), number: 1)]
        
        board.reveal(card: board.cards.first!)
        
        XCTAssertTrue(board.cards.first!.isRevealed, "Unrevealded card should be revealed immediately")
        // After delay XCTAssertTrue(board.cards.first!.isRevealed, "Unrevealded card should stay revealed if there is no "active" card")
    }
    
    func test_Board_AfterRevealingUnrevealedCardAndMatchingActiveCard_CardRevealed() {
        let board = Board()
        board.cards = [Card(isRevealed: false, image: UIImage(), number: 0),
                       Card(isRevealed: false, image: UIImage(), number: 0)]
        
        board.reveal(card: board.cards.first!)
        board.reveal(card: board.cards.last!)
        
        XCTAssertTrue(board.cards.last!.isRevealed, "Unrevealded card should be revealed immediately")
        // After delay XCTAssertTrue(board.cards.last!.isRevealed, "Unrevealded card should stay revealed if there is no "active" card")
    }
    
    func test_Board_AfterRevealingUnrevealedCardAndNonMatchingActiveCard_CardRevealed() {
        let board = Board()
        
        board.cards = [Card(isRevealed: false, image: UIImage(), number: 0),
                       Card(isRevealed: false, image: UIImage(), number: 1)]
        
        board.reveal(card: board.cards.first!)
        board.reveal(card: board.cards.last!)
        
        XCTAssertTrue(board.cards.last!.isRevealed, "Unrevealded card should be revealed immediately")
        // After delay XCTAssertTrue(board.cards.last!.isRevealed, "Unrevealded card should stay revealed if there is no "active" card")
    }

}
