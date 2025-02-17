//
//  EditInfoCustomVIew.swift
//  Ting
//
//  Created by 이재건 on 1/26/25.
//

import UIKit
import SnapKit
import Then

class EditCustomView: UIView {
    
    // MARK: - Properties
    private let isFirstField: Bool
    private let isLastField: Bool
    
    // MARK: - UI Components
    private let label = UILabel().then {
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }
    public let textField = UITextField().then {
        $0.backgroundColor = .white
        $0.textColor = .brownText
        $0.borderStyle = .none // 기본 테두리를 제거
        $0.layer.borderWidth = 1.0 // 테두리 두께 설정
        $0.layer.borderColor = UIColor.primaries.cgColor // 테두리 색상 설정
        $0.layer.cornerRadius = 8 // 둥근 모서리 설정 (선택 사항)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 0.0)) // 텍스트필드 값 왼쪽 여백
        $0.leftViewMode = .always
        
        // MARK: 키보드 설정
        $0.keyboardType = .default
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .next
    }
    
    // MARK: - 초기화
    init(labelText: String, placeholder: String, isFirstField: Bool = false, isLastField: Bool = false) {
        self.isFirstField = isFirstField
        self.isLastField = isLastField
        super.init(frame: .zero)
        label.text = labelText
        textField.placeholder = placeholder
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.grayCloud // Placeholder 색상 변경
            ]
        )
        if isFirstField == true {
            textField.returnKeyType = .next
        } else if isFirstField == false && isLastField == false {
            textField.returnKeyType = .next
        } else if isLastField == true {
            textField.returnKeyType = .done
        }
        
        setupView()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - didMoveToWindow 첫 번째 필드 자동 포커스
        override func didMoveToWindow() {
            super.didMoveToWindow()
            
            if isFirstField {
                DispatchQueue.main.async {
                    self.textField.becomeFirstResponder()
                }
            }
        }
    
    // MARK: - setUpUI
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [label, textField]).then {
            $0.axis = .vertical
            $0.spacing = 3
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(5)
        }
        label.snp.makeConstraints {
            $0.height.equalTo(24)
        }
        textField.snp.makeConstraints {
            $0.height.equalTo(36)
        }
    }
    
    // MARK: - 크기 지정
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 30) // stackView간의 기본 높이 설정
    }
}

//// MARK: - UITextFieldDelegate
//extension EditCustomView: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if isLastField {
//            textField.resignFirstResponder() // 마지막 필드이면 키보드 내리기
//        }
//        return true
//    }
//}
