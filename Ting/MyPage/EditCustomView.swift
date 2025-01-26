//
//  EditInfoCustomVIew.swift
//  Ting
//
//  Created by 이재건 on 1/26/25.
//

import UIKit
import SnapKit
import Then

//class EditCustomView: UIView {
//    
//    // MARK: - UI Components
//    private let label = UILabel().then {
//        $0.textColor = .brownText
//        $0.font = .boldSystemFont(ofSize: 15)
//        $0.textAlignment = .left
//    }
//    private let textField = UITextField().then {
//        $0.borderStyle = .roundedRect
//        $0.backgroundColor = .black
//        $0.textColor = .brownText
//    }
//    
//    //MARK: - 초기화
//    init(labelText: String, placeholder: String) {
//        super.init(frame: .zero) // 뷰 크기 기본 값(0,0,0,0)
//        label.text = labelText
//        textField.placeholder = placeholder
//        setupView()
//    }
//    
//    // MARK: -
//    // Xcode의 Interface Builder(스토리보드, XIB)에서 사용하려면 필수로 구현해야 하는 생성자
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented") // 스토리보드에서 이니셜라이저를 호출하면 크래시 되도록 설정
//    }
//    
//    // MARK: - setUpUI
//    private func setupView() {
//        let stackView = UIStackView(arrangedSubviews: [label, textField]).then {
//            $0.axis = .vertical
//            $0.spacing = 4
//        }
//        
//        addSubview(stackView)
//        stackView.snp.makeConstraints {
//            $0.edges.equalToSuperview().inset(10)
//        }
//        label.snp.makeConstraints {
//            $0.height.equalTo(24)
//        }
//        textField.snp.makeConstraints {
//            $0.height.equalTo(40)
//        }
//    }
//    
//    // MARK: - 크기 지정 (중요!)
//    override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIView.noIntrinsicMetric, height: 60) // 기본 높이 설정
//    }
//}

class EditCustomView: UIView {
    
    // MARK: - UI Components
    private let label = UILabel().then {
        $0.textColor = .brownText
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .left
    }
    private let textField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .black
        $0.textColor = .brownText
    }
    
    // MARK: - 초기화
    init(labelText: String, placeholder: String) {
        super.init(frame: .zero)
        label.text = labelText
        textField.placeholder = placeholder
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setUpUI
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [label, textField]).then {
            $0.axis = .vertical
            $0.spacing = 3
        }
        
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
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
        return CGSize(width: UIView.noIntrinsicMetric, height: 70) // 기본 높이를 70으로 줄이기
    }
}


