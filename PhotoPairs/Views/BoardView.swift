//
//  BoardView.swift
//  PhotoPairs
//
//  Created by Mijo Gracanin on 06.01.2023..
//

import SwiftUI

struct BoardView: View {
    @StateObject private var board = Board()
    @State private var boardPadding: CGFloat = 5
    @State private var cardSpacing: CGFloat = 5
    var availableSize: CGSize
    var rows: [GridItem] {
        Array(repeating: GridItem(.fixed(cardWidth)), count: board.rowCount)
    }
    
    var body: some View {
        if board.colCount > 0 {
            LazyHGrid(rows: rows, spacing: cardSpacing) {
                ForEach(board.cards.indices, id: \.self) { idx in
                    CardView(card: board.cards[idx], coordinator: board)
                        .frame(width: cardWidth, height: cardWidth)
                }
            }
            .padding(.all, boardPadding)
        } else {
            ProgressView()
                .onAppear {
                    board.loadCards(boardSize: availableSize)
                }
        }
    }
    
    var cardWidth: CGFloat {
        let spacingBetweenCards = CGFloat(board.colCount - 1) * cardSpacing
        let width = (availableSize.width - (2 * boardPadding) - spacingBetweenCards) / CGFloat(board.colCount)
        let height = (availableSize.height - (2 * boardPadding) - spacingBetweenCards) / CGFloat(board.rowCount)
        return width < height ? width : height
    }
}


struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            BoardView(availableSize: proxy.size)
        }
       
    }
}
