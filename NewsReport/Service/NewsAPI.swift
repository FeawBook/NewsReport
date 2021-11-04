import Moya
import Foundation

enum NewsApi {
    static private let apiKey = ""
    case getNews(page: Int)
}

extension NewsApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2")!
    }
    
    var path: String {
        switch self {
        case .getNews:
                return "/everything"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNews:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getNews(let page):
            return .requestParameters(
                parameters: [
                    "q" : "crypto",
                    "from": "2021-11-01",
                    "to": "2021-11-01",
                    "sortBy": "popularity",
                    "page": "\(page)",
                    "apiKey": "f19401e762d04262b6f511ae6c5e5deb"
                ],
                encoding: URLEncoding.default
            )
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

extension TargetType {
    func endpointForAPI(response: EndpointSampleResponse) -> Endpoint {
        return Endpoint(url: baseURL.absoluteString,
                        sampleResponseClosure: { response },
                        method: method,
                        task: task,
                        httpHeaderFields: headers)
    }
}
