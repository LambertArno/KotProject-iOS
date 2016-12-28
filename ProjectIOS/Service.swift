import Foundation

class Service {
    
    enum Error: Swift.Error {
        case missingJsonProperty(name: String)
        case noNetwork
        case unexpectedStatusCode(found: Int, expected: Int)
        case missingJsonData
        case invalidJsonData(message: String)
        case other(Swift.Error)
    }
    
    static let shared = Service()
    
    private let url: URL
    private let session: URLSession
    
    private init() {
    
        url = URL(string: "https://datatank.stad.gent/4/wonen/kotatgent.json")!
        session = URLSession(configuration: .ephemeral)
    
    }
    
    
    func loadDataTask(completionHandler: @escaping (Result<[Kot]>) -> Void) -> URLSessionTask {
        let task = session.dataTask(with: url){
            data, response, error in
            
            let completionHandler: (Result<[Kot]>) -> Void = {
                result in
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.noNetwork))
                return // Scope breken bij guards
            }
            
            guard response.statusCode == 200 else {
                completionHandler(.failure(.unexpectedStatusCode(found: response.statusCode, expected: 200)))
                return // Scope breken bij guards
            }
            
            guard let data = data else {
                completionHandler(.failure(.missingJsonData))
                return // Scope breken bij guards
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let results = json as? [[String: Any]] else {
                    completionHandler(.failure(.invalidJsonData(message: "Data does not contain an array of objects")))
                    return
            }
            do {
                let koten = try results.map { try Kot(json: $0) }
                completionHandler(.success(koten))
            } catch let error as Service.Error{
                completionHandler(.failure(error))
            } catch {
                completionHandler(.failure(.other(error)))
            }
        }
        return task
    }
}
