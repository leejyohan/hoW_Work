import SwiftUI


struct Schedule: Identifiable {
    let id = UUID()
    let day: String
    let startHour: Int
    let endHour: Int
    let title: String
}


class TimetableViewModel: ObservableObject {
    @Published var schedules: [Schedule] = []
    
    func addSchedule(day: String, start: Int, end: Int, title: String) {
        let new = Schedule(day: day, startHour: start, endHour: end, title: title)
        schedules.append(new)
    }
}

struct ScheduleFormView: View {
    @Binding var day: String
    @Binding var startHour: Int
    @Binding var endHour: Int
    @Binding var title: String
    
    var onSave: () -> Void
    
    let days = ["월", "화", "수", "목", "금"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("과목명 또는 일정 제목")) {
                    TextField("예: 수학", text: $title)
                }
                Section(header: Text("요일 및 시간")) {
                    Picker("요일", selection: $day) {
                        ForEach(days, id: \.self) { Text($0) }
                    }
                    HStack {
                        Text("시작")
                        Spacer()
                        Text("\(startHour):00")
                    }
                    HStack {
                        Text("종료")
                        Spacer()
                        Text("\(endHour):00")
                    }
                }
            }
            .navigationTitle("스케줄 등록")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("저장") {
                        onSave()
                    }
                    .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        title = ""
                        endHour = startHour
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            }
        }
    }
}



struct TimetableDragView: View {
    let days = ["월", "화", "수", "목", "금"]
    let hours = Array(0..<24)
    
    @StateObject private var viewModel = TimetableViewModel()
    
    @State private var dragStartHour: Int? = nil
    @State private var selectedDay: String? = nil
    @State private var isShowingForm = false
    
    // Form input
    @State private var titleInput = ""
    @State private var selectedStart = 0
    @State private var selectedEnd = 0
    @State private var selectedFormDay = "월"
    
    var body: some View {
        NavigationView {
            ScrollView(.horizontal) {
                VStack(spacing: 0) {
                    // 헤더
                    HStack {
                        Text("시간")
                            .frame(width: 50)
                            .bold()
                        ForEach(days, id: \.self) { day in
                            Text(day)
                                .frame(width: 60)
                                .bold()
                        }
                    }
                    
                    // 본문
                    ForEach(hours, id: \.self) { hour in
                        HStack(spacing: 0) {
                            Text(String(format: "%02d:00", hour))
                                .frame(width: 50)
                                .font(.caption)
                            
                            ForEach(days, id: \.self) { day in
                                let matched = viewModel.schedules.first {
                                    $0.day == day && $0.startHour <= hour && hour < $0.endHour
                                }
                                
                                Rectangle()
                                    .fill(matched != nil ? Color.blue.opacity(0.7) : Color.gray.opacity(0.05))
                                    .frame(width: 60, height: 30)
                                    .border(Color.gray.opacity(0.3), width: 0.5)
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { _ in
                                                if dragStartHour == nil {
                                                    dragStartHour = hour
                                                    selectedDay = day
                                                }
                                            }
                                            .onEnded { _ in
                                                if let start = dragStartHour, selectedDay == day {
                                                    dragStartHour = nil
                                                    selectedFormDay = day
                                                    selectedStart = min(start, hour)
                                                    selectedEnd = max(start, hour) + 1
                                                    titleInput = ""
                                                    isShowingForm = true
                                                }
                                            }
                                    )
                            }
                        }
                    }
                }
            }
            .navigationTitle("드래그 스케줄")
        }
        .sheet(isPresented: $isShowingForm) {
            ScheduleFormView(
                day: $selectedFormDay,
                startHour: $selectedStart,
                endHour: $selectedEnd,
                title: $titleInput,
                onSave: {
                    viewModel.addSchedule(
                        day: selectedFormDay,
                        start: selectedStart,
                        end: selectedEnd,
                        title: titleInput
                    )
                    isShowingForm = false
                }
            )
        }
    }
}
