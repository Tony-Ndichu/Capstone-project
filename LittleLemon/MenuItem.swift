//
//  MenuItem.swift
//  LittleLemon
//
//  Created by TONY NDICHU on 11/23/25.
//


import Foundation

struct MenuItem: Decodable, Identifiable {
    let id = UUID()
    let title: String
    let image: String
    let price: String
    let description: String?

    private enum CodingKeys: String, CodingKey {
        case title, image, price, description
    }
}
