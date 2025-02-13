//
//  ReportVC.swift
//  Ting
//
//  Created by 이재건 on 1/21/25.
//

import UIKit
import SnapKit
import FirebaseFirestore

class ReportVC: UIViewController, UITextViewDelegate {
    // MARK: - Properties
    private var selectedReason: String?
    private var targetPost: Post?
    private var reporterNickname: String?
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
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
    
    // MARK: - Initialization
    init(post: Post, reporterNickname: String) {
        self.targetPost = post
        self.reporterNickname = reporterNickname
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupInitialData()
        setupTapGesture()
        setupKeyboardNotification()
    }
    
    // MARK: - 키보드 화면 위로 올리기 관련
    deinit {
        // 메모리 누수 방지
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        //  키보드가 텍스트뷰를 가리지 않도록 contentInset 조정
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom = keyboardHeight + 20
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        //  원래 상태로 복구
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentInset.bottom = 0
            self.scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    private func setupInitialData() {
        if let post = targetPost {
            postTitleValueLabel.text = post.title
            authorValueLabel.text = post.nickName
            dateValueLabel.text = formatDate(post.createdAt)
        }
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        setupBasic()
        setupComponents()
        setupConstraints()
    }
    
    private func setupBasic() {
        view.backgroundColor = .background
        scrollView.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
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
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = .deepCocoa
        
        postTitleLabel.text = "게시글 제목"
        postTitleLabel.font = .systemFont(ofSize: 16)
        postTitleLabel.textColor = .brownText
        
        postTitleValueLabel.text = targetPost?.title ?? "신고할 게시글 제목"
        postTitleValueLabel.font = .systemFont(ofSize: 16)
        postTitleValueLabel.textColor = .deepCocoa
        postTitleValueLabel.textAlignment = .right
        postTitleValueLabel.numberOfLines = 0               // 여러 줄 표시 허용
        postTitleValueLabel.lineBreakMode = .byWordWrapping // 단어 단위로 줄바꿈
        
        authorLabel.text = "작성자"
        authorLabel.font = .systemFont(ofSize: 16)
        authorLabel.textColor = .brownText
        
        authorValueLabel.text = targetPost?.nickName ?? "본인 이름or닉네임"
        authorValueLabel.font = .systemFont(ofSize: 16)
        authorValueLabel.textColor = .deepCocoa
        authorValueLabel.textAlignment = .right
        
        dateLabelTitle.text = "작성일"
        dateLabelTitle.font = .systemFont(ofSize: 16)
        dateLabelTitle.textColor = .brownText
        
        dateValueLabel.text = ReportManager.shared.getCurrentTime()
        dateValueLabel.font = .systemFont(ofSize: 16)
        dateValueLabel.textColor = .deepCocoa
        dateValueLabel.textAlignment = .right
        
        reportReasonLabel.text = "신고 사유"
        reportReasonLabel.font = .systemFont(ofSize: 18, weight: .bold)
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
        reportButton.backgroundColor = .primaries
        reportButton.layer.cornerRadius = 8
        reportButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [titleLabel, targetInfoView, reportReasonLabel, reasonCardView,
         reportDescriptionTextView, reportButton].forEach { contentView.addSubview($0) }
        
        reasonCardView.addSubview(radioStackView)
        
        targetInfoView.addSubviews(
            postTitleLabel, postTitleValueLabel,
            authorLabel, authorValueLabel,
            dateLabelTitle, dateValueLabel
        )
        
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
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.left.right.equalTo(contentView).inset(20)
        }
        
        targetInfoView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.right.equalTo(contentView).inset(20)
        }
        
        postTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(74)
        }
        
        postTitleValueLabel.snp.makeConstraints { make in
            make.top.equalTo(postTitleLabel)
            make.left.equalTo(postTitleLabel.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(postTitleValueLabel.snp.bottom).offset(16)
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
            make.left.equalTo(contentView).offset(20)
        }
        
        reasonCardView.snp.makeConstraints { make in
            make.top.equalTo(reportReasonLabel.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(240)
        }
        
        radioStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        reportDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(reasonCardView.snp.bottom).offset(32)
            make.left.right.equalTo(contentView).inset(20)
            make.height.equalTo(200)
        }
        
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(reportDescriptionTextView.snp.bottom).offset(32)
            make.left.right.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Button Actions
    @objc private func radioButtonTapped(_ sender: UIButton) {
        [spamButton, harmButton, abuseButton,
         privacyButton, inappropriateButton, etcButton].forEach {
            if $0 == sender {
                $0.layer.borderColor = UIColor.primaries.cgColor
                let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
                let image = UIImage(systemName: "circle.fill", withConfiguration: config)?
                    .withTintColor(.primaries, renderingMode: .alwaysOriginal)
                $0.setImage(image, for: .normal)
                $0.backgroundColor = .primaries.withAlphaComponent(0.1)
                selectedReason = getReasonText(for: sender)
            } else {
                $0.layer.borderColor = UIColor.grayCloud.cgColor
                $0.setImage(nil, for: .normal)
                $0.backgroundColor = .white
            }
        }
    }
    
    private func getReasonText(for button: UIButton) -> String {
        switch button {
        case spamButton: return "스팸/홍보성 게시글"
        case harmButton: return "위험 정보"
        case abuseButton: return "욕설/비방"
        case privacyButton: return "개인정보 노출"
        case inappropriateButton: return "음란성/선정성"
        case etcButton: return "기타"
        default: return ""
        }
    }
    
    @objc private func reportButtonTapped() {
        // 유효성 검사
        guard let selectedReason = selectedReason else {
            showAlert(title: "알림", message: "신고 사유를 선택해주세요.")
            return
        }
        
        let description = reportDescriptionTextView.text ?? ""
        if description == placeholderText || description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showAlert(title: "알림", message: "신고 내용을 입력해주세요.")
            return
        }
        
        guard let post = targetPost,
              let postId = post.id,  // post.id 추가
              let reporterNickname = reporterNickname else {
            showAlert(title: "오류", message: "필요한 정보가 누락되었습니다.")
            return
        }
        
        // 중복 신고 체크
        ReportManager.shared.checkDuplicateReport(postId: postId, reporterNickname: reporterNickname) { [weak self] isDuplicate in
            guard let self = self else { return }
            
            if isDuplicate {
                DispatchQueue.main.async {
                    self.showAlert(title: "알림", message: "이미 신고한 게시글입니다.")
                }
                return
            }
            
            // 신고 진행
            let report = Report(
                postId: postId,     // postId 추가
                reportReason: selectedReason,
                reportDetails: description,
                title: post.title,
                reporterNickname: reporterNickname,
                creationTime: ReportManager.shared.getCurrentTime(),
                nickname: post.nickName
            )
            
            // Firebase에 업로드
            ReportManager.shared.uploadReport(report) { [weak self] result in
                switch result {
                case .success:
                    self?.showCompletionAlert()
                case .failure(let error):
                    print("\(error)")
                    self?.showAlert(title: "오류", message: "신고 접수 중 오류가 발생했습니다")
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    private func showCompletionAlert() {
        let alert = UIAlertController(
            title: "신고 완료",
            message: "신고가 정상적으로 접수되었습니다.",
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
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
    
    //MARK: - 키보드 설정
    private func setupTapGesture() { // 외부 터치시 키보드 내리기 위한 TapGestureRecognizer 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
