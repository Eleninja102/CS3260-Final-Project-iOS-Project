//
//  GameCenterController.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 8/6/24.
//


import Foundation
import GameKit
import SwiftUI
import Combine
import SwiftData
//struct TerraformingMarsGameData: Identifiable{
//	var id = UUID()
//	var matchName: String
//	var creationDate: Date = Date()
//	var oppenents: [Player] = []
//	var userPlayer: Player? = nil
//	var phases: [(name: String, playing: Int)] = [
//		(name: "Development", playing: 0),
//		(name:"Construction", playing: 0),
//		(name: "Action", playing: 0),
//		(name: "Production", playing: 1),
//		(name: "Research", playing: 0),
//	]
//	var phase: (name: String, playing: Int)?{
//		phases.first(where: {$0.1 == 1})
//	}
//	var oxygen = 0
//	var tempeture = -30
//	var oceans = 0
//	var myMatch: GKMatch? = nil
//}
//@Model
//class GameData: Identifiable{
//	@Transient var id = UUID()
//	var matchName: String
//	var creationDate: Date = Date.now
//	@Attribute(.externalStorage) var opponents: [Player] = []
////	@Published var oppenents: [Player] = [Player(playerName: "Bob")]
//
//	@Attribute(.externalStorage) var userPlayer: Player? = nil
//
//	var phases: [(name: String, playing: Int)] = [
//		(name: "Development", playing: 0),
//		(name:"Construction", playing: 0),
//		(name: "Action", playing: 0),
//		(name: "Production", playing: 1),
//		(name: "Research", playing: 0),
//	]
//	var phase: (name: String, playing: Int)?{
//		phases.first(where: {$0.1 == 1})
//	}
//	var oxygen = 0
//	var tempeture = -30
//	var oceans = 0
//	var myMatch: GKMatch? = nil
//	
//	init(matchName: String){
//		self.matchName = matchName
//	}
//	
//	init(id: UUID = UUID(), matchName: String, creationDate: Date = .now, userPlayer: Player? = nil, oppenents: [Player], phases: [(name: String, playing: Int)], oxygen: Int = 0, tempeture: Int = 30, oceans: Int = 0, myMatch: GKMatch? = nil) {
//		self.id = id
//		self.matchName = matchName
//		self.creationDate = creationDate
//		self.userPlayer = userPlayer
//		self.opponents = oppenents
//		self.phases = phases
//		self.oxygen = oxygen
//		self.tempeture = tempeture
//		self.oceans = oceans
//		self.myMatch = myMatch
//	}
//
//}



class GameData: ObservableObject, Identifiable{
	@Published var id = UUID()
	@Published var matchName: String
	@Published var creationDate: Date = Date()
	@Published var opponents: [Player] = []
//	@Published var oppenents: [Player] = [Player(playerName: "Bob")]

	@Published var userPlayer: Player? = nil

	@Published var phases: [(name: String, playing: Int)] = [
		(name: "Development", playing: 0),
		(name:"Construction", playing: 0),
		(name: "Action", playing: 0),
		(name: "Production", playing: 1),
		(name: "Research", playing: 0),
	]
	var phase: (name: String, playing: Int)?{
		phases.first(where: {$0.1 == 1})
	}
	@Published var oxygen = 0
	@Published var tempeture = -30
	@Published var oceans = 0
	@Published var myMatch: GKMatch? = nil
	
	init(matchName: String){
		self.matchName = matchName
	}
	
	init(id: UUID = UUID(), matchName: String, creationDate: Date, userPlayer: Player? = nil, oppenents: [Player], phases: [(name: String, playing: Int)], oxygen: Int = 0, tempeture: Int = 30, oceans: Int = 0, myMatch: GKMatch? = nil) {
		self.id = id
		self.matchName = matchName
		self.creationDate = creationDate
		self.userPlayer = userPlayer
		self.opponents = oppenents
		self.phases = phases
		self.oxygen = oxygen
		self.tempeture = tempeture
		self.oceans = oceans
		self.myMatch = myMatch
	}

}

struct barControls{
	var range: ClosedRange<Int>
	var increament: Int
	var purpleRange: ClosedRange<Int>
	var redRange: ClosedRange<Int>
	var yellowRange: ClosedRange<Int>
	var whiteRange: ClosedRange<Int>

}


class GameKitController: NSObject, ObservableObject{
	@Published var playingGame = false
	
	@Published var matchAvailable = false
	@Published var maxPlayers = 2
	@Published var minPlayers = 2
	@Published var userPlayer: Player? = nil
//	@Published var userPlayer: Player = Player(playerName: "Bpb")
	@Published var user: GKLocalPlayer? = nil
	@Published var savedGames: [GameData] = []
//	@Published var activeGame: GameData? = GameData(matchName: "bob"
	@Published var activeGame: GameData? = nil

	@Published var gameSaveName: String = ""
	
	var oxygenRange: barControls = barControls(range: 0...14, increament: 1, purpleRange: 0...2, redRange: 3...6, yellowRange: 7...11, whiteRange: 12...14)
	var tempetureRange = barControls(range: -30...8, increament: 2, purpleRange: -30...(-20), redRange: -18...(-10), yellowRange: -8...0, whiteRange: 2...8)
	var oceansRange = barControls(range: 1...9, increament: 1, purpleRange: 0...1, redRange: 2...4, yellowRange: 5...7, whiteRange: 8...9)
	
	var userName: String {
		GKLocalPlayer.local.displayName
	}
	
	func update() {
		objectWillChange.send()
	}
	

	var rootViewController: UIViewController? {
		let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
		return windowScene?.windows.first?.rootViewController
	}
	
	func reportProgress() {
		GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
			let achievementID = "1234"
			var achievement: GKAchievement? = nil

			// Find an existing achievement.
			achievement = achievements?.first(where: { $0.identifier == achievementID })

			// Otherwise, create a new achievement.
			if achievement == nil {
				achievement = GKAchievement(identifier: achievementID)
			}

			// Create an array containing the achievement.
			let achievementsToReport: [GKAchievement] = [achievement!]

			// Set the progress for the achievement.
			achievement?.percentComplete = achievement!.percentComplete + 10.0

			// Report the progress to Game Center.
			GKAchievement.report(achievementsToReport, withCompletionHandler: {(error: Error?) in
				if let error {
					print("Error: \(error.localizedDescription).")
				}
			})

			if let error {
				print("Error: \(error.localizedDescription).")
			}
		})
	}
	

	

	
	func authenticatePlayer(){
		GKLocalPlayer.local.authenticateHandler = { viewController, error in
			if let viewController = viewController {
				// Present the view controller so the player can sign in.
				self.rootViewController?.present(viewController, animated: true) { }

				return
			}
			if let error {
				// If you can’t authenticate the player, disable Game Center features in your game.
				print("Error: \(error.localizedDescription).")
				return
			}
			GKLocalPlayer.local.register(self)
			GKLocalPlayer.local.loadPhoto(for: GKPlayer.PhotoSize.small) { image, error in
				if let image {
					self.userPlayer = Player(playerName: GKLocalPlayer.local.displayName, player: GKLocalPlayer.local, avatar: Image(uiImage: image))
					
					self.user = GKLocalPlayer.local

				}
				if let error {
					print("Error With Photo Loading: \(error.localizedDescription).")
				}
			}

			// Player was successfully authenticated.
			// Check if there are any player restrictions before starting the game.
			
			

			self.matchAvailable = true
		}
	}
	func makeMatch() {
	  let request = GKMatchRequest()
		request.minPlayers = minPlayers
		request.maxPlayers = maxPlayers
		request.inviteMessage = "Game Anyone?"
		request.defaultNumberOfPlayers = 3
		let vc = GKMatchmakerViewController(matchRequest: request)
		vc?.matchmakerDelegate = self
		
		rootViewController?.present(vc!, animated: true)
	}
	/// Starts the matchmaking process where GameKit finds a player for the match.
	/// - Tag:findPlayer
	func findPlayer() async {
		let request = GKMatchRequest()
		request.minPlayers = minPlayers
		request.maxPlayers = maxPlayers
		let match: GKMatch
		
		// If you use matchmaking rules, set the GKMatchRequest.queueName property here. If the rules use
		// game-specific properties, set the local player's GKMatchRequest.properties too.
		
		// Start automatch.
		do {
			match = try await GKMatchmaker.shared().findMatch(for: request)
		} catch {
			print("Error: \(error.localizedDescription).")
			return
		}

		// Start the game, although the automatch player hasn't connected yet.
		if !playingGame {
			startMyMatchWith(match: match)
		}

		// Stop automatch.
		GKMatchmaker.shared().finishMatchmaking(for: match)
	}
	
	
	func choosePlayer() {
		// Create a match request.
		let request = GKMatchRequest()
		request.minPlayers = minPlayers
		request.maxPlayers = maxPlayers
		
		// If you use matchmaking rules, set the GKMatchRequest.queueName property here. If the rules use
		// game-specific properties, set the local player's GKMatchRequest.properties too.
		
		// Present the interface where the player selects opponents and starts the game.
		if let viewController = GKMatchmakerViewController(matchRequest: request) {
			viewController.matchmakerDelegate = self
			rootViewController?.present(viewController, animated: true) { }
		}
	}
	
	func startMatchmaking(){
		let request = GKMatchRequest()
		request.minPlayers = minPlayers
		request.maxPlayers = maxPlayers
		if let matchMakingVs = GKMatchmakerViewController(matchRequest: request){
			matchMakingVs.matchmakerDelegate = self
			rootViewController?.present(matchMakingVs, animated: true) { }
		}
	}
	
	func loadSavedGame(savedGame: GameData){
		activeGame = savedGame
		let request = GKMatchRequest()
		request.minPlayers = minPlayers
		request.maxPlayers = maxPlayers
		if let matchMakingVs = GKMatchmakerViewController(matchRequest: request){
			matchMakingVs.matchmakerDelegate = self
			rootViewController?.present(matchMakingVs, animated: true) { }
		}
	}

	
	func startMyMatchWith(match: GKMatch){
		GKAccessPoint.shared.isActive = false
		if(activeGame == nil){
			savedGames.append(GameData(matchName: gameSaveName))
			self.activeGame = savedGames.last

		}
		activeGame?.myMatch = match
		activeGame?.myMatch?.delegate = self
		
		
		activeGame?.userPlayer = userPlayer
		
		if let players = activeGame?.myMatch?.players{
			for player2 in players{
				player2.loadPhoto(for: GKPlayer.PhotoSize.small) { (image, error) in
					let playerImage = image == nil ? Image(systemName: "person.crop.circle"): Image(uiImage: image!)
					let newPlayer = Player(playerName: player2.displayName, player: player2, avatar: playerImage)
					DispatchQueue.main.async {
						if self.activeGame?.opponents.contains(where: { $0.player?.gamePlayerID == newPlayer.player?.gamePlayerID }) ?? false {
							print("TRUEEE")
						}else{
							self.activeGame?.opponents.append(newPlayer)

						}
					}
				}
			}
		}
		playingGame = true

	}
	
	
	func receivedString(_ message: String){
		let messageSplit = message.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
		guard let messagePrefix = messageSplit.first else {return}
		
		let parameter = messageSplit.last ?? ""
		
		print(parameter)
		
		for oppenent in activeGame!.opponents {
			print(oppenent)
		}
		
		switch messagePrefix {
		case "began":
			break
		case "ready":
			break
		case "roundReady":
			if let opponent = activeGame!.opponents.firstIndex(where: {$0.player?.gamePlayerID ?? "1" == parameter}){
				self.activeGame!.opponents[opponent].readyForNextRound = true
			}
		case "phaseReady":
			if let opponent = activeGame!.opponents.firstIndex(where: {($0.player?.gamePlayerID ?? "1") == String(parameter)}){
				print(activeGame!.opponents[opponent])
				self.activeGame!.opponents[opponent].readyForNextPhase = true
			}
		case "addPhase":
			if let ph = activeGame!.phases.firstIndex(where: {$0.name == parameter}){
				self.activeGame!.phases[ph].playing = 1
			}
		case "ocean":
			self.activeGame!.oceans += Int(parameter) ?? 0
		case "tempeture":
			self.activeGame!.tempeture += Int(parameter) ?? 0
		case "oxygen":
			self.activeGame!.oxygen += Int(parameter) ?? 0
		default:
			break
		}
		
		update()
	}

}


extension GameKitController: GKLocalPlayerListener {
	/// Handles when the local player sends requests to start a match with other players.
	func player(_ player: GKPlayer, didRequestMatchWithRecipients recipientPlayers: [GKPlayer]) {
		print("\n\nSending invites to other players.")
	}
	
	/// Presents the matchmaker interface when the local player accepts an invitation from another player.
	func player(_ player: GKPlayer, didAccept invite: GKInvite) {
		// Present the matchmaker view controller in the invitation state.
		if let viewController = GKMatchmakerViewController(invite: invite) {
			viewController.matchmakerDelegate = self
			rootViewController?.present(viewController, animated: true) { }
		}
	}
	
}

extension GameKitController{
	func loadSavedGame(_ player: GKPlayer){
		
	}
	
}

extension GameKitController: GKMatchmakerViewControllerDelegate {
	/// Dismisses the matchmaker interface and starts the game when a player accepts an invitation.
	func matchmakerViewController(_ viewController: GKMatchmakerViewController,
								  didFind match: GKMatch) {
		// Dismiss the view controller.
		viewController.dismiss(animated: true) { }
		
		// Start the game with the player.
		if(match.expectedPlayerCount == 0){
			startMyMatchWith(match: match)

		}
		
	}
	
	/// Dismisses the matchmaker interface when either player cancels matchmaking.
	func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
		viewController.dismiss(animated: true)
	}
	
	/// Reports an error during the matchmaking process.
	func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
		print("\n\nMatchmaker view controller fails with error: \(error.localizedDescription)")
		viewController.dismiss(animated: true)

	}
}

extension GameKitController: GKMatchDelegate {
//	func decode(matchData: Data) -> GameData? {
//		// Convert the data object to a game data object.
//		return try? PropertyListDecoder().decode(GameData.self, from: matchData)
//	}
	
	func sendData(_ data: Data, mode: GKMatch.SendDataMode){
		
		do{
			try activeGame?.myMatch?.sendData(toAllPlayers: data, with: mode)
			
		}catch{
			print("Failed to send data\(error)")
		}
		
	}
	
	func sendString(_ message: String){
		guard let encoded = "strData:\(message)".data(using: .utf8) else {return}
		sendData(encoded, mode: .reliable)
	}
	/// Handles a connected, disconnected, or unknown player state.
	/// - Tag:didChange
	func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
		switch state {
		case .connected:
			print("\(player.displayName) Connected")
			
			// For automatch, set the opponent and load their avatar.
			if match.expectedPlayerCount == 0 {
//				opponent = match.players[0]
//				
//				// Load the opponent's avatar.
//				opponent?.loadPhoto(for: GKPlayer.PhotoSize.small) { (image, error) in
//					if let image {
//						self.opponentAvatar = Image(uiImage: image)
//					}
//					if let error {
//						print("Error: \(error.localizedDescription).")
//					}
//				}
			}
		case .disconnected:
			print("\(player.displayName) Disconnected")
		default:
			print("\(player.displayName) Connection Unknown")
		}
	}
	
	/// Handles an error during the matchmaking process.
	func match(_ match: GKMatch, didFailWithError error: Error?) {
		print("\n\nMatch object fails with error: \(error!.localizedDescription)")
	}

	/// Reinvites a player when they disconnect from the match.
	func match(_ match: GKMatch, shouldReinviteDisconnectedPlayer player: GKPlayer) -> Bool {
		return false
	}
	
	/// Handles receiving a message from another player.
	/// - Tag:didReceiveData
	func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
		
		let content = String(decoding: data, as: UTF8.self)
		
		if content.starts(with: "strData:"){
			let message = content.replacing("strData", with: "")
			receivedString(message)
			return
		}
		
		do{
			print(data)
			print(content)
			
		}catch{
			print(error)
		}
		
	}
}
