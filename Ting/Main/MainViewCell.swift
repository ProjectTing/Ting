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
    
    private let tag1 = UIButton().then {
        $0.setTitle("태그1", for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .primary
        $0.setTitleColor(.white, for: .normal)
    }
    private let tag2 = UIButton().then {
        $0.setTitle("태그2", for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .primary
        $0.setTitleColor(.white, for: .normal)
    }
    private let tag3 = UIButton().then {
        $0.setTitle("태그3", for: .normal)
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .primary
        $0.setTitleColor(.white, for: .normal)
    }
    private lazy var tagStackView = UIStackView(arrangedSubviews: [tag1, tag2, tag3]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillProportionally
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "제목"
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .brownText
    }
    private let detailLabel = UILabel().then {
        $0.text = "내용"
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.textColor = .deepCocoa
    }
    

    private let dateLabel = UILabel().then {
        $0.text = "2025.01.01"
        $0.textColor = .grayCloud
        $0.font = UIFont.systemFont(ofSize: 20)
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
            $0.edges.equalToSuperview().inset(10)
  
        }
        
        // MARK: tags
        cardView.addSubview(tagStackView)
        tagStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
        tag1.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(25)
        }
        tag2.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(25)
        }
        tag3.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(25)
        }
        
        // MARK: 제목, 본문 내용
        cardView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(tagStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }
        cardView.addSubview(detailLabel)
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        // MARK: 날짜
        cardView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(detailLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(cardView.snp.bottom).inset(10)
        }

    }
    
    // 데이터 설정 메서드
    func configure(with title: String, detail: String, date: String, tags: [String]) {
        titleLabel.text = title
        detailLabel.text = detail
        dateLabel.text = date
        
        // 태그 버튼 업데이트
        let buttons = [tag1, tag2, tag3]
        for (index, tag) in tags.prefix(3).enumerated() {
            buttons[index].setTitle(tag, for: .normal)
        }
    }
}
