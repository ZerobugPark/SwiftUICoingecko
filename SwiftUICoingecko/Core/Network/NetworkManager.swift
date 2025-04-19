//
//  NetworkManger.swift
//  SwiftUICoingecko
//
//  Created by youngkyun park on 4/19/25.
//

import UIKit

enum APIError: Int, Error {
    case urlError
    case badRequest = 400   // 잘못된 정보 요청
    case unauthorized = 401 // 허가되지 않은 서명
    case forbidden = 403 // 서버에서 차단되어 요청을 승인할 수 없음
    case baseURLError = 404 // 잘못된 요청 URL
    case tooManyRequests = 429 // 요청 횟수 제한 (잠시 후 다시 시도)
    case internalServerError = 500 // 서버에서 발생한 오류
    case serviceUnavailable   = 503 // 서비스 이용 불가
    case accessDenied = 1020 // CDN 방화벽 규칙 위반
    case apiKeyMissing = 10002 // 잘못된 API키
    case noconnection = 999 // 인터넷 연결 끊김
    case unknown = 99999 // 임의의 에러 값
    
    
    
    var message: String {
        switch self {
        case .urlError:
            return "잘못된 주소입니다."
        case .badRequest:
            return "잘못된 정보 요청"
        case .unauthorized:
            return "허가되지 않은 서명"
        case .forbidden:
            return "서버에서 차단되어 요청을 승인할 수 없음"
        case .baseURLError:
            return "잘못된 요청 URL"
        case .tooManyRequests:
            return "요청 횟수 제한 (잠시 후 다시 시도)"
        case .internalServerError:
            return "서버에서 발생한 오류"
        case .serviceUnavailable:
            return "서비스 이용 불가"
        case .accessDenied:
            return "CDN 방화벽 규칙 위반"
        case .apiKeyMissing:
            return "잘못된 API키"
        case .noconnection:
            return "인터넷 연결 끊김"
        case .unknown:
            return "임의의 에러 값"
        }
    }
}



final class NetworkManager: NetworkService {
    
    
    static let shared = NetworkManager()
    
    private let decoder: JSONDecoder
    
    private init() {
        self.decoder = JSONDecoder()
    }
    
    func callRequest<T: Decodable>(api: CoinGeckpRequest, type: T.Type) async throws -> T {
        
        guard let request = api.asURLRequest() else {
            throw APIError.urlError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown
                }
                
                
                switch httpResponse.statusCode {
                case APIError.badRequest.rawValue: throw APIError.badRequest
                case APIError.unauthorized.rawValue: throw APIError.unauthorized
                case APIError.forbidden.rawValue: throw APIError.forbidden
                case APIError.baseURLError.rawValue: throw APIError.baseURLError
                case APIError.tooManyRequests.rawValue: throw APIError.tooManyRequests
                case APIError.internalServerError.rawValue: throw APIError.internalServerError
                case APIError.serviceUnavailable.rawValue: throw APIError.serviceUnavailable
                case APIError.accessDenied.rawValue: throw APIError.accessDenied
                case APIError.apiKeyMissing.rawValue: throw APIError.apiKeyMissing
                case APIError.noconnection.rawValue: throw APIError.noconnection
                default:
                    throw APIError.unknown
                }
                
            }
            
            dump(data)
            let decodedData = try decoder.decode(T.self, from: data)
            
            return decodedData
        } catch {
            throw error
            
        }
 
    }
}


