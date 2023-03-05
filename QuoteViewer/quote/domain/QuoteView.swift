import SwiftUI

struct QuoteView: View {
    let text: String
    let author: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("“")
                .font(.largeTitle)
                .fontDesign(.serif)
                .foregroundColor(.gray)
            
            VStack(alignment: .trailing, spacing: 16.0) {
                Text(text)
                    .font(.largeTitle)
                    .fontDesign(.serif)
                
                Text("– " + author)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .italic()
            }
        }.padding()
    }
}

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        QuoteView(
            text: "The way to get started is to quit talking and begin doing.",
            author: "Walt Disney"
        )
    }
}
