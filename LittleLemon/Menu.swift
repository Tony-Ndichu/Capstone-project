//
//  Menu.swift
//  LittleLemon
//
//  Created by TONY NDICHU on 11/23/25.
//


import SwiftUI

struct Menu: View {
    @State private var searchText = ""
    let categories = ["Starters", "Mains", "Desserts"]
    @State private var selectedCategory: String = ""
    @State private var selectedOrderCategory = ""

    @Environment(\.managedObjectContext) private var viewContext

    let dishImageMap: [String: String] = [
        "Bruschetta"    : "bruschetta",
        "Greek Salad"   : "greekSalad",
        "Grilled Fish"  : "grilledFish",
        "Lemon Desert"  : "lemonDessert",
        "Pasta"         : "pasta"
    ]
    
    func buildPredicate() -> NSPredicate {
        var predicates: [NSPredicate] = []

        // Search filter
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }

        // Category filter
        if !selectedCategory.isEmpty {
            predicates.append(NSPredicate(format: "category == %@", selectedCategory))
        }

        // Return combined predicate
        if predicates.isEmpty {
            return NSPredicate(value: true)
        } else {
            return NSCompoundPredicate(type: .and, subpredicates: predicates)
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

    var headerSection: some View {
        HStack {
            Spacer()
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 28)
            Spacer()
            Image(systemName: "person.circle")
                .font(.system(size: 32))
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
    
    var heroSection: some View {
        ZStack {
            Color(hex: "#495E57")
                .ignoresSafeArea()

            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Little Lemon")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color(hex: "#F4CE14")) // yellow
                    
                    Text("Chicago")
                        .font(.title2)
                        .foregroundColor(.white)

                    Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                        .foregroundColor(.white)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)

                    // Search Bar
                    TextField("Search menu", text: $searchText)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                
                Spacer()

                Image("restaurant")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .frame(height: 260)
    }

    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerSection
            heroSection
            orderSection
            menuListSection
        }
        .padding()
        .onAppear { getMenuData() }
    }
}

extension Menu {
    var orderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ORDER FOR DELIVERY!")
                .font(.title3)
                .fontWeight(.bold)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        Button {
                            // Toggle / select category
                            if selectedCategory == category {
                                selectedCategory = "" // deselect
                            } else {
                                selectedCategory = category
                            }
                        } label: {
                            Text(category)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    selectedCategory == category
                                    ? Color(hex: "#495E57")
                                    : Color(.systemGray6)
                                )
                                .foregroundColor(
                                    selectedCategory == category
                                    ? .white
                                    : .black
                                )
                                .cornerRadius(20)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 4)
    }

    
    func localImageName(for apiName: String) -> String {
        return apiName
            .replacingOccurrences(of: ".jpg", with: "")
            .replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: "?raw=true", with: "")
            .replacingOccurrences(of: "%20", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
    
    func categoryForDish(title: String) -> String {
        let lower = title.lowercased()

        if lower.contains("salad") { return "Starters" }
        if lower.contains("soup") { return "Starters" }
        if lower.contains("bruschetta") { return "Starters" }

        if lower.contains("fish") { return "Mains" }
        if lower.contains("pasta") { return "Mains" }
        if lower.contains("steak") { return "Mains" }

        if lower.contains("lemon") { return "Desserts" }
        if lower.contains("pie") { return "Desserts" }

        return "Mains"
    }

    func getMenuData() {

        DispatchQueue.main.async {
            PersistenceController.shared.clear()
        }

        let urlString = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(MenuList.self, from: data) {

                    for item in decoded.menu {
                        let dish = Dish(context: viewContext)
                        dish.title = item.title
                        dish.price = item.price
                        dish.dishDescription = item.description
                        dish.category = categoryForDish(title: item.title)
                    }

                    DispatchQueue.main.async {
                        try? viewContext.save()
                    }
                }
            }
        }

        task.resume()
    }

    var orderForDeliverySection: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("ORDER FOR DELIVERY!")
                .font(.title3)
                .bold()
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedOrderCategory == category
                                    ? Color.gray.opacity(0.25)
                                    : Color.gray.opacity(0.12)
                            )
                            .cornerRadius(20)
                            .onTapGesture {
                                selectedOrderCategory = category
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    
    var menuListSection: some View {
        FetchedObjects(
            predicate: buildPredicate(),
            sortDescriptors: buildSortDescriptors()
        ) { (dishes: [Dish]) in
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(dishes) { dish in
                        HStack(spacing: 12) {

                            VStack(alignment: .leading, spacing: 4) {
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

                            let title = dish.title ?? ""
                            if let imgName = dishImageMap[title] {
                                Image(imgName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.vertical, 8)
            }
            .background(Color.clear)
        }
    }



}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17,
                            (int >> 4 & 0xF) * 17,
                            (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24,
                            int >> 16 & 0xFF,
                            int >> 8 & 0xFF,
                            int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}




#Preview {
    Menu()
}
