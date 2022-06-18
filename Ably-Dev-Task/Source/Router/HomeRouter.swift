//
//  HomeRouter.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import Foundation

import Moya


enum HomeRouter {
    case fetchHomeData
    case fetchGoods(lastId: Int)
    
}

extension HomeRouter: TargetType {
    public var baseURL: URL {
        switch self {
        default: return URL(string: Constant.default.domain.url)!
        }
    }

    public var method: Moya.Method {
        switch self {
        default: return .get
            
        }
    }

    public var path: String {
        switch self {
        case .fetchHomeData:
            return "/api/home"
            
        case .fetchGoods:
            return "/api/home/goods"
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .fetchGoods(let lastId):
            return [
                "lastId": lastId
            ]
            
        default: return [:]
        }
    }

    public var task: Task {
        switch self {
        case .fetchGoods:
            return .requestParameters(
                parameters: self.parameters,
                encoding: URLEncoding.queryString
            )
            
        default:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        switch self {
        default: return ["Content-Type": "application/json"]
        }
    }
    
    public var sampleData: Data {
        switch self {
        default: return Data()
        }
    }
    
}
