import XCTest
@testable import QuoteViewer

final class ApiQuoteServiceTests: XCTestCase {

    class SucceedingTestHttpFetcher: HttpFetcher {
        let response: HttpResponse
        var fetchedUrl: URL?
        
        init(response: HttpResponse) {
            self.response = response
        }
        
        func get(_ url: URL) async throws -> HttpResponse {
            fetchedUrl = url
            return response
        }
    }
    
    class FailingTestHttpFetcher: HttpFetcher {
        let error: Error
        
        init(error: Error) {
            self.error = error
        }
        
        func get(_ url: URL) async throws -> HttpResponse {
            throw error
        }
    }
    
    func testServiceReturnsQuoteFromApi() async throws {
        let json = #"{"quote": "This is a quote", "author": "This is an author"}"#
        let response = HttpResponse(statusCode: 200, data: json.data(using: .utf8)!)
        let testFetcher = SucceedingTestHttpFetcher(response: response)
        let service = ApiQuoteService(fetcher: testFetcher)
        
        let quote = try await service.getQuote()
        
        XCTAssertEqual(quote.text, "This is a quote")
        XCTAssertEqual(quote.author, "This is an author")
    }
    
    func testServiceFetchesCorrectUrl() async throws {
        let json = #"{"quote": "This is a quote", "author": "This is an author"}"#
        let response = HttpResponse(statusCode: 200, data: json.data(using: .utf8)!)
        let testFetcher = SucceedingTestHttpFetcher(response: response)
        let service = ApiQuoteService(fetcher: testFetcher)
        
        _ = try await service.getQuote()
        
        XCTAssertEqual(testFetcher.fetchedUrl?.absoluteString, "https://dummyjson.com/quotes/random")
    }
    
    func testServiceThrowsErrorForInvalidStatusCodes() async throws {
        let invalidResponseCodes = [100, 199, 300, 400, 401, 402, 403, 500]
        
        let json = #"{"quote": "This is a quote", "author": "This is an author"}"#
        
        for responseCode in invalidResponseCodes {
            let response = HttpResponse(statusCode: responseCode, data: json.data(using: .utf8)!)
            let testFetcher = SucceedingTestHttpFetcher(response: response)
            let service = ApiQuoteService(fetcher: testFetcher)
            
            do {
                _ = try await service.getQuote()
                XCTFail("Should throw an error for response code \(responseCode)")
            } catch {}
        }
    }
    
    func testServiceThrowsErrorForInvalidResponse() async throws {
        let json = #"{"error": "This response is malformed"}"#
        let response = HttpResponse(statusCode: 200, data: json.data(using: .utf8)!)
        let testFetcher = SucceedingTestHttpFetcher(response: response)
        let service = ApiQuoteService(fetcher: testFetcher)
        
        do {
            _ = try await service.getQuote()
            XCTFail("Should throw an error for malformed response")
        } catch {}
    }
    
    func testServiceThrowsErrorWhenFetcherThrowsError() async throws {
        struct SomeError: Error {}
        let testFetcher = FailingTestHttpFetcher(error: SomeError())
        let service = ApiQuoteService(fetcher: testFetcher)
        
        do {
            _ = try await service.getQuote()
            XCTFail("Should throw an error")
        } catch {}
    }

}
