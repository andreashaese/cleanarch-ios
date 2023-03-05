import Foundation

@MainActor class QuotePageViewModel: ObservableObject {
    private let loadQuote: any LoadQuoteUseCase
    
    @Published private(set) var quoteState = QuoteLoadingState.notLoaded
    
    init(loadQuoteUseCase: any LoadQuoteUseCase = InjectedValues[\.loadQuoteUseCase]) {
        self.loadQuote = loadQuoteUseCase
    }
    
    func reload() async {
        quoteState = .loading
        
        do {
            let quote = try await loadQuote()
            quoteState = .loaded(text: quote.text, author: quote.author)
        } catch {
            quoteState = .error
        }
    }
}
