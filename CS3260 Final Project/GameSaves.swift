//
//  GameSaves.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 5/9/24.
//

import Foundation
import SwiftData
import SwiftUI

import GroupActivities
import GameKit


var metadata: GroupActivityMetadata {
	var metadata = GroupActivityMetadata()

	metadata.title = "Play a Game Together"

	metadata.type = .generic

	return metadata
}

struct OrderTogether: GroupActivity {
	// Define a unique activity identifier for system to reference
	static let activityIdentifier = "com.coletonwatt.FinalProject.playagametogther"

	// App-specific data so your app can launch the activity on others' devices
	let orderUUID: UUID
	let saveName: String

	var metadata: GroupActivityMetadata {
		var metadata = GroupActivityMetadata()
		metadata.title = "Play a TM \(saveName) Together"
		metadata.type = .generic
		return metadata
	}
}



@Model
final class GameSaves {
	var saveName: String
	var timestamp: Date
	var finished: Bool = false
	init(saveName: String, timestamp: Date) {
		self.saveName = saveName
		self.timestamp = timestamp
	}
}
//var testPlayers: [Player] = [Player(playerName: "Bob"), Player(playerName: "Bob")]


class Game: Identifiable{
	var id = UUID()

	var Players: [Player]
	var saveName: String
	var creationDate: Date = Date()
	var finished: Bool = false
	
	var phases: [(name: String, playing: Int)] = [
		(name: "Development", playing: 0),
		(name:"Construction", playing: 0),
		(name: "Action", playing: 0),
		(name: "Production", playing: 0),
		(name: "Research", playing: 0),
	]
	init(Players: [Player], saveName: String) {
		self.Players = Players
		self.saveName = saveName
	}
}

class PlayerDetails: Identifiable, Codable{
	var id = UUID()
	var playerName: String
	
	var gamePlayerID: String
	
	var vp: Int = 0
	var tr: Int = 0
	var trees: Int = 0
	var megaCoins: Int = 0
	var megaCoinsProduction: Int = 4
   
	var heat: Int = 0
	var heatProduction: Int = 2
   
	var plants: Int = 0
	var plantsProduction: Int = 3
   
	var steel: Int = 2
	var steelDiscount: Int = 2
	var titanium: Int = 3
	var titaniumDiscount: Int = 3
   
	var cardProduction: Int = 2
   
	var readyForNextRound: Bool = false
	var readyForNextPhase: Bool = false
   
	var selectedPhase: String = ""
   
}

struct Player: Identifiable{
	var id = UUID()

	var playerName: String
	 var player: GKPlayer? = nil
	 var avatar = Image(systemName: "person.crop.circle")
	
	 var vp: Int = 0
	 var tr: Int = 0
	 var trees: Int = 0
	
	 var megaCoins: Int = 0
	 var megaCoinsProduction: Int = 4
	
	 var heat: Int = 0
	 var heatProduction: Int = 2
	
	 var plants: Int = 0
	 var plantsProduction: Int = 3
	
	 var steel: Int = 2
	 var steelDiscount: Int = 2
	 var titanium: Int = 3
	 var titaniumDiscount: Int = 3
	
	 var cardProduction: Int = 2
	
	 var readyForNextRound: Bool = false
	 var readyForNextPhase: Bool = false
	
	 var selectedPhase: String = ""
	
	 var nextRoundPhase: PhaseOptions = .None
}
//class Player: ObservableObject, Identifiable{
//	@Published var id = UUID()
//
//	@Published var playerName: String
//	@Published var player: GKPlayer? = nil
//	@Published var avatar = Image(systemName: "person.crop.circle")
//	
//	@Published var vp: Int = 0
//	@Published var tr: Int = 0
//	@Published var trees: Int = 0
//	
//	@Published var megaCoins: Int = 0
//	@Published var megaCoinsProduction: Int = 4
//	
//	@Published var heat: Int = 0
//	@Published var heatProduction: Int = 2
//	
//	@Published var plants: Int = 0
//	@Published var plantsProduction: Int = 3
//	
//	@Published var steel: Int = 2
//	@Published var steelDiscount: Int = 2
//	@Published var titanium: Int = 3
//	@Published var titaniumDiscount: Int = 3
//	
//	@Published var cardProduction: Int = 2
//	
//	@Published var readyForNextRound: Bool = false
//	@Published var readyForNextPhase: Bool = false
//	
//	@Published var selectedPhase: String = ""
//	
//	@Published var nextRoundPhase: PhaseOptions = .None
//	
//	init(playerName: String){
//		self.playerName = playerName
//	}
//	
//	init(playerName: String, player: GKPlayer, avatar: Image) {
//		self.playerName = playerName
//		self.player = player
//		self.avatar = avatar
//	}
//	
//}


@Model
final class Corporation{
	@Attribute(.unique) var name: String
	var desc: String
	
	var ability: String
	
	init(name: String, description: String, ability: String) {
		self.name = name
		self.desc = description
		self.ability = ability
	}
	
}



//enum Tags: String, Identifiable, CaseIterable{
//	case Building, Space, Power, Science, Jovian, Earth, Plant, Microbe
//	var id: Self {self}
//}
struct ProjectCard: Identifiable, Hashable{
	var id: Int
	var cardName: String
	var color: Color
	var cost: Int
	var cardTags: String
	var phase: String
	var VP: Int
}

func createCardList(){
	guard let filepath = Bundle.main.path(forResource: "Project Cards", ofType: "csv") else {
		return
	}
	var data = ""
	do {
		data = try String(contentsOfFile: filepath)
	} catch {
		print(error)
		return
	}
	var rows = (data.components(separatedBy: "\n"))
	rows.removeFirst()
	for row in rows{
		let columns = row.components(separatedBy: ",")
		let id = Int(columns[0]) ?? 0
		let color = {
			if(columns[1] == "green"){
				return Color.green

			}
			if(columns[1] == "red")
			{
				return Color.red

			}
			if(columns[1] == "blue"){
				return Color.blue

			}
			return Color.black
		}
		let cost = Int(columns[2]) ?? 0
		let cardName = columns[3]
		let cardTags = columns[4]
		let phase = columns[5]
		let VP = Int(columns[6]) ?? 0
		let card = ProjectCard(id: id, cardName: cardName, color: color(), cost: cost, cardTags: cardTags, phase: phase, VP: VP)
		ProjectCardList.append(card)
	}
}

var ProjectCardList = [ProjectCard]()

enum Tags: String, Identifiable, CaseIterable{
	case Building, Space, Power, Science, Jovian, Earth, Plant, Microbe
	var id: Self {self}
}

enum PhaseOptions: String, Identifiable, CaseIterable{
	case None, Development, Construction, Action, Production, Research
	var id: Self {self}
}
