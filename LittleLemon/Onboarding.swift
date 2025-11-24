import SwiftUI

struct Onboarding: View {

    // User input
    @State var firstName = ""
    @State var lastName  = ""
    @State var email     = ""

    // Navigation toggle
    @State var isLoggedIn = false

    var body: some View {
        NavigationStack {

            VStack(spacing: 20) {
                // Text fieldsq
                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)

                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)

                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)

                // Registration button
                Button {
                                    registerUser()
                                } label: {
                                    Text("Register")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }

                Spacer()
            }
            .padding()
            .onAppear {
                            // Auto-skip onboarding if already logged in
                            if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                                isLoggedIn = true
                            }
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                            Home()
                        }
        }
    }
    
    private func registerUser() {
            guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty else {
                print("Fields cannot be empty")
                return
            }

            UserDefaults.standard.set(firstName, forKey: kFirstNameKey)
            UserDefaults.standard.set(lastName,  forKey: kLastNameKey)
            UserDefaults.standard.set(email,     forKey: kEmailKey)
            UserDefaults.standard.set(true,      forKey: kIsLoggedIn)

            isLoggedIn = true
        }
}

#Preview {
    Onboarding()
}

