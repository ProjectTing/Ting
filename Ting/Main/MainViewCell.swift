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
    // MARK: StackView1 (제목, 내용)
    private let cardView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 6
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
    private lazy var stackView1 = UIStackView(arrangedSubviews: [titleLabel, detailLabel]).then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    // MARK: StackView2 (날짜, 태그)
    private let dateLabel = UILabel().then {
        $0.text = "2025.01.01"
        $0.textColor = .grayCloud
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.textAlignment = .left
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
    private lazy var stackView2 = UIStackView(arrangedSubviews: [dateLabel, tag1, tag2, tag3]).then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fillProportionally
    }
    
    // MARK: StackView 두개 감싼 총 스택뷰
    private lazy var motherStackView = UIStackView(arrangedSubviews: [stackView1, stackView2]).then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillProportionally
    }
    
    // 초기화 메서드 (셀 생성 시 호출됨)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI 구성 메서드
    private func setupCell() {
        contentView.addSubview(cardView)
        cardView.addSubview(motherStackView)
        
        // cardView의 제약 설정
        cardView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
            $0.width.equalTo(180)
            $0.height.equalTo(380)
        }
        
        // motherStackView의 제약 설정
        motherStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)  // cardView 내에서 여백을 두고 배치
        }
        [tag1, tag2, tag3].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(25)
            }
        }
        
        // UI 컴포넌트들 제약 설정
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview() // 좌우 10포인트 여백
        }
        
        detailLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview() // 좌우 10포인트 여백
        }
        
        stackView2.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10) // 좌우 10포인트 여백
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

