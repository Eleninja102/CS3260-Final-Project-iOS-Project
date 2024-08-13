//
//  PlayerDetailsView.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 7/25/24.
//

import SwiftUI
import SwiftData



struct PlayerDetailsView: View {
	@Bindable var gameData: GameData
	@EnvironmentObject var gameKitTool: GameKitTool
	var playerDetails: PlayerDetails{
		gameData.userPlayer
	}
	var phase: phaseDetails? {gameData.phase}
	@State var enviromentVarChange: (ocean: Int, temperature: Int, oxygen: Int) = (0,0,0)
	@State var movingToNextRound: Bool = false
	@State var finishedPhase: Bool = false
	@State var something: String = ""
	
	let columns = [GridItem(.flexible()), GridItem(.flexible())]

	
	var everyOneReadyForNextPhase: Bool{
		if(phase == nil){
			return false
		}
		var ready = playerDetails.readyForNextPhase
		for oppenent in gameData.opponents {
			ready = ready ? oppenent.readyForNextPhase : false
		}
		return ready
	}
	
	var everyoneReadyForNextRound: Bool{
		var ready = playerDetails.readyForNextRound
		for oppenent in gameData.opponents {
			ready = ready ? oppenent.readyForNextRound : false
		}
		return ready
	}
	
	func resetForNextRound(){
		playerDetails.selectedPhase = playerDetails.nextRoundPhase.rawValue
		something = playerDetails.nextRoundPhase.rawValue

		print("resetting \(playerDetails.selectedPhase)")

		movingToNextRound = true
		playerDetails.readyForNextRound = false
//		playerDetails.selectedPhase = "\(playerDetails.nextRoundPhase.rawValue)"


		if let nextRoundIndex = gameData.phases.firstIndex(where: {$0.name == playerDetails.nextRoundPhase.rawValue}){
			gameData.phases[nextRoundIndex].playing = 1
		
		}
		for oppenent in gameData.opponents.indices {
			gameData.opponents[oppenent].readyForNextRound = false
			gameData.opponents[oppenent].readyForNextPhase = false

		}
		
		gameKitTool.sendPhase(playerDetails.nextRoundPhase)

		playerDetails.nextRoundPhase = .None
		
	}
	
	func nextPhase(){
		finishedPhase = true
		playerDetails.readyForNextPhase = true
		
		gameKitTool.readyPhase(playerDetails.readyForNextPhase)
		if(finishedPhase && everyOneReadyForNextPhase){
			finishedPhase = false
		   playerDetails.readyForNextPhase = false
		   for oppenent in gameData.opponents.indices {
			   gameData.opponents[oppenent].readyForNextPhase = false
		   }
			if let ph = gameData.phases.firstIndex(where: {$0.playing == 1}){
				gameData.phases[ph].playing = 0
			}
		}
			   			

	}
	
	func calculateColor(_ number: Int, ranges: barControls) -> Color{
		if ranges.purpleRange.contains(number){
			return Color(.purple)
		}
		if ranges.redRange.contains(number){
			return Color(.red)
		}
		if ranges.yellowRange.contains(number){
			return Color(.yellow)
		}
		if ranges.whiteRange.contains(number){
			return Color(.black)
		}
		
		return Color(.blue)
		
	}
	
	
	
		
    var body: some View {
		 NavigationStack{
			 ScrollView{
				
				
				 Section{
					 HStack(){
						 Text(playerDetails.playerName)
							 .font(.title)
						 Text(something)
						 Spacer()
						 HStack{
							 Text("TR: \(playerDetails.tr)")
							 
							 Stepper(value: $gameData.userPlayer.tr, in: 0...500){
								 
							 }
						 }
						 .frame(width: 160.0, height: 40.0)

					 }
					 .padding(.horizontal)
					 if(phase != nil){
						 WaitingOnPlayer(oppenents: gameData.opponents, playerDetails: playerDetails)
					 }

				 }
				 Section{
					 VStack{
						 Text("Game Status")
						 Text("Oxgen: \(gameData.oxygen)")
							 .foregroundStyle(calculateColor(gameData.oxygen, ranges: gameData.oxygenRange))
						 Text("Temperature: \(gameData.temperature)")
							 .foregroundStyle(calculateColor(gameData.temperature, ranges: gameData.temperatureRange))
						 Text("Oceans: \(gameData.oceans)")
							 .foregroundStyle(calculateColor(gameData.oceans, ranges: gameData.oceansRange))
						 

					 }
				 }
				 if gameData.phases.contains(where: { $0.playing == 1 && $0 != phase }) {
					 VStack{
						 Text("Next Phases")
							 .font(.title2)
						 HStack{
							 ForEach(gameData.phases, id: \.name){ x in
								 if(x.playing == 1 && x != phase){
									 Text(x.name)
								 }
							 }
						 }
					 }
				 }
				 
				 LazyVGrid(columns: columns){
					
					HStack{
						Text("MC: \(playerDetails.megaCoins)")
						Stepper(value: $gameData.userPlayer.megaCoins, in: 0...500){
							
						}
						
					}
					 HStack{
						 Text("MC Prod: \(playerDetails.megaCoinsProduction)")
						 Stepper(value: $gameData.userPlayer.megaCoinsProduction, in: 0...500){
							 
						 }
						 
					 }
					HStack {
						Text("Plants: \(playerDetails.plants)")
						Stepper(value: $gameData.userPlayer.plants, in: 0...500){
							
						}
					}
					 HStack {
						 Text("Plants Prod: \(playerDetails.plantsProduction)")
						 Stepper(value: $gameData.userPlayer.plantsProduction, in: 0...500){
							 
						 }
					 }
					HStack {
						Text("Heat \(playerDetails.heat)")
						Stepper(value: $gameData.userPlayer.heat, in: 0...500){
							
						}
					}
					 HStack {
						 Text("Heat Prod: \(playerDetails.heatProduction)")
						 Stepper(value: $gameData.userPlayer.heatProduction, in: 0...500){
							 
						 }
					 }

					HStack(){
						Text("Steel: \(playerDetails.steel)")
						Stepper(value: $gameData.userPlayer.steel, in: 0...500){
							
						}
					}
					HStack{
						Text("Titanium: \(playerDetails.titanium)")
						Stepper(value: $gameData.userPlayer.titanium, in: 0...500){
							
						}
					}
					
					 
				 }
				 .padding(.horizontal, 6.0)
				 
//				 VStack{
//					 ForEach(game.phases, id: \.name){ ph in
//						 HStack{
//							 Text(ph.name)
//							 Text("\(ph.playing)")
//						 }
//					 }
//				 }
				 if(!everyOneReadyForNextPhase && finishedPhase){
				 }else{
					 Section{
						 if(phase?.name == "Action"){
							ActionPhase(gameData: gameData)
						 }
						 if(phase?.name == "Development"){
							 DevelopmentPhase(playerDetails: playerDetails)
							 
							 
						 }
						 if(phase?.name == "Construction"){
							 ConstuctionPhase(playerDetails: playerDetails, gameData: gameData)
						 }
						 if(phase?.name == "Production"){
							 ProductionPhase(playerDetails: playerDetails)
						 }
						 if(phase?.name == "Research"){
							 ResearchPhase(playerDetails: playerDetails)
						 }
					 }
					 
					 .onAppear(){
					 }
					
					
				 }
					 
				Spacer()
				 ChoosePhase(NextRoundPhase: $gameData.userPlayer.nextRoundPhase)
					 .disabled(playerDetails.readyForNextRound)
				if((phase) == nil){
		
					EndRound(playerDetails: playerDetails, gameData: gameData, movingToNextRound: $movingToNextRound)
				}
				Spacer()
//				 Button(action: {
//					 for oppenent in gameData.opponents.indices {
//						 gameData.opponents[oppenent].readyForNextPhase = true
//					 }
//				 }){
//						 Text("Ready Up Everyone")
//					 }
				 
				 Button{
					 gameKitTool.playingGame = false
				 }label: {
					 Text("Exit Game")
				 }
				 
//				 Button(action: {
//					 for oppenent in gameData.opponents.indices {
//						 gameData.opponents[oppenent].readyForNextRound = true
//					 }
//					}){
//						 Text("Ready Up Round")
//					 }
				
			}
			 .toolbar{
				 ToolbarItemGroup(placement: .bottomBar){
					 if(phase == nil){
						 if(!everyoneReadyForNextRound){
							 HStack{
								 Text("Waiting On Players to Choose Phase")
							 }
							 .onDisappear(perform: {
								 resetForNextRound()
								 
							 })
						 }
					 }
					 else if(!everyOneReadyForNextPhase && finishedPhase){
							 HStack{
								 Text("Waiting On Players...")
								 Text("Next Phase \(phase?.name ?? "")")
							 }
							 .onDisappear(perform: {
								 if(finishedPhase && everyOneReadyForNextPhase){
									 finishedPhase = false
									playerDetails.readyForNextPhase = false
									for oppenent in gameData.opponents.indices {
										gameData.opponents[oppenent].readyForNextPhase = false
									}
									 if let ph = gameData.phases.firstIndex(where: {$0.playing == 1}){
										 gameData.phases[ph].playing = 0
									 }
								 }
									
								 }
							 )

					 }else{
						 VStack{
							 HStack{
								 Text("\(phase?.name ?? "Next Round")")
								 Button(action: {
								
									 nextPhase()
									 
								 }, label: {
									 Image(systemName: "checkmark")
								 })
								 .disabled(phase == nil ? !everyoneReadyForNextRound : false)
								 .bold()
								 .shadow(color: Color(.green),radius: 10)
							 }
							 .font(.system(size: 30))
						 }
					 }
				 }
			 }
			 .padding()
			 
		}
		 
    }
}





struct WaitingOnPlayer: View {
	var oppenents: [PlayerDetails]
	var playerDetails: PlayerDetails
	
	var body: some View {		
		LazyHStack(){
				VStack{
					ZStack{
						playerDetails.avatar
							.resizable()
							.frame(width: 35.0, height: 35.0)
							.clipShape(Circle())
						if(playerDetails.readyForNextPhase){
							Circle()
								.frame(width: 25.0, height: 25.0)
								.foregroundStyle(Color(.green))
								.mask(
									Image(systemName: "checkmark")
										.opacity(1)
								)
								.aspectRatio(contentMode: .fit)
								
								.background(.white, in: Circle())
								.offset(x: 12, y:12)
							
						}
					}
					Text(playerDetails.playerName)
				}
				
			ForEach(oppenents){ oppenent in
					VStack{
						ZStack{
							oppenent.avatar
								.resizable()
								.frame(width: 35.0, height: 35.0)
								.clipShape(Circle())
							if(oppenent.readyForNextPhase || oppenent.readyForNextRound){
								Circle()
									.frame(width: 25.0, height: 25.0)
									.foregroundStyle(Color(.green))
									.mask(
										Image(systemName: "checkmark")
											.opacity(1)
									)
									.aspectRatio(contentMode: .fit)
									
									.background(.white, in: Circle())
									.offset(x: 12, y:12)

							}
						}
						Text(oppenent.playerName)
					}
					
				}
			
		}
		
	}
}



struct DevelopmentPhase: View{
	@State var selectTags: [Tags] = []
	@State var cost: Int?
	@Bindable var playerDetails: PlayerDetails
	@State var numberOfPeople = 0
	
	@State var heatProd = 0
	@State var plantProd = 0
	@State var mcProd = 0
	@State var cardProd = 0
	@State var vp = 0



	var userSelected: Bool {
		playerDetails.selectedPhase == "Development"
	}
	var discount: Int{
		var discount = 0
		if(selectTags.contains(.Space)){
			discount -= playerDetails.steel * playerDetails.steelDiscount
		}
		if(selectTags.contains(.Building)){
			discount -= playerDetails.steel * playerDetails.steelDiscount
		}
		if(userSelected){
			discount-=3
		}
		return discount
	}
	var body: some View{
		Text("Development Phase")
			.font(.title)
		Text("Desciption: Play a Green Card from your hand")
			.font(.footnote)
			.fontWeight(.light)
		
		PlayGreenCard(selectTags: $selectTags, playerDetails: playerDetails, userSelected: userSelected)
			
	}
}
	
	


struct ConstuctionPhase: View{

	@Bindable var playerDetails: PlayerDetails
	@State var numberOfPeople = 0
	@Bindable var gameData: GameData
	@EnvironmentObject var gameKitTool: GameKitTool
	
	@State var selectTags: [Tags] = []


	@State var oceans = 0
	@State var oxygen = 0
	@State var oxygen2 = 0
	@State private var oxygenStack: [Int] = []

	@State var temperature = 0
	@State var trees = 0
	@State var vp = 0
	@State var cost: Int?
	
	var userSelected: Bool {
		playerDetails.selectedPhase == "Construction"
	}
	var discount: Int{
		var discount = 0
		if(selectTags.contains(.Space)){
			discount -= playerDetails.steel * playerDetails.steelDiscount
		}
		if(selectTags.contains(.Building)){
			discount -= playerDetails.steel * playerDetails.steelDiscount
		}
		if(playerDetails.selectedPhase == "Construction"){
			discount-=3
		}
		return discount
	}
	
	func playCard(){
		playerDetails.megaCoins -= (cost ?? 0) + discount
		playerDetails.trees += trees
		
		if(oxygen != 0){
			gameData.oxygen += gameData.oxygenRange.increament * oxygen
			gameKitTool.updateBoard("oxygen", by: gameData.oxygenRange.increament * oxygen)
			playerDetails.tr += 1 * oxygen
		}
		
		if(temperature != 0){
			let change = gameData.temperatureRange.increament * temperature
			gameData.temperature += change
			gameKitTool.updateBoard("temperature", by: change)
			playerDetails.tr += 1 * temperature
		}
		if(oceans != 0){
			let change = gameData.oceansRange.increament * oceans
			gameData.oceans += change
			playerDetails.tr += 1
			gameKitTool.updateBoard("ocean", by: change)
			playerDetails.tr += 1 * change

		}
		trees = 0
		oxygen = 0
		temperature = 0
		oceans = 0
		cost = nil
		vp = 0
	}
	var body: some View{
		NavigationStack{
			
			
			Text("Construction Phase")
				.font(.title)
			Text("Desciption: Play a Blue or Red Card from your hand")
				.font(.footnote)
				.fontWeight(.light)
			
			
			HStack(spacing: 0.0){
				Text("Tag: ")
				NavigationLink(destination:{
					MultiSelectPickerView( selectedItems: $selectTags)
						.navigationTitle("Card Tags")
				} , label: {Text("Choose Tags")})
				Spacer()

				HStack{
					Stepper(value: $vp, in: 0...100){
						Text("VP \(vp)")
					}
					.padding(.horizontal, 30)
				}
			}
			.padding(.leading, 12.0)
			
			
			HStack{
	//			ForEach(selectTags){tag in
	//				Text(tag.rawValue)
	//			}
				Text("Card Cost:")
				TextField("\(Image(systemName: "eurosign"))", value: $cost, format: .number)
					.frame(width: 40.0, height: 30.0)
					.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
					.multilineTextAlignment(.center)
				
				
				Text("Discount: \(discount)")
				Text("Total Cost: \((cost ?? 0) + discount)")
			}
			.padding(.horizontal, 0.0)
			Section{
				HStack{
					Stepper("Trees \(trees)", onIncrement: {
						trees += 1
						if(gameData.oxygenRange.max >= gameData.oxygenRange.increament * oxygen){
							oxygen += 1
							oxygenStack.append(1)
							return
						}
						oxygenStack.append(0)
						
					}, onDecrement: {
						if(trees > 0){
							trees -= 1
							if let x = oxygenStack.popLast() {
								oxygen -= x
							}
					}
					})
					
					.padding(.horizontal, 30)
				}
				HStack{
					Stepper("Oxygen \(oxygen)", onIncrement: {
						if(gameData.oxygenRange.max >= gameData.oxygenRange.increament * oxygen){
							oxygen += 1
						}
						
					}, onDecrement: {
						if(oxygen > 0){
							oxygen -= 1

						}

					})
					.padding(.horizontal, 30)
				}
				HStack{
					Stepper("Temperature \(temperature)", onIncrement: {
						if(gameData.temperatureRange.max >= gameData.temperatureRange.increament * temperature){
							temperature += 1
						}
						
					}, onDecrement: {
						if(temperature > 0){
							temperature -= 1

						}

					})
					.padding(.horizontal, 30)
				}
				HStack{
					Stepper("Oceans \(oceans)", onIncrement: {
						if(gameData.oceansRange.max >= gameData.oceansRange.increament * oceans){
							oceans += 1
						}
						
					}, onDecrement: {
						if(oceans > 0){
							oceans -= 1

						}

					})
					.padding(.horizontal, 30)
				}
			}
			Button(action: playCard, label: {
				Text("Play Card")}
			)
			.disabled(((cost ?? 0) - discount) > playerDetails.megaCoins)
		}
	}
}


struct PlayGreenCard: View{
	@Binding var selectTags: [Tags]
	@Bindable var playerDetails: PlayerDetails

	@State var heatProd = 0
	@State var plantProd = 0
	@State var mcProd = 0
	@State var cardProd = 0
	@State var vp = 0
	@State var cost: Int?
	var userSelected: Bool

	var discount: Int{
		var discount = 0
		if(selectTags.contains(.Space)){
			discount -= playerDetails.steel * playerDetails.steelDiscount
		}
		if(selectTags.contains(.Building)){
			discount -= playerDetails.steel * playerDetails.steelDiscount
		}
		if(userSelected){
			discount-=3
		}
		return discount
	}
	
	func playCard(){
		playerDetails.plantsProduction += plantProd
		playerDetails.cardProduction += cardProd
		playerDetails.vp += vp
		playerDetails.megaCoinsProduction += mcProd
		playerDetails.heatProduction += heatProd
		playerDetails.megaCoins -= (cost ?? 0) + discount
		
		heatProd = 0
		plantProd = 0
		mcProd = 0
		cardProd = 0
		vp = 0
		cost = nil
	}
	
	var body: some View{
		HStack(spacing: 0.0){
			Text("Tag: ")
			NavigationLink(destination:{
				MultiSelectPickerView( selectedItems: $selectTags)
					.navigationTitle("Card Tags")
			} , label: {Text("Choose Tags")})
			Spacer()

			HStack{
				Stepper(value: $vp, in: 0...100){
					Text("VP \(vp)")
				}
				.padding(.horizontal, 30)
			}
		}
		.padding(.leading, 12.0)
		
		
		HStack{
//			ForEach(selectTags){tag in
//				Text(tag.rawValue)
//			}
			Text("Card Cost:")
			TextField("\(Image(systemName: "eurosign"))", value: $cost, format: .number)
				.frame(width: 40.0, height: 30.0)
				.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
				.multilineTextAlignment(.center)
			
			
			Text("Discount: \(discount)")
			Text("Total Cost: \((cost ?? 0) + discount)")
		}
		.padding(.horizontal, 0.0)
		Section{
			HStack{
				Stepper(value: $mcProd, in: 0...100){
					Text("MC Production \(mcProd)")
				}
				.padding(.horizontal, 30)
			}
			HStack{
				Stepper(value: $cardProd, in: 0...100){
					Text("Card Production \(cardProd)")
				}
				.padding(.horizontal, 30)
			}
			HStack{
				Stepper(value: $heatProd, in: 0...100){
					Text("Heat Production \(heatProd)")
				}
				.padding(.horizontal, 30)
			}
			HStack{
				Stepper(value: $plantProd,in: 0...100 ){
					Text("Plant Production \(plantProd)")
				}
				.padding(.horizontal, 30)
			}
		}
		Button(action: playCard, label: {
			Text("Play Card")}
		)
		.disabled(((cost ?? 0) - discount) > playerDetails.megaCoins)
	}
}


struct ActionPhase: View{
	@Bindable var gameData: GameData
	@EnvironmentObject var gameKitTool: GameKitTool
	var playerDetails: PlayerDetails{
		gameData.userPlayer
	}
	
	func plantTrees(type: String){
		if(type == "MC"){
			playerDetails.megaCoins -= 20
		}
		else if(type == "Plants"){
			playerDetails.plants -= 8
		}
		playerDetails.trees += 1
		gameData.oxygen += gameData.oxygenRange.increament
		gameKitTool.updateBoard("oxygen", by: gameData.oxygenRange.increament)
		playerDetails.tr += 1
	}
	
	func raiseTemp(type: String){
		if(type == "MC"){
			playerDetails.megaCoins -= 20
		}
		else if(type == "Heat"){
			playerDetails.heat -= 8
		}
		gameData.temperature += gameData.temperatureRange.increament
		gameKitTool.updateBoard("temperature", by: gameData.temperatureRange.increament)
		playerDetails.tr += 1
		
	}
	func playOcean(){
		playerDetails.megaCoins -= 15
		gameData.oceans += gameData.oceansRange.increament
		playerDetails.tr += 1
		gameKitTool.updateBoard("oceans", by: gameData.oceansRange.increament)
	}
	
	var body: some View{
		Text("Standard Actions")
			.font(.title)
		VStack{
			HStack{
				Text("Plant a Tree")
				Button(action: {
					plantTrees(type: "MC")
				}){
					Text("-20 MC")
				}
				.disabled(playerDetails.megaCoins < 20)
				
				Button(action: {
					plantTrees(type: "Plants")
				}){
					Text("-8 plants")
				}
				.disabled(playerDetails.plants < 8)
			}
			HStack{
				Text("Raise the Temperature")
				Button(action: {
					raiseTemp(type: "MC")
				}){
					Text("-20 MC")
				}
				.disabled(playerDetails.megaCoins < 20)
				
				Button(action: {
					raiseTemp(type: "Heat")
				}){
					Text("-8 heat")
				}
				.disabled(playerDetails.heat < 8)

				
			}
			HStack{
				Text("Flip an Ocean Tile")
				Button(action: playOcean){
					Text("-15 MC")
				}
				.disabled(playerDetails.megaCoins < 15)
			}
		}
	}
}



struct ChoosePhase: View{
	
	@Binding var NextRoundPhase: PhaseOptions
	
	var body: some View{
		Section{
			HStack{
				Text("Choose Phase")
					.font(.title3)
					.multilineTextAlignment(.leading)
			
				Picker("Phase for Next Round", selection: $NextRoundPhase){
					ForEach(PhaseOptions.allCases){ phase in
						Text(phase.rawValue)
							.font(.title3)
					}
				}
			}
			.padding(.horizontal, 20.0)
		}
		
	}
}


struct MultiSelectPickerView: View {
	// The list of items we want to show

	// Binding to the selected items we want to track
	@Binding var selectedItems: [Tags]

	var body: some View {
		Form {
			List {
				ForEach(Tags.allCases, id: \.self) { item in
					Button(action: {
						withAnimation {
							if self.selectedItems.contains(item) {
								// Previous comment: you may need to adapt this piece
								self.selectedItems.removeAll(where: { $0 == item })
							} else {
								self.selectedItems.append(item)
							}
						}
					}) {
						HStack {
							Image(systemName: "checkmark")
								.opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
							Text(item.rawValue)
						}
					}
					.foregroundColor(.primary)
				}
			}
		}
	}
}

struct ProductionPhase: View{
	@Bindable var playerDetails: PlayerDetails
	func runProduction(){
		playerDetails.megaCoins += playerDetails.megaCoinsProduction
		playerDetails.megaCoins += playerDetails.tr
		playerDetails.heat += playerDetails.heatProduction
		playerDetails.plants += playerDetails.plantsProduction
		
	}

	var body: some View{
		Text("Production Phase")
			.font(.title)
		Text("Desciption: Collect the Valid Resoures")
			.font(.footnote)
			.fontWeight(.light)
		Button(action: runProduction, label: {
			HStack{
			Text("Run Production")
		}
		})
		
		if((playerDetails.cardProduction) != 0){
			Text("Draw \(playerDetails.cardProduction) card(s)")
		}
			
	}
}

struct ResearchPhase: View {
	@Bindable var playerDetails: PlayerDetails
	var body: some View {
		Text("Research Phase")
			.font(.title)
		Text("Desciption: Draw the correct amount of cards")
			.font(.footnote)
			.fontWeight(.light)
		
		Text("Draw \(playerDetails.selectedPhase == "Research" ? "5 Cards and Keep 2" : "2 Cards and Keep 1")")
	}
}



struct EndRound: View{
	@Bindable var playerDetails: PlayerDetails
	@Bindable var gameData: GameData
	@EnvironmentObject var gameKitTool: GameKitTool
	@Binding var movingToNextRound: Bool
	
	var body: some View{
		HStack{
			Text(playerDetails.playerName)
			Toggle(isOn: $playerDetails.readyForNextRound){
				Text("Ready")
			}.disabled(playerDetails.nextRoundPhase == .None)
				.onChange(of: playerDetails.readyForNextRound, initial: true){
					if(playerDetails.readyForNextRound == true){
						gameKitTool.readyRound(playerDetails.readyForNextRound)
						return
					}
				}
				.disabled(playerDetails.readyForNextRound)
			
		}
		.padding()
		
		ScrollView{
			ForEach(gameData.opponents){ oppenent in
				HStack{
					
					oppenent.avatar
						.resizable()
						.frame(width: 35.0, height: 35.0)
						.clipShape(Circle())
					Text(oppenent.playerName)
					if(oppenent.readyForNextRound){
						Circle()
							.frame(width: 25.0, height: 25.0)
							.foregroundStyle(Color(.green))
							.mask(
								Image(systemName: "checkmark")
									.opacity(1)
							)
							.aspectRatio(contentMode: .fit)
							
							.background(.white, in: Circle())
					}
				}
			}
		}
	}
}


#Preview {
	do{
		let config = ModelConfiguration(isStoredInMemoryOnly: true)
		let container = try ModelContainer(for: GameData.self, configurations: config)
		let example = GameData(
			matchName: "Bob",
			userPlayer: PlayerDetails(playerName: "Coleton", gamePlayerID: "Coleton", teamPlayerID: "Coleton2"),
			oppenents: [PlayerDetails(playerName: "Bob", gamePlayerID: "bob", teamPlayerID: "bob2")],
			phases: [
				phaseDetails(name: "Development", playing: 	0),
				phaseDetails(name:"Construction", playing: 0),
				phaseDetails(name: "Action", playing: 0),
				phaseDetails(name: "Production", playing: 0),
				phaseDetails(name: "Research", playing: 0)
			]
		)
		let game = GameKitTool()
		game.activeGame = example
	
		return PlayerDetailsView(gameData: example)
			.environmentObject(game)
			.modelContainer(container)

	}
	catch{
		return Text("Faile To Load Preview")
	}
	
}
