import UIKit

public enum APIMethod: String {
    case post = "POST"
    case get = "GET"
}

public struct APILib {
    
    public typealias JSON = [String: AnyObject]
    public typealias OJSON = [String : Any?]
    public typealias apiComp = (scheme: String, host: String, path: String)
    public typealias header = (headerValue: String? , headerKey: String)
    
    public static func returnUrl(_ parameters: OJSON?, apiComponents: (scheme: String, host: String, path: String), withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = apiComponents.scheme
        components.host = apiComponents.host
        components.path = apiComponents.path + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        if let params = parameters {
            for (key, value) in params {
                let queryItem = URLQueryItem(name: key, value: "\(value ?? "")")
                components.queryItems!.append(queryItem)
            }
        }

        guard let url = components.url else {fatalError("URL Not valid")}
        return url
    }
    
    //MARK: Make Post Request With Header
    public static func makeRequest(method: APIMethod, params: OJSON? = nil, encodedParams: Encodable? = nil, withHeader: header? = nil, apiComponents: apiComp, withPathExtension: String? = nil  ) -> URLRequest {
        
        var req: URLRequest!
        
        if method == .post {
            req = URLRequest(url: APILib.returnUrl([:], apiComponents: apiComponents, withPathExtension: withPathExtension))
            
            req.httpBody = JSONEncoder().encode(encodedParams)

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
    
    public static func dictToJson_Convertor(_ params: OJSON) -> NSString? {
        
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
