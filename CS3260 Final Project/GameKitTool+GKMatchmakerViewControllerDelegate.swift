//
//  GameKitTool+GKMatchmakerViewControllerDelegate.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 8/11/24.
//

import Foundation
import GameKit
import SwiftUI

extension GameKitTool: GKMatchmakerViewControllerDelegate {
	/// Dismisses the matchmaker interface and starts the game when a player accepts an invitation.
	func matchmakerViewController(_ viewController: GKMatchmakerViewController,
								  didFind match: GKMatch) {
		// Dismiss the view controller.
		viewController.dismiss(animated: true) { }
		
		// Start the game with the player.
		if match.expectedPlayerCount == 0 {
			startMyMatchWith(match: match)
		}
	}
	
	/// Dismisses the matchmaker interface when either player cancels matchmaking.
	func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
		viewController.dismiss(animated: true)
	}
	
	/// Reports an error during the matchmaking process.
	func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
		print("\n\nMatchmaker view controller fails with error: \(error.localizedDescription)")
		viewController.dismiss(animated: true)

	}
}
