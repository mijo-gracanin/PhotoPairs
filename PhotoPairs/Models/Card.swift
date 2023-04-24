//
//  Card.swift
//  PhotoPairs
//
//  Created by Mijo Gracanin on 04.01.2023..
//

import Foundation
import UIKit

final class Card: ObservableObject {
    @Published var isRevealed = false
    let image: UIImage
    let number: Int
    
    init(isRevealed: Bool = false, image: UIImage, number: Int) {
        self.isRevealed = isRevealed
        self.image = image
        self.number = number
    }
}
