//
//  APIInputBase.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Alamofire
import Foundation

open class APIInputBase<Parameters: Encodable> {
    public var headers: HTTPHeaders?
    public var urlString: String
    public var method: HTTPMethod
    public var encoder: ParameterEncoder
    public var parameters: Parameters?
    public var keyStrategyForDecodeResponse = JSONDecoder.KeyDecodingStrategy.convertFromSnakeCase
    public var accessToken: String?
    public var isUseCache = false

    public var requestDescription: String {
        var description = "🌎 \(method.rawValue) \(urlString)"

        if let parameters {
            description += "\nPARAMETERS: \(parameters)"
        }
        if let headers {
            description += "\nHEADERS:\n\(headers.description)"
        }

        return description
    }

    public init(
        urlString: String,
        method: HTTPMethod,
        parameters: Parameters?,
        encoder: ParameterEncoder?
    ) {
        self.urlString = urlString
        self.parameters = parameters
        self.method = method

        if let encoder = encoder {
            self.encoder = encoder
        } else {
            self.encoder = method == .get
                ? APIHelperBase.encodeParameterForURL()
                : APIHelperBase.encodeParameterForJSON()
        }
    }
}
