//
//  GameSaves.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 5/9/24.
//

import Foundation
import SwiftData
import SwiftUI

import GameKit



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



