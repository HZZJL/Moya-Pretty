//
//  MoyaProvider+RxSwift.swift
//  ObiMoyaExtension
//
//  Created by Kao Ming-Hsiu on 2018/7/6.
//

import Foundation
import Moya
import RxSwift

public extension Reactive where Base: MoyaProviderType, Base.Target: DecodableMixin {
  /// Designated request-making method.
  ///
  /// - Parameters:
  ///   - token: Entity, which provides specifications necessary for a `MoyaProvider`.
  ///   - callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
  /// - Returns: Single decodable object.
  public func requestModel(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Base.Target.DecodableModel> {
    return Single<Base.Target.DecodableModel>.create { [weak base] single in
      let cancellableToken = (base as? MoyaProvider<Base.Target>)?.requestModel(token, callbackQueue: callbackQueue, progress: nil, completion: { result in
        switch result {
        case .success(let model):
          single(.success(model))
        case .failure(let error):
          single(.error(error))
        }
      })
      return Disposables.create {
        cancellableToken?.cancel()
      }
    }
  }
}

#if canImport(ObjectMapper)
public extension Reactive where Base: MoyaProviderType, Base.Target: MappableResponseType {
  /// Designated request-making method.
  ///
  /// - Parameters:
  ///   - token: Entity, which provides specifications necessary for a `MoyaProvider`.
  ///   - callbackQueue: Callback queue. If nil - queue from provider initializer will be used.
  /// - Returns: Single mappable object.
  public func requestModel(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Base.Target.MappableResponseModel> {
    return Single<Base.Target.MappableResponseModel>.create { [weak base] single in
      let cancellableToken = (base as? MoyaProvider<Base.Target>)?.requestModel(token, callbackQueue: callbackQueue, progress: nil, completion: { result in
        switch result {
        case .success(let model):
          single(.success(model))
        case .failure(let error):
          single(.error(error))
        }
      })
      return Disposables.create {
        cancellableToken?.cancel()
      }
    }
  }
}
#endif
