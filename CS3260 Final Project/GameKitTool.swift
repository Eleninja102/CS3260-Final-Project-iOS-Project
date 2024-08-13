//
//  GameKitTool.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 8/11/24.
//

import Foundation
import GameKit
import SwiftUI

class GameKitTool: NSObject, ObservableObject, GKGameCenterControllerDelegate{
	func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
		gameCenterViewController.dismiss(animated: true)

	}
	
	@Published var friends: [Friend] = []

	@Published var playingGame = false
	
	@Published var matchAvailable = false
	@Published var maxPlayers = 2
	@Published var minPlayers = 2
	@Published var myAvatar = Image(systemName: "person.crop.circle")
	@Environment(\.modelContext) var modelContext

	
	@Published var user: GKLocalPlayer? = nil

	//	@Published var activeGame: GameData? = GameData(matchName: "bob"
	var activeGame: GameData? = nil

//	@Published var myMatch: GKMatch? = nil
	
	var myName: String {
		GKLocalPlayer.local.displayName
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
	

	
	func authenticatePlayer() {
		// Set the authentication handler that GameKit invokes.
		GKLocalPlayer.local.authenticateHandler = { viewController, error in
			if let viewController = viewController {
				// If the view controller is non-nil, present it to the player so they can
				// perform some necessary action to complete authentication.
				self.rootViewController?.present(viewController, animated: true) { }
				return
			}
			if let error {
				// If you can’t authenticate the player, disable Game Center features in your game.
				print("Error: \(error.localizedDescription).")
				return
			}
			
			// A value of nil for viewController indicates successful authentication, and you can access
			// local player properties.
			
			// Load the local player's avatar.
			GKLocalPlayer.local.loadPhoto(for: GKPlayer.PhotoSize.small) { image, error in
				if let image {
					self.myAvatar = Image(uiImage: image)
				}
				if let error {
					// Handle an error if it occurs.
					print("Error: \(error.localizedDescription).")
				}
			}

			// Register for real-time invitations from other players.
			GKLocalPlayer.local.register(self)
			
			// Add an access point to the interface.
			GKAccessPoint.shared.location = .topLeading
			GKAccessPoint.shared.showHighlights = true
			GKAccessPoint.shared.isActive = true
			self.user = GKLocalPlayer()
			
			// Enable the Start Game button.
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
	
	func startMatchmaking(gameData: GameData){
		activeGame = gameData
		let request = GKMatchRequest()
		request.minPlayers = minPlayers
		request.maxPlayers = maxPlayers
		if let matchMakingVs = GKMatchmakerViewController(matchRequest: request){
			matchMakingVs.matchmakerDelegate = self
			rootViewController?.present(matchMakingVs, animated: true) { }
		}
	}
	
	func sendPhase(_ nextPhase: PhaseOptions){
		do{
			let data = encode(nextPhase: nextPhase)
			try activeGame?.myMatch?.sendData(toAllPlayers: data!, with: .reliable)
		}catch{
			print("Error: \(error.localizedDescription).")

		}
	}
	func readyPhase(_ ready: Bool){
		do{
			let data = encode(readyPhase: ready)
			try activeGame?.myMatch?.sendData(toAllPlayers: data!, with: .reliable)
		}catch{
			print("Error: \(error.localizedDescription).")

		}
	}
	func readyRound(_ ready: Bool){
		do{
			let data = encode(readyRound: ready)
			try activeGame?.myMatch?.sendData(toAllPlayers: data!, with: .reliable)
		}catch{
			print("Error: \(error.localizedDescription).")

		}
	}
	
	func updateBoard(_ type: String, by amount: Int){
		do{
			let data = encode(type: type, amount: amount)
//			print(activeGame?.myMatch!)
			for something in activeGame?.myMatch?.players ?? []{
				print(something.displayName)
			}
			try activeGame?.myMatch?.sendData(toAllPlayers: data!, with: .reliable)
		}catch{
			print("Error: \(error.localizedDescription).")

		}
	}

	
	func startMyMatchWith(match: GKMatch){
		GKAccessPoint.shared.isActive = false
		
		
		activeGame?.myMatch = match
		activeGame?.myMatch?.delegate = self
		
		if match.expectedPlayerCount == 0 {
			for player in match.players{
				player.loadPhoto(for: GKPlayer.PhotoSize.small) { (image, error) in
					
					if let image {
						self.activeGame?.opponents.append(PlayerDetails(playerName: player.displayName, gamePlayerID: player.gamePlayerID, teamPlayerID: player.teamPlayerID, avatar: Image(uiImage: image) ))
					}
					if let error {
						self.activeGame?.opponents.append(PlayerDetails(playerName: player.displayName, gamePlayerID: player.gamePlayerID, teamPlayerID: player.teamPlayerID))
						print("Error: \(error.localizedDescription).")
					}
				}
		
			}
			playingGame = true

		}
	}
	
}
