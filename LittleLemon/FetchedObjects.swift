import CoreData
import SwiftUI

struct FetchedObjects<T, Content>: View where T : NSManagedObject, Content : View {

    var fetchRequest: FetchRequest<T>
    var content: ([T]) -> Content

    init(
        predicate: NSPredicate?,
        sortDescriptors: [NSSortDescriptor],
        @ViewBuilder content: @escaping ([T]) -> Content
    ) {
        fetchRequest = FetchRequest<T>(
            entity: T.entity(),
            sortDescriptors: sortDescriptors,
            predicate: predicate,
            animation: .default
        )
        self.content = content
    }

    var body: some View {
        content(Array(fetchRequest.wrappedValue))
    }
}

