//
//  ReportNotification.swift
//  Ting
//
//  Created by 이재건 on 2/14/25.
//

import Foundation

class SlackService {
    // Webhook URL을 private 속성으로 관리하여 외부에서 직접 변경할 수 없도록 보호
    private let webhookURL: URL
    
    // 생성자: Webhook URL을 설정
    init() {
        // MARK: - Slack에서 받은 Webhook URL | 절대 틀리면 안됨.
        let urlString = "https://hooks.slack.com/services/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"
        
        // URL 문자열을 URL 객체로 변환, 실패할 경우 fatalError로 앱이 종료되도록 처리
        guard let url = URL(string: urlString) else {
            fatalError("잘못된 Webhook URL입니다.")
        }
        
        // webhookURL에 변환된 URL 저장
        self.webhookURL = url
    }

    // Slack으로 메시지를 전송하는 메서드
    func sendSlackMessage(message: String) {
        // Slack 메시지를 보내기 위한 HTTP 요청을 생성하는 함수
        print("sendSlackMessage 함수 호출됨")
        
        // URLRequest 객체를 사용하여 POST 요청을 생성
        var request = URLRequest(url: webhookURL)
        request.httpMethod = "POST" // HTTP 메서드는 POST
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // 요청 헤더에 Content-Type을 JSON으로 설정

        // 전송할 메시지를 JSON 형식으로 변환하기 위한 딕셔너리 생성
        let body = ["text": message]

        do {
            // 딕셔너리를 JSON 데이터로 변환
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData // 요청의 본문에 JSON 데이터를 할당
        } catch {
            // JSON 데이터 변환 실패 시 에러 처리
            print("JSON 데이터 변환 실패: \(error.localizedDescription)")
            return
        }

        // URLSession을 사용하여 네트워크 요청을 비동기로 전송
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // 요청 실패 시 에러 메시지 출력
                print("Slack 전송 실패: \(error.localizedDescription)")
                return
            }

            // HTTP 응답 코드 출력
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP 상태 코드: \(httpResponse.statusCode)")
            }

            // 응답 데이터가 있다면 출력
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("응답 데이터: \(responseString)")
            }

            // 메시지 전송 성공 메시지 출력
            print("Slack 메시지 전송 성공!")
        }

        // 요청을 비동기로 시작
        task.resume()
    }
}
