//
//  CardView.swift
//  PhotoPairs
//
//  Created by Mijo Gracanin on 02.01.2023..
//

import SwiftUI
import Combine

struct CardView: View {
    let mask = UIImage(systemName: "photo")!
    let time: CGFloat = 0
    
    @ObservedObject var card: Card
    var coordinator: CardCoordinator
    
    var body: some View {
        Button {
            coordinator.reveal(card: card)
        } label: {
            Image(uiImage: card.image)
                .resizable()
                .background(content: {
                    RoundedRectangle(cornerRadius: 10).fill(.green)
                })
                .cornerRadius(10.0)
                .cardFlip(isFaceUp: card.isRevealed)
                .animation(.linear, value: card.isRevealed)
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card(image: UIImage(systemName: "sun.max")!, number: 0), coordinator: Board())
            .frame(width: 80, height: 80)
    }
}
