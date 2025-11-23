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
        let request = NSBatchDeleteRequest(fetchRequest: Dish.fetchRequest())
        _ = try? container.viewContext.execute(request)
    }
}
