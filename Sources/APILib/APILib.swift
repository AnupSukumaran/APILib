import UIKit

public enum APIMethod: String {
    case post = "POST"
    case get = "GET"
}

public struct APILib {
    
    public typealias JSON = [String: AnyObject]
    
    public static func returnUrl(_ parameters: JSON?, apiComponents: (scheme: String, host: String, path: String), withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = apiComponents.scheme
        components.host = apiComponents.host
        components.path = apiComponents.path + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        if let params = parameters {
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }

        guard let url = components.url else {fatalError("URL Not valid")}
        return url
    }
    
    //MARK: Make Post Request With Header
    public static func makeRequest(method: APIMethod, params: JSON, withHeader: (authID: String? , headerKey: String)? = nil,    apiComponents: (scheme: String, host: String, path: String), withPathExtension: String? = nil  ) -> URLRequest {
        
        var req: URLRequest!
        
        if method == .post {
            req = URLRequest(url: APILib.returnUrl([:], apiComponents: apiComponents, withPathExtension: withPathExtension))
            if let jsonBody = APILib.dictToJson_Convertor(params) as String?  {
               req.httpBody = jsonBody.data(using: String.Encoding.utf8)
            }
        } else {
            req = URLRequest(url: APILib.returnUrl(params, apiComponents: apiComponents, withPathExtension: withPathExtension))
        }
        
        req.httpMethod = method.rawValue
        req.timeoutInterval = 60
        
        if let head = withHeader, let auth = head.authID {
            req.addValue(auth, forHTTPHeaderField: head.headerKey)
        }

        return req
    }
    
    public static func dictToJson_Convertor(_ params: JSON) -> NSString? {
        
        let jsonData = try! JSONSerialization.data(withJSONObject: params)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        return jsonString
    }
    
    public static func statusPassed(_ statusCode: Int?,_ rangeStatusCode: (from: Int, to: Int)) -> Bool {
        guard let code = statusCode, code >= rangeStatusCode.from && code <= rangeStatusCode.to else {
            return false
        }
        return true
    }
    
}
