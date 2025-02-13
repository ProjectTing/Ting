//
//  BaseUploadView.swift
//  Ting
//
//  Created by Watson22_YJ on 1/29/25.
//

import UIKit
import SnapKit
import Then

/// 게시글 작성 기본 뷰
class BaseUploadView: UIView {
    
    // MARK: - 공용 컴포넌트
    
    let scrollView = UIScrollView().then {
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = true
        $0.keyboardDismissMode = .interactive
    }
    
    let contentView = UIView()
    
    let postTypeLabel = UILabel().then {
        $0.textColor = .brownText
        $0.font = .systemFont(ofSize: 30, weight: .bold)
        $0.textAlignment = .center
    }
    
    lazy var submitButton = UIButton(type: .system).then {
        $0.setTitle("작성하기", for: .normal)
        $0.titleLabel?.font = .boldSystemFont(ofSize: 18)
        $0.backgroundColor = .primaries
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
    }
    
    lazy var titleSection = LabelAndTextField(
        title: "제목",
        placeholder: " 제목을 입력해주세요"
    )
    
    let detailLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.text = "내용"
        $0.textColor = .deepCocoa
    }
    
    lazy var detailTextView = UITextView().then {
        $0.font = .systemFont(ofSize: 18)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayCloud.cgColor
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.keyboardType = .default
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 키보드 내리기
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.endEditing(true)
    }
    
    // MARK: - 오토레이아웃 설정
    
    private func setupUI() {
        self.backgroundColor = .background
        
        addSubviews(scrollView, submitButton)
        scrollView.addSubview(contentView)
        
        submitButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(40)
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
    }
}
