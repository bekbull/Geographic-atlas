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
        imageView.clipsToBounds = true
    }
    
    let detailsStackView = configure(UIStackView()) { stackView in
        stackView.axis = .vertical
        stackView.spacing = 18
    }
    var cca2: String
    private let viewModel: CountryDetailsViewModel
    private var detailedInfoViews: [GADetailedInfoView] = []
    private var details = OrderedDictionary<String, String>()
    
    init(viewModel: CountryDetailsViewModel, cca2: String) {
        self.viewModel = viewModel
        self.cca2 = cca2
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        fetchCountryData()
        setupView()
    }
    
    private func bind() {
        viewModel.onFetchCoutryDataChange = { [weak self] in
            self?.setupDetails()
        }
    }
    
    private func setupView() {
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
        
        flagImageView.backgroundColor = .gray
        
    }
    
    private func setupDetails() {
        flagImageView.setImage(url: viewModel.country?.flags.png ?? "")
        details.set("Region:", with: viewModel.country?.continents?.first ?? "")
        details.set("Capital:", with: viewModel.country?.formattedCapitalCitites() ?? "")
        details.set("Capital coordinates:", with: viewModel.country?.formattedCoordinates() ?? "")
        details.set("Population:", with: viewModel.country?.formattedPopulation() ?? "")
        details.set("Area:", with: viewModel.country?.formattedArea() ?? "")
        details.set("Currency:", with: viewModel.country?.formattedCurrencies() ?? "")
        details.set("Timezones:", with: viewModel.country?.formattedTimeZone() ?? "")
        
        detailedInfoViews.forEach {
            guard let value = details.getValue(of: $0.content.key) else { return }
            $0.content.value = value
            $0.updateContent()
        }
    }
    
    private func configureDetailes() {
        
        details.set("Region:", with: "")
        details.set("Capital:", with: "")
        details.set("Capital coordinates:", with: "")
        details.set("Population:", with: "")
        details.set("Area:", with: "")
        details.set("Currency:", with: "")
        details.set("Timezones:", with: "")
        
        details.forEach { key, value in
            let infoView = GADetailedInfoView(content: .init(key: key, value: value))
            detailedInfoViews.append(infoView)
            detailsStackView.addArrangedSubview(infoView)
        }
    }
}
private extension CountryDetailsViewController {
    func fetchCountryData() {
        viewModel.fetchCoutryDetail(cca2: cca2)
    }
}
