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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            GameSaves.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)

    }
}
