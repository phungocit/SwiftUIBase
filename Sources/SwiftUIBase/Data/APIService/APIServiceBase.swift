//
//  APIServiceBase.swift
//  SwiftUIBase
//
//  Created by Foo Tran on 09/26/2023.
//

import Alamofire
import Combine
import Foundation

open class APIServiceBase {
    public var manager: Session

    public convenience init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        self.init(configuration: configuration)
    }

    public init(configuration: URLSessionConfiguration) {
        manager = Session(configuration: configuration)
    }

    // MARK: - Request API.

    /// Makes a network request for the specified API input and returns a publisher that emits
    /// the specified generic type `T` upon success, or an error upon failure.
    /// - Parameter input: An instance of `APIInputBase` representing the input parameters
    /// for the API request.
    /// - Returns: A publisher that emits an type `T` or errors of type `Error`.
    open func request<T: Codable, Parameters: Encodable>(
        _ input: APIInputBase<Parameters>
    ) -> Observable<T> {
        print(input.requestDescription)

        return requestData(input)
            .tryMap { [unowned self] data -> T in
                try decodeResponse(data, keyDecodingStrategy: input.keyDecodingStrategy)
            }
            .eraseToAnyPublisher()
    }

    /// Makes a data request to the API using the specified input parameters and
    /// returns a publisher that emits an `APIResponse` of the specified generic type `U`
    /// upon success, or an error upon failure.
    /// - Parameter input: An instance of `APIInputBase` representing the input parameters
    /// for the API request.
    /// - Returns: A publisher that emits an `APIResponse` of type `U` or errors of type `Error`.
    open func requestData<Parameters: Encodable>(
        _ input: APIInputBase<Parameters>
    ) -> Observable<Data> {
        manager.request(
            input.urlString,
            method: input.method,
            parameters: input.parameters,
            encoder: input.encoder,
            headers: input.headers
        )
        .publishData()
        .tryMap { [unowned self] dataResponse -> Data in
            try processMap(dataResponse)
        }
        .tryCatch { [unowned self] error -> Observable<Data> in
            try handleRequestError(error, input: input)
        }
        .eraseToAnyPublisher()
    }

    ///  Processes the given data response and returns an `APIResponse` containing parsed data
    ///  of type `U`.
    /// - Parameter dataResponse: The Alamofire `DataResponse` containing the data and
    /// any error encountered during the request.
    /// - Returns: An `APIResponse` with parsed data of type `U`.
    open func processMap(
        _ dataResponse: DataResponse<Data, AFError>
    ) throws -> Data {
        let error: Error

        switch dataResponse.result {
        case let .success(data):
            guard let statusCode = dataResponse.response?.statusCode else {
                throw APIUnknownError(statusCode: nil)
            }
            let urlRequest = dataResponse.response?.url?.absoluteString ?? ""

            switch statusCode {
            case 200 ..< 300:
                let responseJSON = try? JSONSerialization.jsonObject(with: data)

                print("👍 [\(statusCode)] \(urlRequest)")
                print("[RESPONSE JSON]: \(responseJSON ?? "Empty")")

                return data
            default:
                error = handleResponseError(dataResponse: dataResponse, data: data)

                print("❌ [\(statusCode)] \(urlRequest)")
            }

        case let .failure(aFError):
            error = aFError
        }

        throw error
    }

    // MARK: - Decode response.

    /// Description
    /// - Parameter apiResponse: apiResponse description
    /// - Returns: description
    open func decodeResponse<T: Codable>(
        _ data: Data,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    ) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = keyDecodingStrategy

            let items = try decoder.decode(T.self, from: data)

            print("[RESPONSE DECODE]: \(items)")

            return items
        } catch {
            print("❌ [RESPONSE DECODE FAIL]: \(error)")
            throw APIResponseDecodeError(error)
        }
    }

    // MARK: - Handle error.

    /// Handles errors that may occur during API request processing.
    /// - Parameters:
    ///   - error: The error that occurred during the request.
    ///   - input: The input configuration for the API request, including parameters.
    /// - Returns: A publisher emitting an `APIResponse` of type `U` or an error of type `Error`.
    open func handleRequestError<Parameters: Encodable>(
        _ error: Error,
        input: APIInputBase<Parameters>
    ) throws -> Observable<Data> {
        throw error
    }

    /// Handles response errors for a data response.
    /// - Parameters:
    ///   - dataResponse: The data response received from the server.
    ///   - data: The data associated with the response.
    /// - Returns: An `Error` representing the response error.
    open func handleResponseError(
        dataResponse: DataResponse<Data, AFError>,
        data: Data?
    ) -> Error {
        APIUnknownError(statusCode: dataResponse.response?.statusCode)
    }
}
