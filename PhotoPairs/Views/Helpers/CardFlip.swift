//
//  CardFlip.swift
//  PhotoPairs
//
//  Created by Mijo Gracanin on 08.01.2023..
//

import Foundation
import SwiftUI

struct CardFlip: Animatable, ViewModifier {
    private var rotationAngle: CGFloat
    
    init(isFaceUp: Bool) {
        rotationAngle = isFaceUp ? 0 : 180
    }
    
    var animatableData: CGFloat {
        get { rotationAngle }
        set { rotationAngle = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.red.opacity(rotationAngle < 90 ? 0.0 : 1.0))
            content
                .opacity(rotationAngle < 90 ? 1.0 : 0.0)
        }
        .rotation3DEffect(.degrees(rotationAngle), axis: (0, 1, 0), perspective: 0.3)
    }
}

extension View {
    func cardFlip(isFaceUp: Bool) -> some View {
        modifier(CardFlip(isFaceUp: isFaceUp))
    }
}
