//
//  NetworkAPI+Ext.swift
//  RxNetworks
//
//  Created by Condy on 2021/10/5.
//

import Foundation
import Alamofire
import Moya

/// 协议默认实现方案
/// Protocol default implementation scheme
extension NetworkAPI {
    
    public func request() -> APISingleJSON {
        return request(callbackQueue: nil)
    }
    
    public func request(callbackQueue: DispatchQueue?) -> APISingleJSON {
        var tempPlugins: APIPlugins = self.plugins
        NetworkUtil.defaultPlugin(&tempPlugins, api: self)
        
        let target = MultiTarget.target(self)

        let (result, end) = NetworkUtil.handyConfigurationPlugin(tempPlugins, target: target)
        if end == true {
            let single = NetworkUtil.transformAPISingleJSON(result)
            return single
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.headers = Alamofire.HTTPHeaders.default
        configuration.timeoutIntervalForRequest = 30
        let session = Moya.Session(configuration: configuration, startRequestsImmediately: false)
        let MoyaProvider = MoyaProvider<MultiTarget>(stubClosure: { _ in
            return stubBehavior
        }, session: session, plugins: tempPlugins)
        let single = MoyaProvider.rx.request(api: self, callbackQueue: callbackQueue)
        
        let angin = NetworkUtil.handyLastNeverPlugin(tempPlugins, target: target, single: single)
        if angin == true {
            return self.request(callbackQueue: callbackQueue)
        }
        return single
    }
}

extension NetworkAPI {
    public var ip: APIHost {
        return NetworkConfig.baseURL
    }
    
    public var parameters: APIParameters? {
        return nil
    }
    
    public var plugins: APIPlugins {
        return []
    }
    
    public var stubBehavior: APIStubBehavior {
        return APIStubBehavior.never
    }
    
    public var retry: APINumber {
        return 0
    }
    
    // moya
    public var baseURL: URL {
        return URL(string: ip)!
    }
    
    public var path: APIPath {
        return ""
    }
    
    public var validationType: Moya.ValidationType {
        return Moya.ValidationType.successCodes
    }
    
    public var method: APIMethod {
        return NetworkConfig.baseMethod
    }
    
    public var sampleData: Data {
        return "{\"Condy\":\"ykj310@126.com\"}".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    public var task: Moya.Task {
        var param = NetworkConfig.baseParameters
        if let parameters = parameters {
            // Merge the dictionaries and take the second value
            param = NetworkConfig.baseParameters.merging(parameters) { $1 }
        }
        switch method {
        case APIMethod.get:
            return .requestParameters(parameters: param, encoding: URLEncoding.default)
        case APIMethod.post:
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        default:
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
}
