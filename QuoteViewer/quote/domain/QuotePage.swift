import SwiftUI

struct QuotePage: View {
    @StateObject private var viewModel = QuotePageViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            
            switch viewModel.quoteState {
            case .notLoaded:
                Text("Not loaded")
            case .loading:
                ProgressView()
            case .loaded(text: let text, author: let author):
                QuoteView(text: text, author: author)
                    .padding()
            case .error:
                ErrorView()
            }
            
            Spacer()
            
            Button(action: reload) {
                Image(systemName: "arrow.clockwise")
                Text("Next Quote")
            }
            .disabled(viewModel.quoteState == .loading)
        }
        .padding()
        .onAppear(perform: reload)
    }
    
    private func reload() {
        Task {
            await viewModel.reload()
        }
    }
}
