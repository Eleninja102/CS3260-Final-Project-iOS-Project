//
//  ContentView.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 5/9/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@StateObject private var game: GameKitTool = GameKitTool()


    var body: some View {
		
		GameSavesView()
			.environmentObject(game)
			.onAppear {
			if !game.playingGame {
				game.authenticatePlayer()
			}
		}
    }
	
}

#Preview {
    ContentView()
}
