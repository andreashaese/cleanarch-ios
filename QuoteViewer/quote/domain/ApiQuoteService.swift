import Foundation

class ApiQuoteService: QuoteService {
    enum ApiQuoteError: Error {
        case invalidResponse
    }
    
    private struct ResponseObject: Decodable {
        let quote: String
        let author: String
        
        func toQuote() -> Quote {
            Quote(text: quote, author: author)
        }
    }
    
    private let fetcher: any HttpFetcher
    
    init(fetcher: any HttpFetcher) {
        self.fetcher = fetcher
    }
    
    func getQuote() async throws -> Quote {
        let response = try await fetcher.get(URL(string: "https://dummyjson.com/quotes/random")!)
        
        guard (200..<300).contains(response.statusCode) else {
            throw ApiQuoteError.invalidResponse
        }
        
        let quoteObject = try JSONDecoder().decode(ResponseObject.self, from: response.data)
        
        return quoteObject.toQuote()
    }
}
