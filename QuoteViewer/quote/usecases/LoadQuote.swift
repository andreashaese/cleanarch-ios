protocol LoadQuoteUseCase {
    func callAsFunction() async throws -> Quote
}

struct LoadQuote: LoadQuoteUseCase {
    private let quoteService: any QuoteService
    
    init(quoteService: any QuoteService = InjectedValues[\.quoteService]) {
        self.quoteService = quoteService
    }
    
    func callAsFunction() async throws -> Quote {
        try await quoteService.getQuote()
    }
}
