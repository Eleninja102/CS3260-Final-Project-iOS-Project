//
//  CardList.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 8/5/24.
//

import SwiftUI

struct CardList: View {
	init(){
		createCardList()
	}
	
		@State private var cardID: Int?
	@State private var cardName: String?
	@State private var searchText: String = ""
    var body: some View {
		NavigationStack{
			List{
				ForEach(searchResults){card in
					VStack(alignment: .leading){
						Text(card.cardName)
							.foregroundColor(card.color)
							
						Text("ID: \( String(card.id))")
							.font(.subheadline)
							.fontWeight(.thin)
							.multilineTextAlignment(.leading)
						Text("Cost: \( String(card.cost))")
							.font(.subheadline)
							.fontWeight(.thin)
							.multilineTextAlignment(.leading)
					}
				}
			}
		}
		.searchable(text: $searchText)
	}
	
	var searchResults: [ProjectCard] {
		if searchText.isEmpty {
			return ProjectCardList
		}

		return ProjectCardList.filter { $0.cardName.contains(searchText) || String($0.id).contains(searchText)}
	}
}

#Preview {
	CardList()
}
