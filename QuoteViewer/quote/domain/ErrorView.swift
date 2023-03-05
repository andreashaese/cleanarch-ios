import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack(spacing: 32.0) {
            Image(systemName: "wifi.slash")
                .resizable()
                .frame(width: 48.0, height: 48.0, alignment: .center)
                .foregroundColor(.gray)
            Text("Something went wrong, please try again")
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
