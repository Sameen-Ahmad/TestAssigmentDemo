
import Foundation
import Alamofire

class MovieService {
    static let shared = MovieService()
    private let apiKey = "336658ddb87a600f36d42b9969cefc0b"
    private let baseURL = "https://api.themoviedb.org/3"

    func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(query)"
        AF.request(url).responseDecodable(of: MovieSearchResults.self) { response in
            switch response.result {
            case .success(let results):
                completion(.success(results.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let url = "\(baseURL)/movie/\(movieId)?api_key=\(apiKey)"
        AF.request(url).responseDecodable(of: Movie.self) { response in
            switch response.result {
            case .success(let movie):
                completion(.success(movie))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


class MockMovieService: MovieService {
    var shouldReturnError = false

    override func searchMovies(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else {
            let mockMovies = [
                Movie(id: 1, title: "Mock Movie", posterPath: nil, releaseDate: "2023-01-01", overview: "Mock overview", rating: 8.0)
            ]
            completion(.success(mockMovies))
        }
    }
}


