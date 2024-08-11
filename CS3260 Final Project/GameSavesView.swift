//
//  GameSavesView.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 7/25/24.
//

import SwiftUI
import GameKit

struct GameSavesView: View {

	@State private var showingSheet = false
	@ObservedObject var game: GameKitController
	@State var gameStated = true
	
	@State var defaultPlayer = Player(playerName: "Fake Bob")
	private let dateFormatter: DateFormatter = {
		   let formatter = DateFormatter()
		   formatter.dateStyle = .medium
		   return formatter
	   }()
	
	func startGame(){
		
	}
	
    var body: some View {
		NavigationStack{
			
			List{
				Section{
					
					ForEach(game.savedGames, id: \.id){ save in
						HStack{
							VStack(alignment: .leading){
								Text("\(save.matchName)")
								Text(dateFormatter.string(from: save.creationDate))
								HStack{
									Text("Other Players:")
									ForEach(save.oppenents){ player in
										HStack{
											Text("\(player.playerName) - \(player.vp)")
										}
										
									}
								}
							}
							Spacer()
							Button{
								game.loadSavedGame(savedGame: save)
							}label: {
								Image(systemName: "arrowtriangle.forward")
									.bold()
							}
						}
						
						
						}
						
					.onDelete(perform: { indexSet in
						game.savedGames.remove(atOffsets: indexSet)
					})
					.onMove { game.savedGames.move(fromOffsets: $0, toOffset: $1) }
				}header: {
					Text("Active Saves")
				}
//				Section{
//					ForEach(completedGames){ save in
//							VStack(alignment: .leading){
//								Text(save.saveName)
//								Text(dateFormatter.string(from: save.creationDate))
//								HStack{
//									Text("Players:")
//									ForEach(save.Players){ player in
//										Text(player.playerName)
//									}
//								}
//								
//						}
//						
//					}
//					.onDelete(perform: { indexSet2 in
//						completedGames.remove(atOffsets: indexSet2)
//					})
//					.onMove { completedGames.move(fromOffsets: $0, toOffset: $1) }
//					
//				}header: {
//					Text("Completed Saves")
//				}

			}
			.navigationTitle("Saves")
			.toolbar{
				NavigationLink(destination: NewSaveView(game: game)) {
					Text("New Game")
				}
				EditButton()
				
			}
			.fullScreenCover(isPresented: $game.playingGame, content: {
//				PlayerDetailsView(playerDetails: $game.activeGame.userPlayer, gameKitContoller: game, game: game.activeGame!)
			})
			
	
		}
    }
}

#Preview {
	GameSavesView(game: GameKitController())
}

struct NewSaveView: View{
	@ObservedObject var game: GameKitController
	@State var newSaveName: String = ""
	@State var playerName: String = ""
	
	
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
				Text("\(game.user?.displayName ?? "")")
			}header: {
				Text("Player Details")
			}
		}
		.toolbar{
			ToolbarItem{
				Button{
					game.gameSaveName = newSaveName
					game.startMatchmaking()
				}label: {
					Text("Start Game")
				}
			}
		}
	}
}



