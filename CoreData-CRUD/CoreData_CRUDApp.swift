//
//  CoreData_CRUDApp.swift
//  CoreData-CRUD
//
//  Created by Bholanath Barik on 25/07/24.
//

import SwiftUI

@main
struct CoreData_CRUDApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
