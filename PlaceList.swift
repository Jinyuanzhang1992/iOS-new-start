//
//  ContentView.swift
//  VacationInVegas
//
//  Created by Jinyuan Zhang on 28/10/2024.
//

import SwiftUI
import SwiftData
import MapKit

struct PlaceList: View {
    @Query(sort: \Place.name) private var places:[Place]
    
    @State private var showImages:Bool = false
    @State private var searchText:String = ""
    @State private var filterbyInterested:Bool = false
    @Namespace var namespace
    
    private var predicate:Predicate<Place>{
        #Predicate<Place>{
            if !searchText.isEmpty  && filterbyInterested {
                $0.name.localizedStandardContains(searchText) && $0.interested
            } else if !searchText.isEmpty {
                $0.name.localizedStandardContains(searchText)
            } else if filterbyInterested {
                $0.interested
            } else {
                true
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List((try? places.filter(predicate)) ?? places) { place in
                NavigationLink(value: place) {
                HStack {
                    place.image
                        .resizable()
                        .scaledToFit()
                        .clipShape(.rect(cornerRadius: 7))
                        .frame(width: 100, height: 100)
                    Text(place.name)
                    Spacer()
                    if place.interested {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .padding(.trailing)
                    }
                }
                }
                .matchedTransitionSource(id: 1, in: namespace)
                .swipeActions(edge: .leading) {
                    Button(place.interested ? "Interested" : "Not Interested" , systemImage: "star") {
                        place.interested.toggle()
                    }
                    .tint(place.interested ? .yellow : .gray )
                }
            }
            .navigationTitle("Places")
            .searchable(text: $searchText,prompt: "Find a Place")
            .animation(.default,value:searchText)
            .navigationDestination(for: Place.self ) { place in
                MapView(place:place, position:
                    .camera(MapCamera(
                    centerCoordinate: place.location,
                distance: 1000,
                heading:250,
                pitch: 80
            )))
                .navigationTransition(.zoom(sourceID: 1, in: namespace))
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Show Images", systemImage: "photo") {
                        showImages.toggle()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Filter", systemImage: filterbyInterested ? "star.fill" : "star") {
                        withAnimation {
                        filterbyInterested.toggle()
                        }
                    }
                    .tint(filterbyInterested ? .yellow : .blue)
                }
            }
            .sheet(isPresented: $showImages){
                Scrolling()
            }
        }
    }
}

#Preview {
    PlaceList()
        .modelContainer(Place.preview)
}
