//
//  MainCell.swift
//  Ting
//
//  Created by 이재건 on 1/23/25.
//

import UIKit

import SnapKit
import Then

class MainViewCell: UIViewController {
    
    // MARK: - UI Components
    private let cardView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowRadius = 4
            $0.isUserInteractionEnabled = true
        }
        
        private let cardView2 = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 12
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.1
            $0.layer.shadowRadius = 4
            $0.isUserInteractionEnabled = true
        }
        
        private let tagsLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .systemBlue
            $0.numberOfLines = 0
            $0.text = "태그"
        }
        
        private let titleLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 18, weight: .bold)
            $0.numberOfLines = 0
            $0.text = "제목"
        }
        
        private let detailLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 15)
            $0.numberOfLines = 0
            $0.textColor = .darkGray
            $0.text = "내용"
        }
        
        private let nickNameLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .gray
            $0.text = "작성자"
        }
        
        private let dateLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .gray
            $0.text = "날짜"
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            configureUI()
        }
        
    private func configureUI() {
        
        view.addSubview(cardView)
        [tagsLabel, titleLabel, detailLabel, nickNameLabel, dateLabel].forEach {
            cardView.addSubview($0)
        }
        
        cardView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        tagsLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagsLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(tagsLabel)
        }
        
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(titleLabel)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(16)
            $0.top.equalTo(detailLabel.snp.bottom).offset(12)
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(titleLabel)
            $0.centerY.equalTo(nickNameLabel)
        }
    }
}


@available(iOS 17.0, *)
#Preview {
    TestPostVC()
}
