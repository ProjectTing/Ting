//
//  PostMainView.swift
//  Ting
//
//  Created by t2023-m0033 on 1/26/25.
//

import UIKit
import SnapKit

final class PostMainView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        /// TODO - 메인뷰 셀 조정에 따라 변경해야함
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 180)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: MainViewCell.identifier)
        collectionView.backgroundColor = .background
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
    
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
