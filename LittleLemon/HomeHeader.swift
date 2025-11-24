import SwiftUI

struct HomeHeader: View {
    var body: some View {
        HStack {
            Image("little-lemon-logo")
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
