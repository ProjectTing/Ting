# Ting - 프로젝트를 위한 완벽한 매칭

## 📱 프로젝트 소개
개발자, 디자이너, 기획자 등 협업이 필요한 사람들이 적절한 팀원을 찾기 어려운 문제를 해결하기 위한 프로젝트 기반 협업 및 개발 스터디 매칭 앱입니다.

## 👥 팀원 소개

| Names     | GitHub   | 
| -------- | -------- | 
| 이재건   | [@Quaker-Lee](https://github.com/Quaker-Lee) |
| 유태호   | [@taeryu7](https://github.com/taeryu7) |
| 나영진   | [@bryjna07](https://github.com/bryjna07) |
| 오푸른솔   | [@solnamul](https://github.com/solnamul) |

## 📅 프로젝트 기간
- **MVP**: 2025.01.16 ~ 2025.02.17
- **유저피드백 & 버그수정**: 2025.02.17 ~ 2025.02.19
- **리팩토링**: 2025.02.19 ~ ing

## 🖼️ 스크린샷
(스크린샷은 추가 예정)

## ⚡️ 주요 기능
### 사용자 인증 및 관리
- Apple 로그인 (Sign in with Apple)
- 비로그인 둘러보기 모드
- 이용약관 동의 프로세스
- 회원정보 관리 (수정/탈퇴)

### 게시글 관리
- 팀원 모집 / 팀 합류 게시글 작성
- 카테고리별 게시글 분류 (개발자, 디자이너, 기획자, 기타)
- 게시글 조회 및 페이징 처리
- 게시글 수정 및 삭제

### 검색 및 필터링
- 키워드 기반 게시글 검색
- 다중 태그 필터링 (게시판 유형, 직무, 작업 방식)
- 동적 태그 UI 구현

### 신고 시스템
- 부적절한 게시글 신고 기능
- 신고 내역 관리
- 누적 신고 시 자동 삭제 처리
- Slack 알림 연동

### 차단 시스템
- 특정 유저 차단 기능
- 차단한 유저의 게시글은 자동으로 숨김처리

##  ⚡️ 주요 구현 내용

### 사용자 인증 흐름
1. Apple 로그인 인증
2. Firebase 사용자 등록
3. 약관 동의 프로세스
4. 사용자 정보 입력
5. 메인 화면 진입

### 게시글 시스템
- **PostService**: Firestore를 활용한 CRUD 작업
- **페이징 처리**: lastDocument를 활용한 무한 스크롤
- **동적 컴포지셔널 레이아웃**: 메인 화면 구성
- **태그 기반 필터링**: 다중 선택 가능한 필터 UI

### 신고 시스템
- **ReportManager**: 신고 내역 관리
- **PostService.incrementReportCount**: 트랜잭션 기반 신고 카운트 증가
- **자동 삭제**: 5회 이상 신고 시 자동 삭제 로직
- **SlackService**: 관리자 알림 시스템

### UI/UX 개선
- **TagFlowLayout**: 동적 태그 배치 시스템
- **LoadingFooterView**: 페이징 로딩 인디케이터
- **CustomTag**: 재사용 가능한 태그 UI
- **반응형 레이아웃**: 다양한 기기 대응

### 마이페이지 시스템
- **UserInfoService**: Firebase를 통한 CRUD 작업
- 회원정보 수정, 회원탈퇴 기능 구현
- ***UserDefaults**에 저장된 유저별 UID로 회원정보 관리

## 🛠 기술 스택
### 프레임워크 및 라이브러리
- **UIKit**: 인터페이스 구현
- **SnapKit**: 코드 기반 AutoLayout
- **Then**: 선언형 UI 구성
- **Firebase Auth**: 사용자 인증
- **Firebase Firestore**: 데이터베이스
- **AuthenticationServices**: Apple 로그인

### 디자인 패턴
- **BaseView**: 공통 UI 컴포넌트 상속 구조
- **CustomTag**: 재사용 가능한 태그 버튼 컴포넌트
- **NotificationCenter**: 화면 간 이벤트 전달
- **Protocol-Delegate**: 모달 및 팝업 데이터 전달


## 📦 How to Install
Download in AppStore!  
[AppStore에서 Ting 다운로드하기](https://apps.apple.com/kr/app/ting-%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8%EB%A5%BC-%EC[…]C-%EC%99%84%EB%B2%BD%ED%95%9C-%EB%A7%A4%EC%B9%AD/id6741317435)
