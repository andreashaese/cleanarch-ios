import Foundation

protocol HttpFetcher {
    func get(_ url: URL) async throws -> HttpResponse
}
