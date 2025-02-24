import SwiftUI

struct StopwatchView: View {
    @StateObject private var viewModel = StopwatchViewModel()  // ⏳ ViewModel 사용
    @Environment(\.colorScheme) var colorSceme
    
    // ⏳ 시간 포맷터 (00:00.00 형태)
    private var formattedTime: String {
        let minutes = Int(viewModel.elapsedTime) / 60
        let seconds = Int(viewModel.elapsedTime) % 60
        let milliseconds = Int((viewModel.elapsedTime.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    var body: some View {
        VStack {
            // ✅ 1️⃣ 경과 시간 표시 (00:00.00)
            Text(formattedTime)
                .font(.system(size: 80))
                .fontWeight(.thin)
                .foregroundStyle(.white)
                .padding(.bottom, 80)
            
            
            
            // ✅ 2️⃣ 버튼 영역 🏁
            HStack(spacing: 20) {
                Button(action: viewModel.reset) {
                    Text("재설정")
                        .frame(width: 100, height: 50)
                        .background(Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                
                
                Button(action: {
                    if viewModel.isRunning {
                        viewModel.lap()  // 🏁 랩 타임 추가
                    } else {
                        viewModel.start()
                    }
                }) {
                    Text(viewModel.isRunning ? "랩" : "시작")
                        .frame(width: 100, height: 50)
                        .background(viewModel.isRunning ? Color.green : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                
                
                
                Button(action: viewModel.isRunning ? viewModel.stop : viewModel.start) {
                    Text(viewModel.isRunning ? "정지" : "시작")
                        .frame(width: 100, height: 50)
                        .background(viewModel.isRunning ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
            }
            .padding(.bottom, 30)
            
            // ✅ 3️⃣ 랩 타임 리스트 📄
            List(viewModel.laps.indices, id: \.self) { index in
                let lapTime = viewModel.laps[index]
                let lapMinutes = Int(lapTime) / 60
                let lapSeconds = Int(lapTime) % 60
                let lapMilliseconds = Int((lapTime.truncatingRemainder(dividingBy: 1)) * 100)
                
                HStack {
                    Text("랩 \(viewModel.laps.count - index)")  // 랩 번호 표시
                        .foregroundColor(index == 0 ? .green : index == viewModel.laps.count - 1 ? .red : .white)
                    
                    Spacer()
                    
                    Text(String(format: "%02d:%02d.%02d", lapMinutes, lapSeconds, lapMilliseconds))
                        .foregroundColor(.white)
                }
                .font(.title2)
                .padding()
                .background(.black)
            }
            .frame(height: 300)
            .listStyle(PlainListStyle())
        }
        .frame(maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView()
    }
}
