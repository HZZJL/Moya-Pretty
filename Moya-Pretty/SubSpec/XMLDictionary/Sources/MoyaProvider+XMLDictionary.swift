//
//  MoyaProvider+XMLDictionary.swift
//  Moya-Pretty
//
//  Created by Kao Ming-Hsiu on 2018/7/6.
//

import Foundation
import Moya
import ObjectMapper
import XMLDictionary
import Result

enum XMLDictionaryError: Error {
  case xmlMapping(Response)
}

public protocol XMLTargetType: TargetType {}

extension TargetType where Self: MappableBodyType, Self: XMLTargetType {
  public var task: Task {
    return Task.requestParameters(parameters: body.toJSON(), encoding: XMLEncoding.default)
  }  
}

extension MoyaProvider where MoyaProvider.Target: MappableResponseType {
  open func requestXmlModel(_ target: Target, option: MapperOption? = nil, callbackQueue: DispatchQueue? = .none, progress: ProgressBlock? = .none, completion: @escaping ((_ result: Result<Target.MappableResponseModel, MoyaError>) -> Void)) -> Cancellable {
    return self.request(target, callbackQueue: callbackQueue, progress: progress, completion: { (result) in
      let modelResult = result.flatMap({ (response) -> Result<Target.MappableResponseModel, MoyaError> in
        do {
          let option = option ?? target.mapperOption
          let mapper = Mapper<Target.MappableResponseModel>(context: option.context, shouldIncludeNilValues: option.shouldIncludeNilValues)
          guard
            let dictionary = NSDictionary(xmlData: response.data) as? [String: Any],
            let mappable = mapper.map(JSON: dictionary)
            else {throw XMLDictionaryError.xmlMapping(response)}
          return Result.success(mappable)
        } catch let moyaError as MoyaError {
          return Result.failure(moyaError)
        } catch {
          return Result.failure(MoyaError.underlying(error, response))
        }
      })
      completion(modelResult)
    })
  }
}
