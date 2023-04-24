//
//  PhotoPairsApp.swift
//  PhotoPairs
//
//  Created by Mijo Gracanin on 31.12.2022..
//

import SwiftUI

@main
struct PhotoPairsApp: App {
    @StateObject private var board = Board()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(board)
        }
    }
}
