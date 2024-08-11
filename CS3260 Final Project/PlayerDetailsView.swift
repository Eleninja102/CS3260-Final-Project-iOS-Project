//
//  PlayerDetailsView.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 7/25/24.
//

import SwiftUI

func updateValue(array: [(name: String, playing: Int)]){
	
}

struct PlayerDetailsView: View {
	@Binding var playerDetails: Player
	enum Phases {
		case Development, Construction, Action, Production, Research
	}
	@ObservedObject var gameKitContoller: GameKitController
	@ObservedObject var game: GameData
	var phase: (name: String, playing: Int)? {gameKitContoller.activeGame!.phase}
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
		for oppenent in gameKitContoller.activeGame!.oppenents {
			ready = ready ? oppenent.readyForNextPhase : false
		}
		return ready
	}
	
	var everyoneReadyForNextRound: Bool{
		var ready = playerDetails.readyForNextRound
		for oppenent in gameKitContoller.activeGame!.oppenents {
			ready = ready ? oppenent.readyForNextRound : false
		}
		return ready
	}
	
	func resetForNextRound(){
		print("resetting")
		playerDetails.selectedPhase = playerDetails.nextRoundPhase.rawValue
		movingToNextRound = true
		playerDetails.readyForNextRound = false
//		playerDetails.selectedPhase = "\(playerDetails.nextRoundPhase.rawValue)"


		if let nextRoundIndex = gameKitContoller.activeGame!.phases.firstIndex(where: {$0.name == playerDetails.nextRoundPhase.rawValue}){
			gameKitContoller.activeGame!.phases[nextRoundIndex].playing = 1
		
		}
		for oppenent in gameKitContoller.activeGame!.oppenents.indices {
			gameKitContoller.activeGame!.oppenents[oppenent].readyForNextRound = false
			gameKitContoller.activeGame!.oppenents[oppenent].readyForNextPhase = false

		}
		
		gameKitContoller.sendString("addPhase:\(playerDetails.nextRoundPhase.rawValue)")

		playerDetails.nextRoundPhase = .None
		
	}
	
	func nextPhase(){
		finishedPhase = true
		playerDetails.readyForNextPhase = true
		
//		game.sendData(Data(), mode: .reliable)
		gameKitContoller.sendString("phaseReady:\(gameKitContoller.activeGame!.userPlayer?.player?.gamePlayerID ?? "")")
		if(finishedPhase && everyOneReadyForNextPhase){
			finishedPhase = false
		   playerDetails.readyForNextPhase = false
		   for oppenent in gameKitContoller.activeGame!.oppenents.indices {
			   gameKitContoller.activeGame!.oppenents[oppenent].readyForNextPhase = false
		   }
			if let ph = gameKitContoller.activeGame!.phases.firstIndex(where: {$0.1 == 1}){
				gameKitContoller.activeGame!.phases[ph].playing = 0
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
						 Text(playerDetails.selectedPhase)
						 Text(something)

						 Spacer()
						 HStack{
							 Text("TR: \(playerDetails.tr)")
							 
							 Stepper(value: $playerDetails.tr, in: 0...500){
								 
							 }
						 }
						 .frame(width: 160.0, height: 40.0)

					 }
					 .padding(.horizontal)
					 if(phase != nil){
						 WaitingOnPlayer(gameKitController: gameKitContoller, playerDetails: playerDetails)
					 }

				 }
				 Section{
					 VStack{
						 Text("Game Status")
						 Text("Oxgen: \(gameKitContoller.activeGame!.oxygen)")
							 .foregroundStyle(calculateColor(gameKitContoller.activeGame!.oxygen, ranges: gameKitContoller.oxygenRange))
						 Text("Tempeture: \(gameKitContoller.activeGame!.tempeture)")
							 .foregroundStyle(calculateColor(gameKitContoller.activeGame!.tempeture, ranges: gameKitContoller.tempetureRange))
						 Text("Oceans: \(gameKitContoller.activeGame!.oceans)")
							 .foregroundStyle(calculateColor(gameKitContoller.activeGame!.oceans, ranges: gameKitContoller.oceansRange))
						 

					 }
				 }
				 
				 VStack{
					 Text("Next Phases")
						 .font(.title2)
					 HStack{
						 ForEach(gameKitContoller.activeGame!.phases, id: \.name){ x in
							 if(x.playing == 1){
								 Text(x.name)
							 }
						 }
					 }
				 }
				 
				 LazyVGrid(columns: columns){
					
					HStack{
						Text("MC: \(playerDetails.megaCoins)")
						Stepper(value: $playerDetails.megaCoins, in: 0...500){
							
						}
						
					}
					 HStack{
						 Text("MC Prod: \(playerDetails.megaCoinsProduction)")
						 Stepper(value: $playerDetails.megaCoinsProduction, in: 0...500){
							 
						 }
						 
					 }
					HStack {
						Text("Plants: \(playerDetails.plants)")
						Stepper(value: $playerDetails.plants, in: 0...500){
							
						}
					}
					 HStack {
						 Text("Plants Prod: \(playerDetails.plantsProduction)")
						 Stepper(value: $playerDetails.plantsProduction, in: 0...500){
							 
						 }
					 }
					HStack {
						Text("Heat \(playerDetails.heat)")
						Stepper(value: $playerDetails.heat, in: 0...500){
							
						}
					}
					 HStack {
						 Text("Heat Prod: \(playerDetails.heatProduction)")
						 Stepper(value: $playerDetails.heatProduction, in: 0...500){
							 
						 }
					 }

					HStack(){
						Text("Steel: \(playerDetails.steel)")
						Stepper(value: $playerDetails.steel, in: 0...500){
							
						}
					}
					HStack{
						Text("Titanium: \(playerDetails.titanium)")
						Stepper(value: $playerDetails.titanium, in: 0...500){
							
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
							 ActionPhase(game: gameKitContoller, playerDetails: $playerDetails)
						 }
						 if(phase?.name == "Development"){
							 DevelopmentPhase(playerDetails: $playerDetails)
							 
							 
						 }
						 if(phase?.name == "Construction"){
							 ConstuctionPhase(playerDetails: $playerDetails)
						 }
						 if(phase?.name == "Production"){
							 ProductionPhase(playerDetails: $playerDetails)
						 }
						 if(phase?.name == "Research"){
							 ResearchPhase(playerDetails: $playerDetails)
						 }
					 }
					 
					 .onAppear(){
					 }
					
					
				 }
					 
				Spacer()
				 ChoosePhase(NextRoundPhase: $playerDetails.nextRoundPhase)
					 .disabled(playerDetails.readyForNextRound)
				if((phase) == nil){
		
					EndRound(playerDetails: $playerDetails, game: gameKitContoller, movingToNextRound: $movingToNextRound)
				}
				Spacer()
				 Button(action: {
					 for oppenent in gameKitContoller.activeGame!.oppenents.indices {
						 gameKitContoller.activeGame!.oppenents[oppenent].readyForNextPhase = true
					 }
				 }){
						 Text("Ready Up Everyone")
					 }
				 
				 Button{
					 gameKitContoller.playingGame = false
				 }label: {
					 Text("Exit Game")
				 }
				 
				 Button(action: {
					 for oppenent in gameKitContoller.activeGame!.oppenents.indices {
						 gameKitContoller.activeGame!.oppenents[oppenent].readyForNextRound = true
					 }
					}){
						 Text("Ready Up Round")
					 }
				
			}
			 .toolbar{
				 ToolbarItemGroup(placement: .bottomBar){
					 if(phase == nil){
						 if(!everyoneReadyForNextRound){
							 HStack{
								 Text("Waiting On Players to Choose Phase")
							 }
							 .onDisappear(perform: {
								
								
							 })
							 .onDisappear(perform: {
								 playerDetails.selectedPhase = playerDetails.nextRoundPhase.rawValue
								 something = playerDetails.nextRoundPhase.rawValue
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
									for oppenent in gameKitContoller.activeGame!.oppenents.indices {
										gameKitContoller.activeGame!.oppenents[oppenent].readyForNextPhase = false
									}
									 if let ph = gameKitContoller.activeGame!.phases.firstIndex(where: {$0.1 == 1}){
										 gameKitContoller.activeGame!.phases[ph].playing = 0
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




#Preview {
	struct Preview: View {
		@State var player: Player = Player(playerName: "Coleton")
		@StateObject var gameKitController = GameKitController()
		@StateObject var game: GameData = GameData( matchName: "Bob")
		var body: some View {
			PlayerDetailsView(playerDetails: $player, gameKitContoller: gameKitController, game: game)
			
		}
	}
	
	return Preview()
}

struct WaitingOnPlayer: View {
	@ObservedObject var gameKitController: GameKitController
	var playerDetails: Player
	
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
				
			ForEach(gameKitController.activeGame!.oppenents){ oppenent in
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
	@Binding var playerDetails: Player
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
		
		PlayCard(selectTags: $selectTags, playerDetails: $playerDetails, userSelected: userSelected)
			
	}
}
	
	


struct ConstuctionPhase: View{

	@Binding var playerDetails: Player
	@State var numberOfPeople = 0
	
	@State var selectTags: [Tags] = []


	var userSelected: Bool {
		playerDetails.selectedPhase == "Construction"
	}
	
	var body: some View{
		NavigationStack{
			
			
			Text("Construction Phase")
				.font(.title)
			Text("Desciption: Play a Blue or Red Card from your hand")
				.font(.footnote)
				.fontWeight(.light)
			
			PlayCard(selectTags: $selectTags, playerDetails: $playerDetails, userSelected: userSelected)
				
		}
	}
}

struct PlayCard: View{
	@Binding var selectTags: [Tags]
	@Binding var playerDetails: Player

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
			Text("Card Cost:")
			TextField("\(Image(systemName: "eurosign"))", value: $cost, format: .number)
				.frame(width: 40.0, height: 30.0)
				.border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
				.multilineTextAlignment(.center)
			
			
			Text("Discount: \(discount)")
			Text("Total Cost: \((cost ?? 0) - discount)")
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
	}
}


struct ActionPhase: View{
	@ObservedObject var game: GameKitController
	var gameDetails: GameData{
		game.activeGame!
	}
	
	@Binding var playerDetails: Player
	func plantTrees(type: String){
		if(type == "MC"){
			playerDetails.megaCoins -= 20
		}
		else if(type == "Plants"){
			playerDetails.plants -= 8
		}
		playerDetails.trees += 1
		gameDetails.oxygen += game.oxygenRange.increament
		game.sendString("oxygen:\(game.oxygenRange.increament)")
		playerDetails.tr += 1
	}
	
	func raiseTemp(type: String){
		if(type == "MC"){
			playerDetails.megaCoins -= 20
		}
		else if(type == "Heat"){
			playerDetails.heat -= 8
		}
		gameDetails.tempeture += game.tempetureRange.increament
		game.sendString("tempeture:\(game.tempetureRange.increament)")
		playerDetails.tr += 1
		
	}
	func playOcean(){
		playerDetails.megaCoins -= 15
		gameDetails.oceans += 1
		playerDetails.tr += 1
		game.sendString("ocean:\(game.tempetureRange.increament)")

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
				Text("Raise the Tempeture")
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
	@Binding var playerDetails: Player
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
	@Binding var playerDetails: Player
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
	@Binding var playerDetails: Player
	@ObservedObject var game: GameKitController
	@Binding var movingToNextRound: Bool
	var gameData: GameData{
		game.activeGame!
	}
	var body: some View{
		Toggle(isOn: $playerDetails.readyForNextRound){
			Text("Ready")
		}.disabled(playerDetails.nextRoundPhase == .None)
			.onChange(of: playerDetails.readyForNextRound, initial: true){
				if(playerDetails.readyForNextRound == true){
					game.sendString("roundReady:\(gameData.userPlayer?.player?.gamePlayerID ?? "")")
					return
				}
			}
			.disabled(playerDetails.readyForNextRound)
			.padding()
		ScrollView{
			ForEach(gameData.oppenents){ oppenent in
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
							.offset(x: 12, y:12)
						
					}
				}
			}
		}
	}
}
