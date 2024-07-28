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
    @StateObject var viewModel = CRUDViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(FormViewModel: FormViewModel(), crudViewModel: CRUDViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
