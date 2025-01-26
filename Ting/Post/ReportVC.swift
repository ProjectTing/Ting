//
//  ReportVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit

class ReportVC: UIViewController, UITextViewDelegate {
    // MARK: - UI Components
    private let titleLabel = UILabel()
    private let whiteCardView = UIView()
    private let targetInfoView = UIView()
    private let reasonCardView = UIView()
    private let placeholderText = "신고 사유에 대해 자세히 설명해주세요"

    private let postTitleLabel = UILabel()
    private let postTitleValueLabel = UILabel()
    private let authorLabel = UILabel()
    private let authorValueLabel = UILabel()
    private let dateLabelTitle = UILabel()
    private let dateValueLabel = UILabel()

    private let reportReasonLabel = UILabel()
    private let radioStackView = UIStackView()

    private let spamButton = createRadioButton()
    private let spamLabel = UILabel()
    private let harmButton = createRadioButton()
    private let harmLabel = UILabel()
    private let abuseButton = createRadioButton()
    private let abuseLabel = UILabel()
    private let privacyButton = createRadioButton()
    private let privacyLabel = UILabel()
    private let inappropriateButton = createRadioButton()
    private let inappropriateLabel = UILabel()
    private let etcButton = createRadioButton()
    private let etcLabel = UILabel()

    private let reportDescriptionTextView = UITextView()
    private let reportButton = UIButton()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - UI Configuration
    private func configureUI() {
        setupBasic()
        setupComponents()
        setupConstraints()
    }

    private func setupBasic() {
        view.backgroundColor = .background
 
        // White card setup
        targetInfoView.backgroundColor = .white
        targetInfoView.layer.cornerRadius = 12

        reasonCardView.backgroundColor = .white
        reasonCardView.layer.cornerRadius = 12

        radioStackView.axis = .vertical
        radioStackView.spacing = 24
        radioStackView.distribution = .fillEqually
        radioStackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        radioStackView.isLayoutMarginsRelativeArrangement = true
        radioStackView.spacing = 24
    }

    private func setupComponents() {
        setupLabels()
        setupRadioButtons()
        setupTextView()
        setupButton()
        addSubviews()
    }

    private func setupLabels() {
        titleLabel.text = "신고 대상"
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = .deepCocoa
 
        postTitleLabel.text = "게시글 제목"
        postTitleLabel.font = .systemFont(ofSize: 16)
        postTitleLabel.textColor = .brownText

        postTitleValueLabel.text = "신고할 게시글 제목"
        postTitleValueLabel.font = .systemFont(ofSize: 16)
        postTitleValueLabel.textColor = .deepCocoa
        postTitleValueLabel.textAlignment = .right

        authorLabel.text = "작성자"
        authorLabel.font = .systemFont(ofSize: 16)
        authorLabel.textColor = .brownText

        authorValueLabel.text = "본인 이름or닉네임"
        authorValueLabel.font = .systemFont(ofSize: 16)
        authorValueLabel.textColor = .deepCocoa
        authorValueLabel.textAlignment = .right

        dateLabelTitle.text = "작성일"
        dateLabelTitle.font = .systemFont(ofSize: 16)
        dateLabelTitle.textColor = .brownText

        dateValueLabel.text = "당일 날짜"
        dateValueLabel.font = .systemFont(ofSize: 16)
        dateValueLabel.textColor = .deepCocoa
        dateValueLabel.textAlignment = .right

        reportReasonLabel.text = "신고 사유"
        reportReasonLabel.font = .systemFont(ofSize: 18, weight: .medium)
        reportReasonLabel.textColor = .deepCocoa
        
        setupReasonLabels()
    }

    private func setupReasonLabels() {
        [spamLabel, harmLabel, abuseLabel, privacyLabel, inappropriateLabel, etcLabel].forEach {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .deepCocoa
        }
 
        spamLabel.text = "스팸/홍보성 게시글"
        harmLabel.text = "위험 정보"
        abuseLabel.text = "욕설/비방"
        privacyLabel.text = "개인정보 노출"
        inappropriateLabel.text = "음란성/선정성"
        etcLabel.text = "기타"
    }

    private static func createRadioButton() -> UIButton {
        let button = UIButton()
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.grayCloud.cgColor
        button.backgroundColor = .white
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        return button
    }

    private func setupRadioButtons() {
       [spamButton, harmButton, abuseButton,
        privacyButton, inappropriateButton, etcButton].forEach { button in
           button.addTarget(self, action: #selector(radioButtonTapped(_:)), for: .touchUpInside)
       }
    }

    private func setupTextView() {
        reportDescriptionTextView.backgroundColor = .white
        reportDescriptionTextView.layer.cornerRadius = 12
        reportDescriptionTextView.font = .systemFont(ofSize: 16)
        reportDescriptionTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        reportDescriptionTextView.text = placeholderText
        reportDescriptionTextView.textColor = .grayCloud
        reportDescriptionTextView.delegate = self
    }

    private func setupButton() {
        reportButton.setTitle("신고하기", for: .normal)
        reportButton.backgroundColor = .primary
        reportButton.layer.cornerRadius = 8
        reportButton.titleLabel?.font = .systemFont(ofSize: 16)
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
    }

    private func addSubviews() {
        [titleLabel, targetInfoView, reportReasonLabel, reasonCardView,
         reportDescriptionTextView, reportButton].forEach { view.addSubview($0) }

        reasonCardView.addSubview(radioStackView)

        targetInfoView.addSubviews([
            postTitleLabel, postTitleValueLabel,
            authorLabel, authorValueLabel,
            dateLabelTitle, dateValueLabel
        ])

         [(spamButton, spamLabel),
         (harmButton, harmLabel),
         (abuseButton, abuseLabel),
         (privacyButton, privacyLabel),
         (inappropriateButton, inappropriateLabel),
         (etcButton, etcLabel)].forEach { button, label in
            let container = UIView()
            container.backgroundColor = .clear
            container.addSubview(button)
            container.addSubview(label)
            radioStackView.addArrangedSubview(container)
 
             button.snp.makeConstraints { make in
                 make.centerY.equalToSuperview()
                 make.left.equalToSuperview()
                 make.size.equalTo(20)
             }
 
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalTo(button.snp.right).offset(12)
                make.right.equalToSuperview()
            }
        }
    }
 
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
 
        targetInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
 
        // Target Info Constraints
        postTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
        }
 
        postTitleValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(postTitleLabel)
            make.right.equalToSuperview().offset(-16)
        }
 
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(postTitleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
        }
 
        authorValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authorLabel)
            make.right.equalToSuperview().offset(-16)
        }
 
        dateLabelTitle.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
 
        dateValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabelTitle)
            make.right.equalToSuperview().offset(-16)
        }
 
        reportReasonLabel.snp.makeConstraints { make in
            make.top.equalTo(targetInfoView.snp.bottom).offset(32)
            make.left.equalToSuperview().offset(20)
        }
 
        reasonCardView.snp.makeConstraints { make in
            make.top.equalTo(reportReasonLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
 
        radioStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
 
        reportDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(reasonCardView.snp.bottom).offset(32)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
 
        reportButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
    }

    @objc private func radioButtonTapped(_ sender: UIButton) {
        [spamButton, harmButton, abuseButton,
         privacyButton, inappropriateButton, etcButton].forEach {
            if $0 == sender {
                $0.layer.borderColor = UIColor.primary.cgColor
                let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
                let image = UIImage(systemName: "circle.fill", withConfiguration: config)?
                    .withTintColor(.primary, renderingMode: .alwaysOriginal)
                $0.setImage(image, for: .normal)
                $0.backgroundColor = .primary.withAlphaComponent(0.1)
            } else {
                $0.layer.borderColor = UIColor.grayCloud.cgColor
                $0.setImage(nil, for: .normal)
                $0.backgroundColor = .white
            }
        }
    }
    
    @objc private func reportButtonTapped() {
        let alert = UIAlertController(
            title: "신고 완료",
            message: "신고가 정상적으로 접수되었습니다.",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            // TODO: 신고 처리 후 화면 이동 로직 추가
            self?.dismiss(animated: true)
        }
        
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeholderText
            textView.textColor = .grayCloud
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    ReportVC()
}

/** TODO LIST
 () 처리 되어있는건 스크럼시 팀원들과 회의 필요
 
 - firebase 연동 이후
 1. 신고대상 자동작성
    이 화면으로 넘어오면 신고한 제목 자동으로 가져오기
    신고당하는 작성자 자동으로 가져오기 (없지만 추가 해야하는지)
    신고글을 작성하는 작성자 닉네임 자동으로 가져오기
    신고글을 작성하는 당일날 시간 자동으로 띄우기 (년/월/일)만
 
 2. 신고하기 버튼 터치후 자동으로 firebase에 데이터 자동으로 저장
 
  - 화면내 기능
 1. 신고사유 터치 시 항목설정한 내용이 보이게 필요
    하나의 항목만할지, 여러개를 선택 가능하게 할지(하나만)
 현재 이부분에서 문제가 많음. 스크럼이나 월요이ㅏㄹ 튜터님을 통해서 해결필요
 
 2. 신고하기 버튼 터치 이후 신고가 완료되었다는 alert구현 필요
 
 3. 신고하기 버튼 누른후 어디 화면으로 가야하는지? (이거 중요)
 postmain으로 이동
 */
