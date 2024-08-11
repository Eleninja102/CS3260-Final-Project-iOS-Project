//
//  GameDetails.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 7/25/24.
//

import SwiftUI



struct GameDetails: View {
	@State var x: GameSaves
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
		Text(x.saveName)
    }
}

#Preview {
	GameDetails(x: GameSaves(saveName: "Hello", timestamp: Date()))
}
