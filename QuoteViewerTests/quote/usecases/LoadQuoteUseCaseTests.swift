import XCTest
@testable import QuoteViewer

final class LoadQuoteUseCaseTests: XCTestCase {

    struct SucceedingTestQuoteService: QuoteService {
        let text: String
        let author: String
        
        func getQuote() async throws -> Quote {
            Quote(text: text, author: author)
        }
    }
    
    struct FailingTestQuoteService: QuoteService {
        let error: Error
        
        func getQuote() async throws -> Quote {
            throw error
        }
    }
    
    func testLoadQuoteReturnsQuoteFromService() async throws {
        let service = SucceedingTestQuoteService(text: "Some text", author: "Some author")
        let loadQuoteUseCase = LoadQuote(quoteService: service)
        
        let quote = try await loadQuoteUseCase()
        
        XCTAssertEqual(quote.text, "Some text")
        XCTAssertEqual(quote.author, "Some author")
    }
    
    func testLoadQuoteThrowsWhenServiceThrows() async throws {
        struct SomeError: Error {}
        let service = FailingTestQuoteService(error: SomeError())
        let loadQuoteUseCase = LoadQuote(quoteService: service)
        
        do {
            _ = try await loadQuoteUseCase()
            XCTFail("Did not throw")
        } catch {}
    }

}
