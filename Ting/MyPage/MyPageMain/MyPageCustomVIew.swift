//
//  MyPageCustomVIew.swift
//  Ting
//
//  Created by 이재건 on 1/26/25.
//

import UIKit
import SnapKit
import Then

class MyPageCustomView: UIView {
    
    // MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textAlignment = .left
    }
    var detailLabel = UILabel().then {
        $0.textColor = .deepCocoa
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }
    
    
    // MARK: - 초기화
    init(title: String, detail: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        detailLabel.text = detail
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setUpUI
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel]).then {
            $0.axis = .vertical
            $0.spacing = 3
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        detailLabel.snp.makeConstraints {
            $0.height.equalTo(36)
        }
    }
    
    // MARK: - 크기 지정
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30)
    }
}
