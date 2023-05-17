//
//  GADetailedInfoView.swift
//  Geographic atlas
//
//  Created by Bekbol Bolatov on 16.05.2023.
//

import UIKit

class GADetailedInfoView: UIView {

    private let content: Content
    private let keyLabel = configure(UILabel()) {
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .secondaryLabel
    }
    private let valueLabel = configure(UILabel()) {
        $0.font = .systemFont(ofSize: 20)
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
        keyLabel.text = content.key
        valueLabel.text = content.value

        let stackView: UIStackView = .init(
            arrangedSubviews: [
                keyLabel,
                valueLabel
            ]
        )
        
        addSubview(stackView)
        stackView.pin(to: self)
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.alignment = .leading
    }

}

extension GADetailedInfoView {
    struct Content {
        var key: String
        var value: String
    }
}
