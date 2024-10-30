////
////  VacationInVegasApp.swift
////  VacationInVegas
////
////  Created by Jinyuan Zhang on 28/10/2024.
////
//
//import SwiftUI
//
//@main
//struct VacationInVegasApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//                .onAppear {
//                    print("ModelContainer for Place registered.")
//                }
//        }
//        .modelContainer(for:Place.self)
//    }
//}


import SwiftUI
import SwiftData

@main
struct VacationInVegasApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // 插入默认数据
                    addDefaultPlacesIfNeeded()
                }
                .modelContainer(for: Place.self)
        }
    }
    
    private func addDefaultPlacesIfNeeded() {
        // 获取主上下文
        let container = try! ModelContainer(for: Place.self)
        let context = container.mainContext
        
        // 创建一个 FetchDescriptor 来获取 Place 数据
        let fetchDescriptor = FetchDescriptor<Place>()
        
        // 检查是否已有数据
        if let existingPlaces = try? context.fetch(fetchDescriptor), existingPlaces.isEmpty {
            for place in Place.previewsPlace {
                context.insert(place)
            }
            
            // 保存更改到持久化存储
            try? context.save()
        }
    }
}
