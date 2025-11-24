import SwiftUI

struct UserProfile: View {

    // Stored user values
    @State private var firstName = UserDefaults.standard.string(forKey: kFirstNameKey) ?? ""
    @State private var lastName  = UserDefaults.standard.string(forKey: kLastNameKey) ?? ""
    @State private var email     = UserDefaults.standard.string(forKey: kEmailKey) ?? ""
    @State private var phone     = UserDefaults.standard.string(forKey: kPhoneKey) ?? ""

    // Notification toggles
    @State private var notifyOrder   = UserDefaults.standard.bool(forKey: kNotifyOrder)
    @State private var notifyPw      = UserDefaults.standard.bool(forKey: kNotifyPw)
    @State private var notifyOffers  = UserDefaults.standard.bool(forKey: kNotifyOffers)
    @State private var notifyNews    = UserDefaults.standard.bool(forKey: kNotifyNews)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {

                    Text("Personal information")
                        .font(.title)
                        .bold()
                        .padding(.top, 10)

                    // Avatar
                    Image("profile-image-placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())

                    // Form fields
                    labeledField("First name", text: $firstName)
                    labeledField("Last name", text: $lastName)
                    labeledField("Email", text: $email)
                    labeledField("Phone number", text: $phone)

                    // Notifications section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Email notifications")
                            .font(.headline)

                        Toggle("Order statuses", isOn: $notifyOrder)
                        Toggle("Password changes", isOn: $notifyPw)
                        Toggle("Special offers", isOn: $notifyOffers)
                        Toggle("Newsletter", isOn: $notifyNews)
                    }
                    .padding(.top, 20)

                    // Save button
                    Button(action: saveProfile) {
                        Text("Save Changes")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#495E57"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                    // Logout button
                    Button(action: logout) {
                        Text("Logout")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }

                }
                .padding()
            }
        }
    }

    // MARK: Field Builder
    private func labeledField(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.headline)
            TextField(label, text: text)
                .textFieldStyle(.roundedBorder)
        }
    }

    // MARK: Save Profile
    private func saveProfile() {
        UserDefaults.standard.set(firstName, forKey: kFirstNameKey)
        UserDefaults.standard.set(lastName,  forKey: kLastNameKey)
        UserDefaults.standard.set(email,     forKey: kEmailKey)
        UserDefaults.standard.set(phone,     forKey: kPhoneKey)

        UserDefaults.standard.set(notifyOrder,  forKey: kNotifyOrder)
        UserDefaults.standard.set(notifyPw,     forKey: kNotifyPw)
        UserDefaults.standard.set(notifyOffers, forKey: kNotifyOffers)
        UserDefaults.standard.set(notifyNews,   forKey: kNotifyNews)
    }

    // MARK: Logout
    private func logout() {
        // Clear all stored values
        UserDefaults.standard.removeObject(forKey: kFirstNameKey)
        UserDefaults.standard.removeObject(forKey: kLastNameKey)
        UserDefaults.standard.removeObject(forKey: kEmailKey)
        UserDefaults.standard.removeObject(forKey: kPhoneKey)

        UserDefaults.standard.removeObject(forKey: kNotifyOrder)
        UserDefaults.standard.removeObject(forKey: kNotifyPw)
        UserDefaults.standard.removeObject(forKey: kNotifyOffers)
        UserDefaults.standard.removeObject(forKey: kNotifyNews)

        UserDefaults.standard.set(false, forKey: kIsLoggedIn)

        // Restart onboarding
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.rootViewController =
                UIHostingController(rootView: Onboarding())
    }
}

#Preview {
    UserProfile()
}

