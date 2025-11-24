//
//  UserProfile.swift
//  LittleLemon
//
//  Created by TONY NDICHU on 11/23/25.
//


import SwiftUI

struct UserProfile: View {

    // Pull values from UserDefaults
    let firstName: String = UserDefaults.standard.string(forKey: kFirstNameKey) ?? ""
    let lastName:  String = UserDefaults.standard.string(forKey: kLastNameKey)  ?? ""
    let email:     String = UserDefaults.standard.string(forKey: kEmailKey)     ?? ""

    @Environment(\.presentationMode) var presentation

    var body: some View {
        VStack(spacing: 20) {

            Text("Personal information")
                .font(.title)
                .bold()

            Image("profile-image-placeholder")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())

            Text(firstName)
                .font(.headline)

            Text(lastName)
                .font(.headline)

            Text(email)
                .font(.subheadline)

            Button("Logout") {
                // Clear login status
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)

                // Navigate back to onboarding
                self.presentation.wrappedValue.dismiss()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)

            Spacer()
        }
        .padding()
    }
}

#Preview {
    UserProfile()
}
