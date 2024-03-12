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
    /// - Returns: An type `T` or errors of type `Error`.
    open func request<T: Codable, Parameters: Encodable>(
        _ input: APIInputBase<Parameters>
    ) async throws -> T {
        print(input.requestDescription)
        do {
            let data = try await requestData(input)
            let result: T = try decodeResponse(data, keyDecodingStrategy: input.keyDecodingStrategy)
            return result
        } catch {
            print("❌ [REQUEST FAIL]: \(error)")
            throw error
        }
    }

    /// Makes a data request to the API using the specified input parameters and
    /// returns a publisher that emits an `APIResponse` of the specified generic type `U`
    /// upon success, or an error upon failure.
    /// - Parameter input: An instance of `APIInputBase` representing the input parameters
    /// for the API request.
    /// - Returns: `Data` or errors of type `Error`.
    open func requestData<Parameters: Encodable>(
        _ input: APIInputBase<Parameters>
    ) async throws -> Data {
        // You must resume the continuation exactly once.
        return try await withCheckedThrowingContinuation { continuation in
            manager.request(
                input.urlString,
                method: input.method,
                parameters: input.parameters,
                encoder: input.encoder,
                headers: input.headers
            )
            .responseData { dataResponse in
                switch dataResponse.result {
                case let .success(data):
                    guard let statusCode = dataResponse.response?.statusCode else {
                        continuation.resume(throwing: APIUnknownError(statusCode: nil))
                        return
                    }
                    let urlRequest = dataResponse.response?.url?.absoluteString ?? ""

                    switch statusCode {
                    case 200 ..< 300:
                        let responseJSON = try? JSONSerialization.jsonObject(with: data)

                        print("👍 [\(statusCode)] \(urlRequest)")
                        print("[RESPONSE JSON]: \(responseJSON ?? "Empty")")

                        continuation.resume(returning: data)
                    default:
                        let error = self.handleResponseError(dataResponse: dataResponse, data: data)

                        print("❌ [\(statusCode)] \(urlRequest)")
                        print("[RESPONSE ERROR]: \(error)")

                        continuation.resume(throwing: error)
                    }
                case let .failure(aFError):
                    continuation.resume(throwing: self.handleAFError(error: aFError))
                }
            }
        }
    }

    ///  Processes the given data response and returns an `APIResponse` containing parsed data
    ///  of type `U`.
    /// - Parameter dataResponse: The Alamofire `DataResponse` containing the data and
    /// any error encountered during the request.
    /// - Returns: `Data`.
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
    ) throws -> Error {
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

    /// Handles Alamofire errors and converts them to a more generic Error type.
    /// - Parameter error: The Alamofire error to be handled.
    /// - Returns: A more generic Error type representing the converted error.
    open func handleAFError(error: AFError) -> Error {
        if let underlyingError = error.underlyingError {
            let nserror = underlyingError as NSError
            let code = nserror.code
            if code == NSURLErrorNotConnectedToInternet ||
                code == NSURLErrorTimedOut ||
                code == NSURLErrorInternationalRoamingOff ||
                code == NSURLErrorDataNotAllowed ||
                code == NSURLErrorCannotFindHost ||
                code == NSURLErrorCannotConnectToHost ||
                code == NSURLErrorNetworkConnectionLost
            {
                var userInfo = nserror.userInfo
                userInfo[NSLocalizedDescriptionKey] = "Unable to connect to the server"
                let currentError = NSError(
                    domain: nserror.domain,
                    code: code,
                    userInfo: userInfo
                )
                return currentError
            }
        }
        return error
    }
}
