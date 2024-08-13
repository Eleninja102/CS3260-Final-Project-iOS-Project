//
//  GameKItTool+MatchData.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 8/11/24.
//

import Foundation
import GameKit
import SwiftUI

struct MatchData: Codable {
	var matchName: String?
	var playerName: String
	var score: Int?
	var message: String?
	var outcome: String?
	var gamePlayerID: String
	var nextPhase: PhaseOptions?
	var readyPhase: Bool?
	var type: String?
	var amount: Int?
	var readyRound: Bool?
}

extension GameKitTool {
	
	func encode(type: String, amount: Int) -> Data?{
		let matchData = MatchData(playerName: GKLocalPlayer.local.displayName, gamePlayerID: GKLocalPlayer.local.gamePlayerID, type: type, amount: amount)
		return encode(matchData: matchData)
	}
	

	/// Creates a data representation of a text message for sending to other players.
	///
	/// - Parameter message: The message that the local player enters.
	/// - Returns: A representation of game data that contains only a message.
	func encode(message: String? = nil, score: Int? = nil, outcome: String? = nil, nextPhase: PhaseOptions? = nil, readyPhase: Bool? = nil, readyRound: Bool? = nil) -> Data? {
		let matchData = MatchData(matchName: "", playerName: GKLocalPlayer.local.displayName, score: score, message: message, outcome: outcome, gamePlayerID: GKLocalPlayer.local.gamePlayerID, nextPhase: nextPhase, readyPhase: readyPhase, readyRound: readyRound)
		return encode(matchData: matchData)
	}
	
	
	/// Creates a data representation of game data for sending to other players.
	///
	/// - Returns: A representation of game data.
	func encode(matchData: MatchData) -> Data? {
		let encoder = PropertyListEncoder()
		encoder.outputFormat = .xml
		
		do {
			let data = try encoder.encode(matchData)
			return data
		} catch {
			print("Error: \(error.localizedDescription).")
			return nil
		}
	}
	
	/// Decodes a data representation of match data from another player.
	///
	/// - Parameter matchData: A data representation of the game data.
	/// - Returns: A game data object.
	func decode(matchData: Data) -> MatchData? {
		// Convert the data object to a game data object.
		return try? PropertyListDecoder().decode(MatchData.self, from: matchData)
	}
}
