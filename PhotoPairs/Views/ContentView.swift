//
//  ContentView.swift
//  PhotoPairs
//
//  Created by Mijo Gracanin on 31.12.2022..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { proxy in
            BoardView(availableSize: proxy.size)
                .frame(width: proxy.size.width, height: proxy.size.height)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Board(configuration: .preview))
    }
}
