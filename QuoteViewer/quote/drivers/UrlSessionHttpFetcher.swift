import Foundation

class UrlSessionHttpFetcher: HttpFetcher {
    enum UrlSessionError: Error {
        case invalidResponse
    }
    
    func get(_ url: URL) async throws -> HttpResponse {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw UrlSessionError.invalidResponse
        }
        
        return HttpResponse(statusCode: response.statusCode, data: data)
    }
}
