import XCTest
import Combine
@testable import QuoteViewer

@MainActor final class QuotePageViewModelTests: XCTestCase {

    struct SucceedingTestLoadQuote: LoadQuoteUseCase {
        let text: String
        let author: String
        
        init(text: String = "", author: String = "") {
            self.text = text
            self.author = author
        }
        
        func callAsFunction() async throws -> Quote {
            Quote(text: text, author: author)
        }
    }
    
    struct FailingTestLoadQuote: LoadQuoteUseCase {
        let error: Error
        
        func callAsFunction() async throws -> Quote {
            throw error
        }
    }
    
    func testViewModelHasNotLoadedQuoteInitially() async throws {
        let viewModel = QuotePageViewModel(loadQuoteUseCase: SucceedingTestLoadQuote())
        
        XCTAssertEqual(viewModel.quoteState, QuoteLoadingState.notLoaded)
    }
    
    func testVieWModelIsLoadingWhenUseCaseIsInvoked() async throws {
        var subscriptions = Set<AnyCancellable>()
        let viewModel = QuotePageViewModel(loadQuoteUseCase: SucceedingTestLoadQuote())
        
        let exp = expectation(description: "Loading state is emitted")
        
        viewModel.$quoteState.sink { state in
            if state == .loading {
                exp.fulfill()
            }
        }.store(in: &subscriptions)
        
        await viewModel.reload()
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testVieWModelHasLoadedQuoteAfterReload() async throws {
        let viewModel = QuotePageViewModel(
            loadQuoteUseCase: SucceedingTestLoadQuote(
                text: "A quote text",
                author: "A quote author"
            )
        )
        
        await viewModel.reload()
        
        XCTAssertEqual(
            viewModel.quoteState,
            QuoteLoadingState.loaded(text: "A quote text", author: "A quote author")
        )
    }
    
    func testViewModelIsInErrorStateWhenUseCaseFails() async throws {
        struct SomeError: Error {}
        let viewModel = QuotePageViewModel(
            loadQuoteUseCase: FailingTestLoadQuote(error: SomeError())
        )
        
        await viewModel.reload()
        
        XCTAssertEqual(viewModel.quoteState, QuoteLoadingState.error)
    }

}
