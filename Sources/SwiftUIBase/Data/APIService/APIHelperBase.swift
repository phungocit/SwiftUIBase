//
//  APIHelperBase.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Alamofire
import Foundation

public enum APIHelperBase {
    public static func getURLParameterEncoder(
        keyEncoding: URLEncodedFormEncoder.KeyEncoding = .convertToSnakeCase
    ) -> ParameterEncoder {
        let urlEncoder = URLEncodedFormEncoder(keyEncoding: keyEncoding)
        return URLEncodedFormParameterEncoder(encoder: urlEncoder)
    }

    public static func getJSONParameterEncoder(
        keyEncoding: JSONEncoder.KeyEncodingStrategy = .convertToSnakeCase
    ) -> ParameterEncoder {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = keyEncoding
        return JSONParameterEncoder(encoder: jsonEncoder)
    }
}
