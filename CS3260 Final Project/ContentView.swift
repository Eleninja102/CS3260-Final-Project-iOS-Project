//
//  ContentView.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 5/9/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@StateObject private var game = GameKitController()

    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
		
		GameSavesView(game: game)
			.onAppear {
			if !game.playingGame {
				game.authenticatePlayer()
			}
		}
    }
	

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
