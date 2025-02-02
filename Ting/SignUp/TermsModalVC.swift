//
//  TermsModalVC.swift
//  Ting
//
//  Created by t2023-m105 on 1/24/25.
//

import UIKit
import SnapKit
import Then

/// 약관 동의 모달 창을 위한 뷰컨트롤러
class TermsModalViewController: UIViewController {
    
    private let termsView = TermsView()  // 약관 뷰
    
    // 약관 항목 데이터
    private var terms: [(String, Bool, Bool)] = [
        ("(필수) 만 14세 이상입니다", true, false),
        ("(필수) 서비스 이용약관", true, false),
        ("(필수) 개인정보 수집 및 이용에 대한 안내", true, false),
        ("(선택) 개인정보 수집 및 이용에 대한 안내", false, false)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)  // 반투명 배경
        view.addSubview(termsView)
        
        termsView.layer.cornerRadius = 20
        termsView.layer.shadowColor = UIColor.black.cgColor
        termsView.layer.shadowOpacity = 0.1
        termsView.layer.shadowOffset = CGSize(width: 0, height: 2)
        termsView.layer.shadowRadius = 8
        termsView.clipsToBounds = true
        
        // 모달 창 위치 및 크기 설정
        termsView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(400)
        }
    }
    
    private func setupTableView() {
        termsView.tableView.delegate = self
        termsView.tableView.dataSource = self
        termsView.tableView.register(TermsCell.self, forCellReuseIdentifier: "TermsCell")
        
        // 테이블 뷰 배경색 설정
        termsView.tableView.backgroundColor = termsView.backgroundColor
    }
    
    private func setupActions() {
        termsView.allAgreeButton.addTarget(self, action: #selector(allAgreeTapped), for: .touchUpInside)
        termsView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    @objc private func allAgreeTapped() {
        let allChecked = terms.allSatisfy { $0.2 }
        terms = terms.map { ($0.0, $0.1, !allChecked) }
        termsView.tableView.reloadData()
    }
    
    @objc private func nextTapped() {
        dismiss(animated: true)  // 모달 닫기
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TermsModalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TermsCell", for: indexPath) as? TermsCell else {
            return UITableViewCell()
        }
        let term = terms[indexPath.row]
        cell.configure(text: term.0, isRequired: term.1, isChecked: term.2)
        
        // 약관 항목의 배경색을 모달 창과 동일하게 설정
        cell.contentView.backgroundColor = termsView.backgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        terms[indexPath.row].2.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
