//
//  PlayerData.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 8/12/24.
//

import Foundation
import SwiftUI
import SwiftData
import GameKit


/// The Phase options a user can play
enum PhaseOptions: String, Identifiable, CaseIterable, Codable{
	case None, Development, Construction, Action, Production, Research
	var id: Self {self}
}


/// The Tags that a card can have
enum Tags: String, Identifiable, CaseIterable, Codable{
	case Building, Space, Power, Science, Jovian, Earth, Plant, Microbe
	var id: Self {self}
}

/// The details about the player and the attributes they have
@Model class PlayerDetails: Identifiable{
	var id = UUID()
	var playerName: String
	
	var gamePlayerID: String
	var teamPlayerID: String
	@Transient var avatar = Image(systemName: "person.crop.circle")
	@Transient var player: GKPlayer?

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
	var nextRoundPhase: PhaseOptions = PhaseOptions.None
	
	var tagCollection: [Tags] = []
	
	init(id: UUID = UUID(), playerName: String, gamePlayerID: String,teamPlayerID: String, vp: Int = 0, tr: Int = 5, trees: Int = 0, megaCoins: Int = 0, megaCoinsProduction: Int =  0, heat: Int = 0, heatProduction: Int = 0, plants: Int = 0, plantsProduction: Int = 0, steel: Int = 0, steelDiscount: Int = 2, titanium: Int = 0, titaniumDiscount: Int = 0, cardProduction: Int = 0, readyForNextRound: Bool = false, readyForNextPhase: Bool = false, selectedPhase: String = "", nextRoundPhase: PhaseOptions = PhaseOptions.None, avatar: Image = Image(systemName: "person.crop.circle"), player: GKPlayer? = nil, tagCollection: [Tags] = []) {
		
		self.id = id
		self.playerName = playerName
		self.teamPlayerID = teamPlayerID
		self.gamePlayerID = gamePlayerID
		self.vp = vp
		self.tr = tr
		self.trees = trees
		self.megaCoins = megaCoins
		self.megaCoinsProduction = megaCoinsProduction
		self.heat = heat
		self.heatProduction = heatProduction
		self.plants = plants
		self.plantsProduction = plantsProduction
		self.steel = steel
		self.steelDiscount = steelDiscount
		self.titanium = titanium
		self.titaniumDiscount = titaniumDiscount
		self.cardProduction = cardProduction
		self.readyForNextRound = readyForNextRound
		self.readyForNextPhase = readyForNextPhase
		self.selectedPhase = selectedPhase
		self.nextRoundPhase = nextRoundPhase
		self.avatar = avatar
		self.player = player
		self.tagCollection = tagCollection
	}
	

}
