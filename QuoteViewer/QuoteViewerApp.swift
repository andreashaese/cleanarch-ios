import SwiftUI

@main
struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            QuotePage()
        }
    }
}

// Dependency Injection

private struct LoadQuoteUseCaseKey: InjectionKey {
    static var currentValue: any LoadQuoteUseCase = LoadQuote()
}

private struct QuoteServiceKey: InjectionKey {
    static var currentValue: any QuoteService = ApiQuoteService(fetcher: UrlSessionHttpFetcher())
}

extension InjectedValues {
    var quoteService: any QuoteService {
        get { Self[QuoteServiceKey.self] }
        set { Self[QuoteServiceKey.self] = newValue }
    }
    
    var loadQuoteUseCase: any LoadQuoteUseCase {
        get { Self[LoadQuoteUseCaseKey.self] }
        set { Self[LoadQuoteUseCaseKey.self] = newValue }
    }
}
