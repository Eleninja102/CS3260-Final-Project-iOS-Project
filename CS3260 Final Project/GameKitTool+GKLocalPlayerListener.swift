//
//  GameKitTool+GKLocalPlayerListener.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 8/11/24.
//

import Foundation
import GameKit
import SwiftUI

extension GameKitTool: GKLocalPlayerListener {
	/// Handles when the local player sends requests to start a match with other players.
	func player(_ player: GKPlayer, didRequestMatchWithRecipients recipientPlayers: [GKPlayer]) {
		print("\n\nSending invites to other players.")
	}
	
	/// Presents the matchmaker interface when the local player accepts an invitation from another player.
	func player(_ player: GKPlayer, didAccept invite: GKInvite) {
		// Present the matchmaker view controller in the invitation state.
		if let viewController = GKMatchmakerViewController(invite: invite) {
			viewController.matchmakerDelegate = self
			rootViewController?.present(viewController, animated: true) { }
		}
	}
}
