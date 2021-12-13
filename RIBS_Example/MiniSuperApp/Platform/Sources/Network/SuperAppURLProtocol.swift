//
//  SuperAppURLProtocol.swift
//  
//
//  Created by kakao on 2021/12/14.
//
// AppRoot에 들어가야 하는데, 모듈화를 덜 해서 이쪽에 구현

import Foundation

typealias Path = String
typealias MockResponse = (statusCode: Int, data: Data?)

public final class SuperAppURLProtocol: URLProtocol {
    
    static var successMock: [Path: MockResponse] = [:]
    static var failureErrors: [Path: Error] = [:]
    
    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override func startLoading() {
        if let path = request.url?.path {
            if let mockResponse = SuperAppURLProtocol.successMock[path] {
                client?.urlProtocol(self, didReceive: HTTPURLResponse(url: request.url!, statusCode: mockResponse.statusCode, httpVersion: nil, headerFields: nil)!, cacheStoragePolicy: .notAllowed)
                mockResponse.data.map { client?.urlProtocol(self, didLoad: $0) }
            } else if let error = SuperAppURLProtocol.failureErrors[path] {
                client?.urlProtocol(self, didFailWithError: error)
            }
        } else {
            client?.urlProtocol(self, didFailWithError: MockSessionError.notSupported)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    public override func stopLoading() {
        
    }
}

enum MockSessionError: Error {
    case notSupported
}
