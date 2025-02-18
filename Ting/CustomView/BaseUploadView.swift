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
        placeholder: "제목을 입력해주세요"
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
        detailTextView.delegate = self
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
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(submitButton)
        
        submitButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(40)
            $0.height.equalTo(50)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
    }
}

extension BaseUploadView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let currentText = textView.text else { return true }

        // 새롭게 입력될 텍스트 적용
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // 글자 수 제한 (500자)
        if newText.count > 500 {
            return false
        }

        // 줄바꿈 개수 제한 (30줄)
        let lines = newText.components(separatedBy: .newlines)
        if lines.count > 30 {
            return false
        }

        // 마지막 줄의 글자수 제한 (30자) 마지막 줄에서 의도적으로 길게 적는 것 방지
        if let lastLine = lines.last, lastLine.count > 30 {
            return false
        }

        return true
    }
    
}
