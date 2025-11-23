import SwiftUI

struct Home: View {
    var body: some View {
        NavigationView {
            TabView {

                Menu()
                    .tabItem {
                        Label("Menu", systemImage: "list.dash")
                    }

                UserProfile()
                    .tabItem {
                        Label("Profile", systemImage: "square.and.pencil")
                    }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    Home()
}

