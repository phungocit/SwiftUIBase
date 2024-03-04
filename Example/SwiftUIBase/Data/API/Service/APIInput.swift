//
//  APIInput.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Alamofire
import SwiftUIBase

class APIInput<Parameters: Encodable>: APIInputBase<Parameters> {
    override init(
        urlString: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoder: ParameterEncoder? = nil
    ) {
        super.init(
            urlString: urlString,
            method: method,
            parameters: parameters,
            encoder: encoder
        )

        headers = [
            HTTPHeader.contentType("application/json; charset=utf-8"),
            HTTPHeader.accept("application/json"),
        ]
    }
}
