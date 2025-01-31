//
//  TermsViewController.swift
//  Ting
//
//  Created by t2023-m105 on 1/24/25.
//

import UIKit

/// 약관 동의 화면을 위한 뷰컨트롤러
class TermsViewController: UIViewController {
    
    private let termsView = TermsView()
    
    // 약관 항목 데이터 (기본 체크 해제)
    private var terms: [(String, Bool, Bool)] = [
        ("(필수) 만 14세 이상입니다", true, false),  // 기본 체크된 상태
        ("(필수) 서비스 이용약관", true, false),
        ("(필수) 개인정보 수집 및 이용에 대한 안내", true, false),
        ("(선택) 개인정보 수집 및 이용에 대한 안내", false, false) // 선택 동의는 기본 해제
    ]
    
    override func loadView() {
        view = termsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActions()
    }
    
    // 테이블 뷰 설정
    private func setupTableView() {
        termsView.tableView.delegate = self
        termsView.tableView.dataSource = self
        termsView.tableView.register(TermsCell.self, forCellReuseIdentifier: "TermsCell")
    }
    
    // 버튼 액션 설정
    private func setupActions() {
        termsView.allAgreeButton.addTarget(self, action: #selector(allAgreeTapped), for: .touchUpInside)
        termsView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    // "모두 동의합니다" 버튼 클릭 시
    @objc private func allAgreeTapped() {
        let allChecked = terms.allSatisfy { $0.2 } // 모든 항목이 체크 상태인지 확인
        terms = terms.map { ($0.0, $0.1, !allChecked) } // 처음 해제된 상태에서 모두 체크되도록 변경
        termsView.tableView.reloadData()
    }
    
    // "다음" 버튼 클릭 시
    @objc private func nextTapped() {
        print("다음 버튼 클릭됨")
        // 선택된 항목을 저장하고 다음 화면으로 이동하는 로직 추가 가능
    }
}

// MARK: - 테이블뷰 데이터소스 및 델리게이트
extension TermsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TermsCell", for: indexPath) as? TermsCell else {
            return UITableViewCell()
        }
        let term = terms[indexPath.row]
        cell.configure(text: term.0, isRequired: term.1, isChecked: term.2)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        terms[indexPath.row].2.toggle() // 선택된 약관 체크 토글
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
