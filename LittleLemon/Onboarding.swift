import SwiftUI

// Global UserDefaults keys
let kFirstNameKey = "firstNameKey_ll"
let kLastNameKey  = "lastNameKey_ll"
let kEmailKey     = "emailKey_ll"
let kIsLoggedIn   = "isLoggedIn_ll"

struct Onboarding: View {

    // User input
    @State var firstName = ""
    @State var lastName  = ""
    @State var email     = ""

    // Navigation toggle
    @State var isLoggedIn = false

    var body: some View {
        NavigationView {

            VStack(spacing: 20) {

                // Invisible navigation trigger
                NavigationLink(
                    destination: Home(),
                    isActive: $isLoggedIn
                ) {
                    EmptyView()
                }

                // Text fields
                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)

                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)

                // Registration button
                Button("Register") {
                    if !firstName.isEmpty &&
                        !lastName.isEmpty &&
                        !email.isEmpty {

                        UserDefaults.standard.set(firstName, forKey: kFirstNameKey)
                        UserDefaults.standard.set(lastName,  forKey: kLastNameKey)
                        UserDefaults.standard.set(email,     forKey: kEmailKey)
                        UserDefaults.standard.set(true, forKey: kIsLoggedIn)

                        // Navigate to the Home screen
                        isLoggedIn = true
                    } else {
                        print("Fields cannot be empty")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                Spacer()
            }
            .padding()
            .onAppear {
                            // Auto-skip onboarding if already logged in
                            if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                                isLoggedIn = true
                            }
                        }
        }
    }
}

#Preview {
    Onboarding()
}

