//
//  CountryDetailsViewController.swift
//  Geographic atlas
//
//  Created by Bekbol Bolatov on 15.05.2023.
//

import UIKit

class CountryDetailsViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    let flagImageView = configure(UIImageView()) { imageView in
        imageView.layer.cornerRadius = 12.0
    }
    
    let detailsStackView = configure(UIStackView()) { stackView in
        stackView.axis = .vertical
        stackView.spacing = 18
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // Key title 15 font
        // Value title 20 font
        
        // 18 points between
    }
    
    private func setupView() {
        title = "Kazakhstan"
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        let width = (view.frame.width) - (Paddings.horizontal * 2)
        let heightRatio: CGFloat = 0.563
        
        let height = heightRatio * width
        
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Paddings.top)
            $0.left.right.equalToSuperview().inset(Paddings.horizontal)
            $0.bottom.equalToSuperview()
        }
        
        scrollView.addSubviews(flagImageView, detailsStackView)
        
        flagImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(6)
            $0.width.equalToSuperview()
            $0.height.equalTo(height)
        }
        
        configureDetailes()
        
        detailsStackView.snp.makeConstraints {
            $0.top.equalTo(flagImageView.snp.bottom).offset(18)
            $0.left.right.bottom.equalToSuperview()
        }
        
        flagImageView.backgroundColor = .systemMint
        
    }
    
    private func configureDetailes() {
        var details = OrderedDictionary<String, String>()
        details.set("Region:", with: "Asia")
        details.set("Capital:", with: "Astana")
        details.set("Capital coordinates:", with: "51°08, 71º26'")
        details.set("Population:", with: "19 mln")
        details.set("Area:", with: "2 724 900 km²")
        details.set("Currency:", with: "Tenge (₸) (KZT)")
        details.set("Timezones:", with: "GMT+6")
//            [
//                "Region:": "Asia",
//                "Capital:": "Astana",
//                "Capital coordinates:": "51°08, 71º26'",
//                "Population:": "19 mln",
//                "Area:": "2 724 900 km²",
//                "Currency:": "Tenge (₸) (KZT)",
//                "Timezones:": "GMT+6"
//            ]
        
        details.forEach { key, value in
            let infoView = GADetailedInfoView(content: .init(key: key, value: value))
            detailsStackView.addArrangedSubview(infoView)
        }
    }
}
