//
//  UIView.swift
//  Geographic atlas
//
//  Created by Bekbol Bolatov on 13.05.2023.
//

import UIKit

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
    static let horizontal = 20.0
    static let top = 22.0
}
