//
//  UIView.swift
//  Geographic atlas
//
//  Created by Bekbol Bolatov on 13.05.2023.
//

import UIKit
import Kingfisher

extension UIView {
    func pin(to superView: UIView) {
        snp.makeConstraints {
            $0.edges.equalTo(superView)
        }
    }
    
    func addSubviews(_ views: UIView...) {
        addSubviews(views)
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
}

func configure<T>(_ value: T, using closure: (inout T) throws -> Void) rethrows -> T {
    var value = value
    try closure(&value)
    return value
}

enum Paddings {
    static let horizontal = 17.0
    static let top = 20.0
}

struct OrderedDictionary<Key: Hashable, Value> {
    private var keys: [Key] = []
    private var values: [Key: Value] = [:]
    
    var count: Int {
        return keys.count
    }
    
    subscript(key: Key) -> Value? {
        get {
            return values[key]
        }
        set {
            if let index = keys.firstIndex(of: key) {
                if let newValue = newValue {
                    values[key] = newValue
                } else {
                    keys.remove(at: index)
                    values[key] = nil
                }
            } else if let newValue = newValue {
                keys.append(key)
                values[key] = newValue
            }
        }
    }
    
    subscript(index: Int) -> (key: Key, value: Value) {
        let key = keys[index]
        let value = values[key]!
        return (key, value)
    }
    
    
    mutating func set(_ key: Key, with value: Value) {
        guard keys.contains(key) else {
            keys.append(key)
            values[key] = value
            return
        }
        values[key] = value
    }
    
    func getValue(of key: Key) -> Value? {
        guard keys.contains(key) else {
            return nil
        }
        return values[key]
    }
    
    func forEach(_ body: (Key, Value) -> Void) {
        for key in keys {
            if let value = values[key] {
                body(key, value)
            }
        }
    }
    
    func filter(_ isIncluded: (Key, Value) throws -> Bool) rethrows -> OrderedDictionary<Key, Value> {
        var result = OrderedDictionary<Key, Value>()
        for (key, value) in values where try isIncluded(key, value) {
            result[key] = value
        }
        return result
    }
}

extension Int {
    func formattedWithSeparator() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension UIImageView {
    func setImage(url: String) {
        print("url", url)
        guard let url = URL(string: url) else {
            return
        }
        kf.setImage(with: url)
    }
}

