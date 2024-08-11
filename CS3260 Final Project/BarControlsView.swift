//
//  BarControlsView.swift
//  CS3260 Final Project
//
//  Created by Coleton Watt on 8/10/24.
//
import SwiftUI

struct BarControlsView: View {
	let range: ClosedRange<Int>
	let increment: Int
	let purpleRange: ClosedRange<Int>
	let redRange: ClosedRange<Int>
	let yellowRange: ClosedRange<Int>
	let whiteRange: ClosedRange<Int>
	
	@Binding var tempeture: Int
	
	var body: some View {
		VStack {
			HStack(spacing: 0) {
				ForEach(Array(stride(from: range.lowerBound, through: range.upperBound, by: increment)), id: \.self) { value in
					Rectangle()
						.fill(color(for: value))
						.frame(maxWidth: .infinity)
						.overlay(Text("\(value)").foregroundColor(.black))
						.onTapGesture {
							tempeture = value
						}
				}
			}
			.frame(height: 50)
			.border(Color.black, width: 1)
			
			Text("Selected Tempeture: \(tempeture)°")
				.font(.headline)
				.padding()
		}
	}
	
	private func color(for value: Int) -> Color {
		switch value {
		case purpleRange:
			return .purple
		case redRange:
			return .red
		case yellowRange:
			return .yellow
		case whiteRange:
			return .white
		default:
			return .gray
		}
	}
}

struct SomeBiew: View {
	@State private var tempeture = -30
	var tempetureRange = barControls(
		range: -30...8,
		increament: 2,
		purpleRange: -30...(-20),
		redRange: -18...(-10),
		yellowRange: -8...0,
		whiteRange: 2...8
	)
	
	var body: some View {
		BarControlsView(
			range: tempetureRange.range,
			increment: tempetureRange.increament,
			purpleRange: tempetureRange.purpleRange,
			redRange: tempetureRange.redRange,
			yellowRange: tempetureRange.yellowRange,
			whiteRange: tempetureRange.whiteRange,
			tempeture: $tempeture
		)
		.padding()
	}
}

#Preview{
	SomeBiew()
}
