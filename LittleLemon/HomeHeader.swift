//
//  HomeHeader.swift
//  LittleLemon
//
//  Created by TONY NDICHU on 11/23/25.
//


import SwiftUI

struct HomeHeader: View {
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 40)

            Spacer()

            // Profile placeholder
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
