//
//  MainCell.swift
//  Ting
//
//  Created by 이재건 on 1/23/25.
//

import UIKit
import SnapKit
import Then

class MainViewCell: UICollectionViewCell {
    
    static let identifier = "MainViewCell"
    
    // MARK: - Cell UI Components
    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
    }
    
    private lazy var tagStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillProportionally
    }
    
    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .brownText
    }
    private let detailLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.numberOfLines = 3
        $0.textColor = .deepCocoa
    }
    
    private let nickNameLabel = UILabel().then {
        $0.textColor = .grayText
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textAlignment = .right
    }
    
    private let dateLabel = UILabel().then {
        $0.textColor = .grayText
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textAlignment = .right
    }
    
    
    // 초기화 메서드 (셀 생성 시 호출됨)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Cell Layout 구성
    private func setupCell() {
        
        // MARK: cardView의 제약 설정
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // MARK: tags
        cardView.addSubview(tagStackView)
        tagStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.lessThanOrEqualToSuperview().offset(-10)
            $0.height.equalTo(24)
        }
        
        // MARK: 제목, 본문 내용
        cardView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
        
        cardView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(26)
        }
        
        // MARK: 작성자
        cardView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(6)
        }
        
        // MARK: 날짜
        cardView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(6)
        }
    }
    
    // 데이터 설정 메서드
    func configure(with title: String, detail: String, nickName: String, date: String, tags: [String]) {
        titleLabel.text = title
        detailLabel.text = detail
        nickNameLabel.text = "✍🏻: \(nickName)"
        dateLabel.text = date
        
        // 태그 초기화
        tagStackView.arrangedSubviews.forEach { $0.removeFromSuperview() } // 기존 태그 제거
        
        // 선택한 태그들로 라벨 생성(커스텀), stackView에 추가
        tags.forEach { tag in
            let label = PaddingLabel().then {
                $0.text = tag
                $0.font = .systemFont(ofSize: 16, weight: .bold)
                $0.textColor = .secondaries
                $0.backgroundColor = .background
                $0.layer.cornerRadius = 8
                $0.textAlignment = .center
                $0.clipsToBounds = true
                $0.padding = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
            }
            
            tagStackView.addArrangedSubview(label)
            label.snp.makeConstraints {
                $0.centerY.equalToSuperview()
            }
        }
    }
}
