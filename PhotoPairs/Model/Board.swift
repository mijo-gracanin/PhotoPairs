//
//  Board.swift
//  PhotoPairs
//
//  Created by Mijo Gracanin on 06.01.2023..
//

import Foundation
import Photos
import UIKit

protocol CardCoordinator: AnyObject {
    func reveal(card: Card)
}

class Board: ObservableObject, CardCoordinator {
    @Published var isLoaded = false
    @Published var rowCount = 0
    @Published var colCount = 0
    var cards: [Card] = []
    private var revealedCard: Card? = nil
    private var waitingAuthorisation = false
    private var width: CGFloat = 100
    private var height: CGFloat = 100
    private let fetchLimit = 20
    
    func loadCards(boardSize: CGSize) {
        if waitingAuthorisation {
            return
        }
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if authorizationStatus != .authorized {
            waitingAuthorisation = true
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                DispatchQueue.main.async {
                    if let self {
                        self.waitingAuthorisation = false
                        if status == .authorized || status == .limited {
                            self.loadCards(boardSize: boardSize)
                        }
                    }
                }
            }
        }
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        let count = fetchResult.count > fetchLimit ? fetchLimit : fetchResult.count
        
        let randomIndices = generateDistinctRanodmInts(inRange: fetchResult.count, count: count)
        
        for idx in 0..<count {
            let asset = fetchResult.object(at: randomIndices[idx])
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: width, height: height),
                contentMode: .aspectFit,
                options: nil
            ) { [weak self] image, info in
                guard let self = self, let image = image, let isDegraded = info?[PHImageResultIsDegradedKey] as? NSNumber else {
                    fatalError("\(info ?? [:])")
                }
                
                guard !isDegraded.boolValue else {
                    return
                }
                
                self.cards.append(Card(image: image, number: idx))
                self.cards.append(Card(image: image, number: idx))
                if self.cards.count == count * 2 {
                    self.cards.shuffle()
                    self.calculateRowAndColCount(boardSize: boardSize)
                    self.isLoaded = true
                }
            }
        }
    }
    
    func reveal(card: Card) {
        if card.isRevealed {
            return
        }
        
        card.isRevealed = true
        
        if let revealedCard {
            if revealedCard.number != card.number {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now().advanced(by: .milliseconds(600)), execute: DispatchWorkItem(block: {
                    revealedCard.isRevealed = false
                    card.isRevealed = false
                }))
            }
            self.revealedCard = nil
        } else {
            revealedCard = card
        }
    }
    
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
