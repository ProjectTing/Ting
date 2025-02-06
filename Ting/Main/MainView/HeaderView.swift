//
//  Header.swift
//  Ting
//
//  Created by 이재건  on 2/6/25.
//

import UIKit
import SnapKit

// MARK: - 메인 컬렉션뷰 Header
class HeaderView: UICollectionReusableView {
    static let identifier = "HeaderView"
    
    let titleLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
        $0.textColor = .brownText
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
