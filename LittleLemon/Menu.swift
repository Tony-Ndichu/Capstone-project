//
//  Menu.swift
//  LittleLemon
//
//  Created by TONY NDICHU on 11/23/25.
//


import SwiftUI

struct Menu: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Little Lemon")
                .font(.largeTitle)
                .bold()

            Text("Chicago")
                .font(.title2)

            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            // This List will later show menu items
            List {
                // Empty for now
            }
        }
        .padding()
    }
}

#Preview {
    Menu()
}
