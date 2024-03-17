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
    open var logOptions: [APILogOptionBase] {
        APILogOptionBase.default
    }

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
        if logOptions.contains(.request) {
            print(input.requestDescription)
        }

        do {
            let data = try await requestData(input)
            let result: T = try decodeResponse(data, keyDecodingStrategy: input.keyStrategyForDecodeResponse)
            return result
        } catch {
            if logOptions.contains(.error) {
                print("❌ [REQUEST FAIL]: \(error)")
            }
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
            .responseData { [unowned self] data in
                processResponseData(continuation: continuation, data)
            }
        }
    }

    /// Processes the response data from an Alamofire data response.
    /// - Parameters:
    ///   - continuation: A checked continuation that will be used to resume the asynchronous computation.
    ///   - dataResponse: The Alamofire data response containing the result data or error.
    open func processResponseData(
        continuation: CheckedContinuation<Data, Error>,
        _ dataResponse: DataResponse<Data, AFError>
    ) {
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

                if logOptions.contains(.responseStatus) {
                    print("👍 [\(statusCode)] \(urlRequest)")
                }

                if logOptions.contains(.responseJSON) {
                    print("[RESPONSE JSON]: \(responseJSON ?? "Empty")")
                }

                continuation.resume(returning: data)
            default:
                let error = handleResponseError(dataResponse: dataResponse, data: data)

                if logOptions.contains(.responseStatus) {
                    print("❌ [\(statusCode)] \(urlRequest)")
                }

                if logOptions.contains(.error) {
                    print("[RESPONSE ERROR]: \(error)")
                }

                continuation.resume(throwing: error)
            }
        case let .failure(aFError):
            continuation.resume(throwing: handleAFError(error: aFError))
        }
    }

    // MARK: - Decode response.

    /// Decodes the provided data into a generic type `T` conforming to `Codable`.
    /// - Parameter data: The `Data` to be decoded.
    /// - Parameter keyDecodingStrategy: The key decoding strategy to be used during decoding.
    /// - Returns: An instance of type `T` decoded from the provided data and throws an error if decoding fails.
    open func decodeResponse<T: Codable>(
        _ data: Data,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy
    ) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = keyDecodingStrategy
            let items = try decoder.decode(T.self, from: data)

            if logOptions.contains(.responseDecode) {
                print("[RESPONSE DECODE]: \(items)")
            }

            return items
        } catch {
            if logOptions.contains(.error) {
                print("❌ [RESPONSE DECODE FAIL]: \(error)")
            }
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
                code == NSURLErrorNetworkConnectionLost {
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
