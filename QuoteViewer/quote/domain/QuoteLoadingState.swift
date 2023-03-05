enum QuoteLoadingState: Equatable {
    case notLoaded
    case loading
    case loaded(text: String, author: String)
    case error
}
