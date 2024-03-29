//
//  GATableViewCell.swift
//  Geographic atlas
//
//  Created by Bekbol Bolatov on 13.05.2023.
//

import SnapKit
import UIKit

class GATableViewCell: UITableViewCell {
    
    let cellBackgroundView = configure(UIView()) {
        $0.backgroundColor = GAColors.cellBackgroundColor
        $0.layer.cornerRadius = 12.0
    }
    
    let flagImageView = configure(UIImageView()) { imageView in
        imageView.layer.cornerRadius = 6.0
        imageView.clipsToBounds = true
    }
    let countryNameLabel = configure(UILabel()) { label in
        label.font = .systemFont(ofSize: 17.0, weight: .semibold)
    }
    let countryCapitalCityLabel = configure(UILabel()) { label in
        label.font = .systemFont(ofSize: 13.0)
        label.textColor = .gray
    }
    lazy var expandButton = configure(UIButton()) {
        $0.setImage(GAImages.expand, for: .normal)
        $0.addTarget(self, action: #selector(expandButtonClicked), for: .touchUpInside)
    }
    let learnMoreButton = configure(UIButton()) {
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17.0, weight: .semibold)
        $0.setTitle("Learn more", for: .normal)
        $0.addTarget(self, action: #selector(learnMoreButtonClicked), for: .touchUpInside)
    }
    let cardView: UIView = .init()
    let additionalInfoView: UIView = .init()
    var isExpanded: Bool = false
    
    private let containerStackView = UIStackView()
    
    private let populationInfoView = GAAdditionalInfoView(
        content: .init(
            key: "Population",
            value: ""
        )
    )
    private let areaInfoView = GAAdditionalInfoView(
        content: .init(
            key: "Area",
            value: ""
        )
    )
    private let currenciesInfoView = GAAdditionalInfoView(
        content: .init(
            key: "Currencies",
            value: ""
        )
    )
    
//    var population: String = "19 mln"
//    var area: String = "2.725 mln km²"
//    var currencies: String = "Tenge (₸) (KZT)\nTenge (₸) (KZT)"
    var onExpandButtonClicked: (() -> ())?
    private var country: Country?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        isExpanded = false
        additionalInfoView.isHidden = true
        flagImageView.image = nil
        countryNameLabel.text = nil
        countryCapitalCityLabel.text = nil
        [populationInfoView, areaInfoView, currenciesInfoView].forEach {
            $0.content.value = ""
            $0.updateContent()
        }
        country = nil
    }
    
    private func setupView() {
        contentView.addSubview(cellBackgroundView)
        additionalInfoView.isHidden = true
        additionalInfoView.alpha = 0
        cellBackgroundView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        cellBackgroundView.addSubviews(
            containerStackView
        )
        
        containerStackView.addArrangedSubview(cardView)
        containerStackView.addArrangedSubview(additionalInfoView)
        containerStackView.axis = .vertical
        containerStackView.spacing = 0
        containerStackView.pin(to: cellBackgroundView)
        
        configureCardView()
        configureAdditionalInfoView()
    }
    
    func configureView(with country: Country) {
        self.country = country
        additionalInfoView.isHidden = !isExpanded
        expandButton.imageView?.transform = !isExpanded ? CGAffineTransform(rotationAngle: 0) : CGAffineTransform(rotationAngle: -3.14)
        additionalInfoView.alpha = isExpanded ? 1 : 0
        
        countryNameLabel.text = country.name?.common ?? ""
        countryCapitalCityLabel.text = country.formattedCapitalCitites()
        
        flagImageView.setImage(url: country.flags.png ?? "")
        
        populationInfoView.content.value = country.formattedPopulation()
        areaInfoView.content.value = country.formattedArea()
        currenciesInfoView.content.value = country.formattedCurrencies()
        
        populationInfoView.updateContent()
        areaInfoView.updateContent()
        currenciesInfoView.updateContent()
    }
    
    @objc func expandButtonClicked() {
        isExpanded = !isExpanded
        additionalInfoView.isHidden = !additionalInfoView.isHidden
        UIView.animate(withDuration: 0.3) { [unowned self] in
            additionalInfoView.alpha = additionalInfoView.isHidden ? 0 : 1
            expandButton.imageView?.transform = additionalInfoView.isHidden ? CGAffineTransform(rotationAngle: 0) : CGAffineTransform(rotationAngle: -3.14)
        }
        
        onExpandButtonClicked?()
    }
    @objc func learnMoreButtonClicked() {
        NavigationManager.shared.showDetailedInfoViewController(cca2: country?.cca2 ?? "", title: country?.name?.common ?? "")
    }
    
    private func configureCardView() {
        let countryStackView: UIStackView = .init(
            arrangedSubviews: [
                countryNameLabel,
                countryCapitalCityLabel
            ]
        )
        countryStackView.axis = .vertical
        countryStackView.spacing = 5
        cardView.addSubviews(
            flagImageView,
            countryStackView,
            expandButton
        )
        
        flagImageView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(6)
            $0.width.equalTo(100)
            $0.height.equalTo(63)
        }
        flagImageView.backgroundColor = .gray
        
        expandButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(6)
            $0.centerY.equalTo(flagImageView.snp.centerY)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
        
        countryStackView.snp.makeConstraints {
            $0.left.equalTo(flagImageView.snp.right).offset(6)
            $0.right.equalTo(expandButton.snp.left).offset(-6)
            $0.centerY.equalTo(flagImageView.snp.centerY)
        }
    }
    
    private func configureAdditionalInfoView() {
        let additionalInfoStackView: UIStackView = .init(
            arrangedSubviews: [
                populationInfoView,
                areaInfoView,
                currenciesInfoView
            ]
        )
        additionalInfoStackView.axis = .vertical
        additionalInfoStackView.spacing = 5
        additionalInfoView.addSubviews(
            additionalInfoStackView,
            learnMoreButton
        )
        learnMoreButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
            $0.width.equalTo(200)
            $0.height.equalTo(45)
        }
        
        additionalInfoStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(6)
            $0.bottom.equalTo(learnMoreButton.snp.top).offset(-6)
        }
    }
}
