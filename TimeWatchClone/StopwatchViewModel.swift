import Foundation
import Combine

class StopwatchViewModel: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0  // 경과 시간, TimeInterval은 Double의 typeAlias
    @Published var isRunning: Bool = false  // 타이머 실행 여부
    @Published var laps: [TimeInterval] = []  // 랩 타임 기록
    
    private var timer: AnyCancellable?  //  Timer를 구독할 Combine 객체
    private var startTime: Date?  //  타이머 시작 시간
    
    
    
    func start() {
        guard !isRunning else { return }  //실행중이면 함수 종료
        
        isRunning = true
        startTime = Date()  // 현재 시간을 시작 시간으로 설정
        
        timer = Timer.publish(every: 0.01, on: .main, in: .common)  // 퍼블리셔 설정, 0.01초 마다 배출
            .autoconnect()  // 구독자가 추가되는 즉시 자동으로 타이머가 실행됨
        // .sink : 퍼블리셔로부터 새로운 값을 받을때마다 실행됨. 즉, 0.01초마다 실행
            .sink { [weak self] _ in  //self를 약한 참조로 선언 -> 뷰가 사라지면 자동으로 해제됨 -> 메모리 누수 방지
                guard let strongSelf = self, let start = strongSelf.startTime else { return }
                strongSelf.elapsedTime = Date().timeIntervalSince(start)  //  시작 시간으로부터 경과 시간 계산
            }
    }
    
    
    
    func stop() {
        timer?.cancel()  //  타이머 정지, timer가 nil인 경우. 즉, start가 안눌린 경우에는 패스
        isRunning = false
    }
    
    
    
    func reset() {
        stop()
        elapsedTime = 0
        laps = []
    }
    
    
    
    func lap() {
        laps.insert(elapsedTime, at: 0)  //  최신 랩 타임을 리스트 맨 앞에 추가
    }
}
