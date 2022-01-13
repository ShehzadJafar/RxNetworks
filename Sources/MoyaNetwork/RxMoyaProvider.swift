//
//  RxMoyaProvider.swift
//  RxNetworks
//
//  Created by Condy on 2021/10/5.
//

///`Moya/RxSwift`文档
/// https://github.com/Moya/Moya/tree/master/Sources/RxMoya

@_exported import RxSwift
@_exported import Moya

extension MoyaProvider: ReactiveCompatible { }

public extension Reactive where Base: MoyaProvider<MultiTarget> {
    
    /// Designated request-making method.
    /// - Parameters:
    ///   - api: Request body
    ///   - callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
    /// - Returns: Single sequence JSON object.
    func request(api: NetworkAPI, callbackQueue: DispatchQueue? = nil) -> APISingleJSON {
        APISingleJSON.create { single in
            let token = base.request(.target(api), callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case let .success(response):
                    do {
                        let response = try response.filterSuccessfulStatusCodes()
                        let json = try response.mapJSON()
                        single(.success(json))
                        NetworkDebugging.DebuggingResponse(json, false, true)
                    } catch MoyaError.jsonMapping(let response) {
                        let error = MoyaError.jsonMapping(response)
                        NetworkDebugging.DebuggingResponse(error.localizedDescription, false, false)
                        single(.failure(error))
                    } catch MoyaError.statusCode(let response) {
                        let error = MoyaError.statusCode(response)
                        NetworkDebugging.DebuggingResponse(error.localizedDescription, false, false)
                        single(.failure(error))
                    } catch {
                        NetworkDebugging.DebuggingResponse(error.localizedDescription, false, false)
                        single(.failure(error))
                    }
                case let .failure(error):
                    NetworkDebugging.DebuggingResponse(error.localizedDescription, false, false)
                    single(.failure(error))
                }
            }
            return Disposables.create {
                token.cancel()
            }
        }
    }
}
