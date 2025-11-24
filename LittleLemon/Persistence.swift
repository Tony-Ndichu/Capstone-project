//
//  Persistence.swift
//  LittleLemon
//
//  Created by TONY NDICHU on 11/23/25.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    let container = NSPersistentContainer(name: "ExampleDatabase")

    init() {
        container.loadPersistentStores { _, _ in }
    }

    func clear() {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Dish")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetch)

        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
        } catch {
            print("❌ Failed to clear Dish database:", error)
        }
    }
}
