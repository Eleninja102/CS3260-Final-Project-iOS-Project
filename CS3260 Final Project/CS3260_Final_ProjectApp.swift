//
//  CS3260_Final_ProjectApp.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 5/9/24.
//

import SwiftUI
import SwiftData

@main
struct CS3260_Final_ProjectApp: App {
   
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
		.modelContainer(for: GameData.self)
    }
}
