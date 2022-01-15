//
//  NetworkX.swift
//  RxNetworks
//
//  Created by Condy on 2021/10/6.
//

import Foundation

public func toJSON(form value: Any, prettyPrint: Bool = false) -> String? {
    guard JSONSerialization.isValidJSONObject(value) else {
        return nil
    }
    var jsonData: Data? = nil
    if prettyPrint {
        jsonData = try? JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted])
    } else {
        jsonData = try? JSONSerialization.data(withJSONObject: value, options: [])
    }
    guard let data = jsonData else { return nil }
    return String(data: data ,encoding: .utf8)
}

public func toDictionary(form json: String) -> [String : Any]? {
    guard let jsonData = json.data(using: .utf8),
          let object = try? JSONSerialization.jsonObject(with: jsonData, options: []),
          let result = object as? [String : Any] else {
              return nil
          }
    return result
}

/// 字典拼接 `+=
/// Example
///
///     var dict1 = ["key": "1"]
///     let dict2 = ["key": "cdy", "Condy": "ykj310@126.com"]
///
///     dict1 += dict2
///
///     print("\(dict1)")
///     // Prints "["key": "cdy", "Condy": "ykj310@126.com"]"
///
public func += <K,V> (left: inout Dictionary<K,V>, right: Dictionary<K,V>?) {
    guard let right = right else { return }
    right.forEach { key, value in
        left.updateValue(value, forKey: key)
    }
}
