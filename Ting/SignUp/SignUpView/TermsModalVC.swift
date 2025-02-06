//
//  TermsModalVC.swift
//  Ting
//
//  Created by t2023-m105 on 1/24/25.
//

import UIKit
import SnapKit
import Then

// Delegate 프로토콜 추가
protocol TermsModalViewControllerDelegate: AnyObject {
    func didCompleteTermsAgreement()
}

/// 약관 동의 모달 창을 위한 뷰컨트롤러
class TermsModalViewController: UIViewController {
    
    // Delegate 프로퍼티 추가
    weak var delegate: TermsModalViewControllerDelegate?
    
    private let termsView = TermsView()  // 약관 뷰
    
    // 약관 항목 데이터 및 링크 추가
    private var terms: [(String, Bool, Bool, URL?)] = [
        ("(필수) 만 14세 이상입니다", true, false, nil),
        ("(필수) 서비스 이용약관", true, false, URL(string: "https://docs.google.com/document/d/1TK664HgE71qhHrwNoSkDdw05Hpy5rSWPkJLOriAlKJE/edit?usp=sharing")),
        ("(필수) 개인정보 수집 및 이용에 대한 안내", true, false, URL(string: "https://docs.google.com/document/d/10mfn2CaJ4UnLmfRQFngGkveiPAcQQIf-XPo3_ly-1j8/edit?usp=sharing"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupActions()
        updateNextButtonState()  // 처음 화면 로드 시 버튼 비활성화
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
        
        termsView.tableView.backgroundColor = termsView.backgroundColor
    }
    
    private func setupActions() {
        termsView.allAgreeButton.addTarget(self, action: #selector(allAgreeTapped), for: .touchUpInside)
        termsView.nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }
    
    @objc private func allAgreeTapped() {
        let allChecked = terms.allSatisfy { $0.2 }  // 현재 모든 항목이 체크된 상태인지 확인
        let newState = !allChecked  // 반대 상태로 토글

        // 모든 약관의 체크 상태를 변경
        terms = terms.map { ($0.0, $0.1, newState, $0.3) }
        termsView.tableView.reloadData()
        
        updateNextButtonState()  // 상태 변경 후 버튼 업데이트
    }
    
    @objc private func nextTapped() {
        guard let presentingVC = presentingViewController else {
            print("presentingViewController가 nil입니다.")
            return
        }

        dismiss(animated: true) { [weak self] in
            // delegate를 옵셔널로 안전하게 호출
            guard let self = self else { return }
            self.delegate?.didCompleteTermsAgreement()
        }
    }

    // 모든 항목이 체크되었는지 확인하고 버튼 상태 업데이트
    private func updateNextButtonState() {
        let allChecked = terms.allSatisfy { $0.2 }
        termsView.nextButton.isEnabled = allChecked  // 모든 항목이 체크되었을 때만 활성화
        termsView.nextButton.backgroundColor = allChecked ? .accent : .lightGray  // 시각적 피드백
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
        
        cell.configure(text: term.0, isRequired: term.1, isChecked: term.2, url: term.3)
        
        // 약관 항목의 배경색을 모달 창과 동일하게 설정
        cell.contentView.backgroundColor = termsView.backgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        terms[indexPath.row].2.toggle()  // 체크 상태 토글
        tableView.reloadRows(at: [indexPath], with: .automatic)
        updateNextButtonState()  // 상태 변경 후 버튼 업데이트
    }
}
