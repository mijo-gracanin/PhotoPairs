//
//  Board.swift
//  PhotoPairs
//
//  Created by Mijo Gracanin on 06.01.2023..
//

import Foundation
import Photos
import UIKit

@MainActor protocol CardCoordinator: AnyObject {
    func reveal(card: Card) async
}

enum Configuration {
    case live, preview, test
}

class Board: ObservableObject, CardCoordinator {
    @Published private(set) var isLoaded = false
    @Published private(set) var rowCount = 0
    @Published private(set) var colCount = 0
    @Published private(set) var cards: [Card] = []
    let boardPadding: CGFloat = 5
    let cardSpacing: CGFloat = 5
    var availableSize = CGSizeZero
    private var revealedCard: Card? = nil
    private var width: CGFloat = 100
    private var height: CGFloat = 100
    private let fetchLimit = 20
    private let flipInterval: DispatchTimeInterval
    private let photoLibrary: PhotoLibrary
    private let configuration: Configuration
    
    init(configuration: Configuration = .live) {
        self.configuration = configuration
        
        if configuration == .live {
            self.photoLibrary = ProdPhotoLibrary()
        } else {
            self.photoLibrary = MockPhotoLibrary()
        }
        
        if configuration == .test {
            flipInterval = .milliseconds(0)
        } else {
            flipInterval = .milliseconds(600)
        }
    }
    
    func loadCards() async throws {
        isLoaded = false
        
        let result = await photoLibrary.getRandomPhotos(width: width, height: height, limit: fetchLimit)
        let images = try result.get()
        
        for idx in 0..<images.count {
            let image = images[idx]
            cards.append(Card(image: image, number: idx))
            cards.append(Card(image: image, number: idx))
        }
        
        if configuration != .test {
            cards.shuffle()
        }
        calculateRowAndColCount(boardSize: availableSize)
        isLoaded = true
    }
    
    func reveal(card: Card) async {
        if card.isRevealed {
            return
        }
        
        card.isRevealed = true
        
        if let revealedCard {
            if revealedCard.number != card.number {
               await withCheckedContinuation { continuation in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: flipInterval), execute: DispatchWorkItem(block: {
                        revealedCard.isRevealed = false
                        card.isRevealed = false
                        continuation.resume()
                    }))
                }
            }
            self.revealedCard = nil
        } else {
            revealedCard = card
        }
    }
    
    var cardWidth: CGFloat {
        let spacingBetweenCards = CGFloat(colCount - 1) * cardSpacing
        let width = (availableSize.width - (2 * boardPadding) - spacingBetweenCards) / CGFloat(colCount)
        let height = (availableSize.height - (2 * boardPadding) - spacingBetweenCards) / CGFloat(rowCount)
        return width < height ? width : height
    }
    
    // MARK: - private
    private func calculateRowAndColCount(boardSize: CGSize) {
        let aspectRatio = boardSize.height / boardSize.width
        let root = sqrt(Double(cards.count) * Double(aspectRatio))
        let row1 = ceil(root)
        let row2 = floor(root)
        let col1 = ceil(Double(cards.count) / row1)
        let col2 = ceil(Double(cards.count) / row2)
        rowCount = Int(col1 == col2 ? row2 : row1)
        colCount = Int(col1 == col2 ? col2 : col1)
    }
    
    private func generateDistinctRanodmInts(inRange rangeMax: Int, count: Int) -> [Int] {
        var availableInts = Array<Int>(repeating: -1, count: rangeMax)
        var randomInts = [Int]()
        
        for _ in 0..<rangeMax {
            let idx = Int.random(in: 0..<availableInts.count)
            if availableInts[idx] > -1 {
                randomInts.append(availableInts[idx])
            } else {
                randomInts.append(idx)
            }
            availableInts[idx] = availableInts.last! > -1 ? availableInts.last! : availableInts.endIndex - 1
            _ = availableInts.popLast()
        }
        return randomInts
    }
}
