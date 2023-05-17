//
//  GAAdditionalInfoView.swift
//  Geographic atlas
//
//  Created by Bekbol Bolatov on 13.05.2023.
//

import UIKit

class GAAdditionalInfoView: UIView {
    var content: Content
    private let keyLabel = configure(UILabel()) {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .gray
    }
    private let valueLabel = configure(UILabel()) {
        $0.font = .systemFont(ofSize: 15)
        $0.numberOfLines = 0
    }
    init(content: Content) {
        self.content = content
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        updateContent()
        addSubviews(keyLabel, valueLabel)
        
        keyLabel.snp.makeConstraints {
            $0.left.top.equalToSuperview()
        }
        valueLabel.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.left.equalTo(keyLabel.snp.right).offset(6)
        }
    }
    func updateContent() {
        keyLabel.text = content.key
        valueLabel.text = content.value
    }
}

extension GAAdditionalInfoView {
    struct Content {
        var key: String
        var value: String
    }
}
