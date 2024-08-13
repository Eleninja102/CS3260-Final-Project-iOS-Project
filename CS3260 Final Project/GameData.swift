//
//  GameData.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 8/11/24.
//

import Foundation
import SwiftData
import SwiftUI
import GameKit



struct barControls: Codable{
	var range: ClosedRange<Int>
	var increament: Int
	var purpleRange: ClosedRange<Int>
	var redRange: ClosedRange<Int>
	var yellowRange: ClosedRange<Int>
	var whiteRange: ClosedRange<Int>
	var max: Int

}

struct phaseDetails: Codable, Equatable{
	var name: String
	var playing: Int
}


@Model
class GameData: Identifiable{
	@Transient var id = UUID()
	
	var matchName: String
	var creationDate: Date = Date.now
	var gameFinished: Bool = false
	
	@Relationship(deleteRule: .cascade) var opponents: [PlayerDetails] = []
//	@Published var oppenents: [Player] = [Player(playerName: "Bob")]

	@Relationship(deleteRule: .cascade) var userPlayer: PlayerDetails
	@Relationship(deleteRule: .cascade) var winnerPlayer: PlayerDetails? = nil


	@Transient var oxygenRange: barControls = barControls(range: 0...14, increament: 1, purpleRange: 0...2, redRange: 3...6, yellowRange: 7...11, whiteRange: 12...14, max: 14)
	@Transient var temperatureRange = barControls(range: -30...8, increament: 2, purpleRange: -30...(-20), redRange: -18...(-10), yellowRange: -8...0, whiteRange: 2...8, max: 8)
	@Transient var oceansRange = barControls(range: 1...9, increament: 1, purpleRange: 0...1, redRange: 2...4, yellowRange: 5...7, whiteRange: 8...9, max: 9)
	
	
	var phases: [phaseDetails] = [
		phaseDetails(name: "Development", playing: 0),
		phaseDetails(name:"Construction", playing: 0),
		phaseDetails(name: "Action", playing: 0),
		phaseDetails(name: "Production", playing: 1),
		phaseDetails(name: "Research", playing: 0),
	]
	
	
	var phase: phaseDetails?{
		phases.first(where: {$0.playing == 1})
	}
	var oxygen = 0
	var temperature = -30
	var oceans = 0
	@Transient var myMatch: GKMatch? = nil
	

	
	init(id: UUID = UUID(), matchName: String, creationDate: Date = .now, userPlayer: PlayerDetails, oppenents: [PlayerDetails], phases: [phaseDetails] = [
		phaseDetails(name: "Development", playing: 0),
		phaseDetails(name:"Construction", playing: 0),
		phaseDetails(name: "Action", playing: 0),
		phaseDetails(name: "Production", playing: 1),
		phaseDetails(name: "Research", playing: 0),
	]
		, oxygen: Int = 0, temperature: Int = -30, oceans: Int = 0, myMatch: GKMatch? = nil
		 , gameFinished: Bool = false
	, winnerPlayer: PlayerDetails? = nil
	) {
		self.id = id
		self.matchName = matchName
		self.creationDate = creationDate
		self.userPlayer = userPlayer
		self.opponents = oppenents
		self.phases = phases
		self.oxygen = oxygen
		self.temperature = temperature
		self.oceans = oceans
		self.myMatch = myMatch
		self.gameFinished = gameFinished
		self.winnerPlayer = winnerPlayer
	}
	

}
