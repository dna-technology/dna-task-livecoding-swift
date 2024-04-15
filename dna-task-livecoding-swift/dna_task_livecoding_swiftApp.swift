//
//  dna_task_livecoding_swiftApp.swift
//  dna-task-livecoding-swift
//
//  Created by Maciej Rudnicki on 15/04/2024.
//

import SwiftUI

@main
struct dna_task_livecoding_swiftApp: App {
//    let persistenceController = PersistenceController.shared
    
    var productsModel: ProductsModel = ProductsModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(productsModel)
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
