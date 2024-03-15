//
//  APIHelperBase.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Alamofire
import Foundation

public enum APIHelperBase {
    public static func encodeParameterForURL(
        keyEncoding: URLEncodedFormEncoder.KeyEncoding = .convertToSnakeCase
    ) -> ParameterEncoder {
        URLEncodedFormParameterEncoder(encoder: .init(keyEncoding: keyEncoding))
    }

    public static func encodeParameterForJSON(
        keyEncoding: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
    ) -> ParameterEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = keyEncoding
        return JSONParameterEncoder(encoder: jsonEncoder)
    }
}
