//
//  GameSavesView.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 7/25/24.
//

import SwiftUI
import GameKit
import SwiftData


/// The List of Game Saves View
struct GameSavesView: View {
	@Environment(\.modelContext) var modelContext
	@EnvironmentObject var gameKitTool: GameKitTool
	@State private var showingSheet = false
	@Query(sort: \GameData.creationDate, order: .reverse) var gameData: [GameData]
	@State var gameStated = true
	
	
	/// Deletes the game from swiftdata
	/// - Parameter indexSet: the index set of the delete
	func deleteGameData(_ indexSet: IndexSet){
		for index in indexSet{
			modelContext.delete(gameData[index])
			do {
			   try modelContext.save()
			} catch {
			   print(error)
			}
		}
	}
	
    var body: some View {
		NavigationStack{
			
			List{
				Section{
					ForEach(gameData.filter{$0.gameFinished == false}, id: \.id){ save in
						
						saveListItem(save: save)
					}
					
					.onDelete(perform: deleteGameData)
				}header: {
					Text("Active Saves")
				}
				
				Section{
					ForEach(gameData.filter{$0.gameFinished == true}, id: \.id){ save in
						
						saveListItem(save: save)
					}
					
					.onDelete(perform: deleteGameData)
				}header: {
					Text("Completed Saves")
				}
			}
			
			.navigationTitle("Saves")
			.toolbar{
				NavigationLink("New Game", destination: NewSaveView())
				EditButton()
				
			}
			.fullScreenCover(isPresented: $gameKitTool.playingGame, content: {
				PlayerDetailsView(gameData: gameKitTool.activeGame!)
			})
			
	
		}
    }
}

#Preview {
	do{
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: GameData.self, configurations: config)
  		let testGame = GameData(matchName: "Nothing", userPlayer: PlayerDetails(playerName: "Coleton", gamePlayerID: "Coleton2", teamPlayerID: "Coleton"), oppenents: [PlayerDetails(playerName: "Bob", gamePlayerID: "Bob", teamPlayerID: "Bo2b")])
		
		container.mainContext.insert(testGame)
		
		return GameSavesView()
			.environmentObject(GameKitTool())
			.modelContainer(container)
			

	}
	catch{
		return Text("Failed To load View")
	}
}

struct saveListItem: View{
	@Bindable var save: GameData
	@EnvironmentObject var gameKitTool: GameKitTool

	var body: some View{
		HStack{
			VStack(alignment: .leading){
				Text("\(save.matchName)")
				Text(save.creationDate.formatted(date: .long, time: .omitted))
				Text("Player: \(save.userPlayer.playerName) VP: \(save.userPlayer.realVp)")
				HStack{
					Text("Other Players:")
					ForEach(save.opponents){ player in
						HStack{
							Text("\(player.playerName) - \(player.realVp)")
						}
						
					}
				}
			}
			Spacer()
			NavigationLink{
				EditSaveView(newSaveName: save.matchName, gameData: save)

			}label: {
				
			}
			.frame(width: 1.0, height: 1.0)
		}
	}
}
struct EditSaveView: View {
	@Environment(\.modelContext) var modelContext
	@EnvironmentObject var gameKitTool: GameKitTool
	@State var newSaveName: String
	@Bindable var gameData: GameData
	var body: some View {
		Form{
			Section{
				TextField(text: $newSaveName){
					Text("Save Name")
				}
			}header: {
				Text("Save Name")
			}
			
			Section{
				Text("\(gameKitTool.user?.displayName ?? "")")
			}header: {
				Text("Player Details")
			}
		}
		.toolbar{
			ToolbarItem{
				Button{
					gameKitTool.startMatchmaking(gameData: gameData)
				}label: {
					Text("Start Game")
				}
				.disabled(newSaveName == "")
			}
		}
	}
}
struct NewSaveView: View{
	@Environment(\.modelContext) var modelContext
	@EnvironmentObject var gameKitTool: GameKitTool

	@Query var gameData: [GameData]

	@State var newSaveName: String = ""
	
	
	var body: some View{
		Form{
			Section{
				TextField(text: $newSaveName){
					Text("Save Name")
				}
			}header: {
				Text("Save Name")
			}
			
			Section{
				Text("\(gameKitTool.user?.displayName ?? "")")
			}header: {
				Text("Player Details")
			}
		}
		.toolbar{
			ToolbarItem{
				Button{
					let newGame = GameData(
						matchName: newSaveName,
						userPlayer: gameKitTool.userPlayer!,
						oppenents: [])
					modelContext.insert(newGame)
					do {
					   try modelContext.save()
					} catch {
					   print(error)
					}
					gameKitTool.startMatchmaking(gameData: newGame)
				}label: {
					Text("Start Game")
				}
				.disabled(newSaveName == "")
			}
		}
	}
}



