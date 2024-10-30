//
//  ContentView.swift
//  VacationInVegas
//
//  Created by Jinyuan Zhang on 28/10/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Places",systemImage: "photo") {
                PlaceList()
            }
            Tab("Trips",systemImage: "chart.line.uptrend.xyaxis") {
                TripsChart()
            }
            Tab("Icons",systemImage: "star.circle") {
                Symbols()
            }
        }
//        .preferredColorScheme(.dark)
        .preferredColorScheme(nil)
    }
}

#Preview {
    ContentView()
        .modelContainer(Place.preview)
}
