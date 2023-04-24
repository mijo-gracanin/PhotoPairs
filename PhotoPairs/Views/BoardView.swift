//
//  BoardView.swift
//  PhotoPairs
//
//  Created by Mijo Gracanin on 06.01.2023..
//

import SwiftUI

struct BoardView: View {
    @EnvironmentObject var board: Board
    private var availableSize: CGSize
    
    init(availableSize: CGSize) {
        self.availableSize = availableSize
    }

    var rows: [GridItem] {
        Array(repeating: GridItem(.fixed(board.cardWidth)), count: board.rowCount)
    }
    
    var body: some View {
        if board.isLoaded {
            LazyHGrid(rows: rows, spacing: board.cardSpacing) {
                ForEach(board.cards.indices, id: \.self) { idx in
                    CardView(card: board.cards[idx], coordinator: board)
                        .frame(width: board.cardWidth, height: board.cardWidth)
                }
            }
            .padding(.all, board.boardPadding)
        } else {
            ProgressView()
                .onAppear {
                    board.availableSize = availableSize
                    Task {
                        try? await board.loadCards()
                    }
                }
        }
    }
}


struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            BoardView(availableSize: proxy.size)
                .environmentObject(Board(configuration: .preview))
        }
       
    }
}
