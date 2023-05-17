//
//  GADetailedInfoView.swift
//  Geographic atlas
//
//  Created by Bekbol Bolatov on 16.05.2023.
//

import UIKit

class GADetailedInfoView: UIView {

    var content: Content
    private let keyLabel = configure(UILabel()) {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .secondaryLabel
    }
    private let valueLabel = configure(UILabel()) {
        $0.font = .systemFont(ofSize: 20)
        $0.textColor = .label
        $0.numberOfLines = 0
    }
    private let bulletPoint = configure(UILabel()) {
        $0.font = .systemFont(ofSize: 45)
        $0.text = "\u{2022}"
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
        keyLabel.text = content.key
        valueLabel.text = content.value

        let stackView: UIStackView = .init(
            arrangedSubviews: [
                keyLabel,
                valueLabel
            ]
        )
        
        let parentStackView: UIStackView = .init(
            arrangedSubviews: [
                bulletPoint,
                stackView
            ]
        )
        
        addSubview(parentStackView)
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .leading
        
        parentStackView.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
        }
        parentStackView.axis = .horizontal
        parentStackView.spacing = 10
        parentStackView.alignment = .top
        
        bulletPoint.snp.makeConstraints {
            $0.centerY.equalTo(keyLabel).inset(5)
        }
        
        keyLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
    }
    func updateContent() {
        keyLabel.text = content.key
        valueLabel.text = content.value
    }
}

extension GADetailedInfoView {
    struct Content {
        var key: String
        var value: String
    }
}
