//
//  PostUploadView.swift
//  Ting
//
//  Created by t2023-m0033 on 1/24/25.
//

import UIKit
import SnapKit
import Then

final class PostUploadView: UIView {

    private let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = true
    }

    private let contentView = UIView()
    
    private let postTypeLabel = UILabel().then {
        $0.text = "팀 찾기 글 작성"
        $0.textColor = UIColor(hex: "#9A3412")
        $0.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        $0.textAlignment = .center
    }
    
    private let positionLabel = UILabel().then {
        $0.text = "직무"
        $0.textColor = UIColor(hex: "#9A3412")
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .center
    }
    
    private let positionButtonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
        $0.backgroundColor = .gray // 임시
    }
    
    private let teckstackLabel = UILabel().then {
        $0.text = "기술 스택"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let teckstackTextField = UITextField().then {
        $0.placeholder = "기술 스택을 입력해주세요"
        $0.borderStyle = .roundedRect
    }
    
    private let urgencyLabel = UILabel().then {
        $0.text = "시급성"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let urgencyButtonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
        $0.backgroundColor = .gray // 임시
    }
    
    private let ideaStatusLabel = UILabel().then {
        $0.text = "아이디어 상황"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let ideaStatusButtonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
        $0.backgroundColor = .gray // 임시
    }
    
    private let recruitsLabel = UILabel().then {
        $0.text = "모집 인원"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let recruitsTextField = UITextField().then {
        $0.placeholder = "모집 인원을 입력해주세요"
        $0.borderStyle = .roundedRect
    }

    private let meetingStyleLabel = UILabel().then {
        $0.text = "선호하는 작업 방식"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let meetingStyleButtonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
        $0.backgroundColor = .gray // 임시
    }

    private let experienceLabel = UILabel().then {
        $0.text = "경험"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }

    private let experienceButtonStack = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
        $0.backgroundColor = .gray // 임시
    }

    private let titleLabel = UILabel().then {
        $0.text = "제목"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let titleTextField = UITextField().then {
        $0.placeholder = "제목을 입력해주세요"
        $0.borderStyle = .roundedRect
    }   

    private let detailLabel = UILabel().then {
        $0.text = "내용"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let detailTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 14)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 8
    }
    
    // 작성하기 버튼
    private let submitButton = UIButton().then {
        $0.setTitle("게시글 작성", for: .normal)
        $0.backgroundColor = UIColor(hex: "#9A3412")
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor(hexCode: "FFF7ED")
        [
            scrollView,
            submitButton
        ].forEach { 
            self.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [
            postTypeLabel,
            positionLabel,
            positionButtonStack,
            teckstackLabel,
            teckstackTextField,
            urgencyLabel,
            urgencyButtonStack,
            ideaStatusLabel,
            ideaStatusButtonStack,
            recruitsLabel,
            recruitsTextField,
            detailTextView,
            meetingStyleLabel,
            meetingStyleButtonStack,
            experienceLabel,
            experienceButtonStack,
            titleLabel,
            titleTextField,
            detailLabel,
            detailTextView
        ].forEach {
            contentView.addSubview($0)
        }

        submitButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(submitButton.snp.top).offset(-16)
        }
        
        contentView.snp.makeConstraints { 
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        postTypeLabel.snp.makeConstraints { 
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        positionLabel.snp.makeConstraints { 
            $0.top.equalTo(postTypeLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }

        positionButtonStack.snp.makeConstraints { 
            $0.top.equalTo(positionLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40) // 임시
            $0.width.equalTo(100) // 임시
        }
        
        teckstackLabel.snp.makeConstraints { 
            $0.top.equalTo(positionButtonStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        teckstackTextField.snp.makeConstraints { 
            $0.top.equalTo(teckstackLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        urgencyLabel.snp.makeConstraints { 
            $0.top.equalTo(teckstackTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        urgencyButtonStack.snp.makeConstraints { 
            $0.top.equalTo(urgencyLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40) // 임시
            $0.width.equalTo(100) // 임시
        }
        
        ideaStatusLabel.snp.makeConstraints { 
            $0.top.equalTo(urgencyButtonStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        ideaStatusButtonStack.snp.makeConstraints { 
            $0.top.equalTo(ideaStatusLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40) // 임시
            $0.width.equalTo(100) // 임시
        }
        
        recruitsLabel.snp.makeConstraints { 
            $0.top.equalTo(ideaStatusButtonStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        recruitsTextField.snp.makeConstraints { 
            $0.top.equalTo(recruitsLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        meetingStyleLabel.snp.makeConstraints { 
            $0.top.equalTo(recruitsTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        meetingStyleButtonStack.snp.makeConstraints { 
            $0.top.equalTo(meetingStyleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40) // 임시
            $0.width.equalTo(100) // 임시
        }

        experienceLabel.snp.makeConstraints { 
            $0.top.equalTo(meetingStyleButtonStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }

        experienceButtonStack.snp.makeConstraints {  
            $0.top.equalTo(experienceLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40) // 임시
            $0.width.equalTo(100) // 임시
        }

        titleLabel.snp.makeConstraints { 
            $0.top.equalTo(experienceButtonStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }

        titleTextField.snp.makeConstraints { 
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        detailLabel.snp.makeConstraints { 
            $0.top.equalTo(titleTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }

        detailTextView.snp.makeConstraints { 
            $0.top.equalTo(detailLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(200)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
}
