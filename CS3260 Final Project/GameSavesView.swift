//
//  GameSavesView.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 7/25/24.
//

import SwiftUI
import GameKit
import SwiftData

struct GameSavesView: View {
	@Environment(\.modelContext) var modelContext
	@EnvironmentObject var gameKitTool: GameKitTool
	@State private var showingSheet = false
	@Query var gameData: [GameData]
	@State var gameStated = true
	
	@State var defaultPlayer = Player(playerName: "Fake Bob")
	
	
	
	func startGame(){
		
	}
	func deleteGameData(_ indexSet: IndexSet){
		for index in indexSet{
			let game = gameData[index]
			modelContext.delete(game)
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
				Text("Player: \(save.userPlayer.playerName) VP: \(save.userPlayer.vp)")
				HStack{
					Text("Other Players:")
					ForEach(save.opponents){ player in
						HStack{
							Text("\(player.playerName) - \(player.vp)")
						}
						
					}
				}
			}
			Spacer()
			Button{
				gameKitTool.startMatchmaking(gameData: save)

			}label: {
				Image(systemName: "arrowtriangle.forward")
					.bold()
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
					let newGame = GameData(matchName: newSaveName, userPlayer: PlayerDetails(playerName: gameKitTool.user!.displayName, gamePlayerID: gameKitTool.user!.gamePlayerID, teamPlayerID: gameKitTool.user!.teamPlayerID), oppenents: [])
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



