//
//  GameKitTool+GKMatchDelegate.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 8/11/24.
//
import Foundation
import GameKit
import SwiftUI

extension GameKitTool: GKMatchDelegate {
	/// Handles a connected, disconnected, or unknown player state.
	/// - Tag:didChange
	func match(_ match: GKMatch, player: GKPlayer, didChange state: GKPlayerConnectionState) {
		switch state {
		case .connected:
			print("\(player.displayName) Connected")


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
		// Decode the data representation of the game data.
		let matchData = decode(matchData: data)
		
		if let readyPhase = matchData?.readyPhase{
			activeGame?.opponents.first { $0.gamePlayerID == matchData?.gamePlayerID }?.readyForNextPhase = readyPhase
		}
		if let readyRound = matchData?.readyRound{
			activeGame?.opponents.first { $0.gamePlayerID == matchData?.gamePlayerID }?.readyForNextRound = readyRound
		}

		if let nextPhase = matchData?.nextPhase{
			activeGame?.opponents.first { $0.gamePlayerID == matchData?.gamePlayerID }?.nextRoundPhase = nextPhase
			if let ph = activeGame!.phases.firstIndex(where: {$0.name == nextPhase.rawValue}){
				self.activeGame?.phases[ph].playing = 1
			}
		}
		
		
		if let type = matchData?.type{
			let amount = matchData?.amount ?? 0
			switch type{
			case "oxygen":
				activeGame?.oxygen += amount
			case "temperature":
				activeGame?.temperature += amount
			case "oceans":
				activeGame?.oceans += amount
			default:
				print("Other type \(type) + \(amount)")
				break
			}
		
		}

		// Update the interface from the game data.
		if let score = matchData?.score {
			activeGame?.opponents.first { $0.gamePlayerID == matchData?.gamePlayerID }?.vp += score
			
		} else if let outcome = matchData?.outcome {
			// Show the outcome of the game.
			switch outcome {
			case "forfeit":
				break
			case "won":
				break
			case "lost":
				break
			default:
				return
			}
		}
	}
}


//struct MatchData: Codable {
//	var matchName: String?
//	var playerName: String
//	var score: Int?
//	var message: String?
//	var outcome: String?
//	var gamePlayerID: String
//	var nextPhase: PhaseOptions?
//	var readyPhase: Bool?
//	var type: String?
//	var amount: Int?
//	var readyRound: Bool?
//}


//			if match.expectedPlayerCount == 0 {
//				for player in match.players{
//					player.loadPhoto(for: GKPlayer.PhotoSize.small) { (image, error) in
//
//						if let image {
//							self.activeGame?.opponents.append(PlayerDetails(playerName: player.displayName, gamePlayerID: player.gamePlayerID, teamPlayerID: player.teamPlayerID, avatar: Image(uiImage: image) ))
//						}
//						if let error {
//							self.activeGame?.opponents.append(PlayerDetails(playerName: player.displayName, gamePlayerID: player.gamePlayerID, teamPlayerID: player.teamPlayerID))
//							print("Error: \(error.localizedDescription).")
//						}
//					}
//
//				}
//			}
