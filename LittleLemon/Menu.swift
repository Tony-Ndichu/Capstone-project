//
//  Menu.swift
//  LittleLemon
//
//  Created by TONY NDICHU on 11/23/25.
//


import SwiftUI

struct Menu: View {
    @State private var searchText = ""

    @Environment(\.managedObjectContext) private var viewContext

    func buildPredicate() -> NSPredicate {
        if searchText.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        }
    }
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        return [
            NSSortDescriptor(
                key: "title",
                ascending: true,
                selector: #selector(NSString.localizedStandardCompare)
            )
        ]
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Little Lemon")
                .font(.largeTitle)
                .bold()

            Text("Chicago")
                .font(.title2)

            Text("We offer delicious Mediterranean cuisine with a modern twist.")
                .fixedSize(horizontal: false, vertical: true)

            TextField("Search menu", text: $searchText)
                .textFieldStyle(.roundedBorder)
            
            // Dish List will appear below
            menuListSection
        }
        .padding()
        .onAppear {
            getMenuData()
        }
    }
}

extension Menu {

    func getMenuData() {

        // Clear existing database
        PersistenceController.shared.clear()

        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(MenuList.self, from: data) {

                    // Convert MenuItems → Dish (Core Data)
                    for item in decoded.menu {
                        let dish = Dish(context: viewContext)
                        dish.title = item.title
                        dish.price = item.price
                        dish.image = item.image
                        dish.dishDescription = item.description
                    }

                    // Save to Core Data
                    try? viewContext.save()
                }
            }
        }

        task.resume()
    }
    
    var menuListSection: some View {
        FetchedObjects(
            predicate: buildPredicate(),
            sortDescriptors: buildSortDescriptors()
        ) { (dishes: [Dish]) in
            List {
                ForEach(dishes) { dish in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(dish.title ?? "") - $\(dish.price ?? "")")
                                .font(.headline)

                            if let desc = dish.dishDescription {
                                Text(desc)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                            }
                        }

                        Spacer()

                        AsyncImage(url: URL(string: dish.image ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                    }
                }
            }
        }
    }


}



#Preview {
    Menu()
}
