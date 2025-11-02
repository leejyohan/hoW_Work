//
//  ContentView.swift
//  hoW_Work
//
//  Created by 이지현 on 9/23/25.
//

import SwiftUI

//View 시각적 요소 정의
struct ContentView: View {
    @AppStorage("hourlyRate") var hourly :Double = 10030.0
    @AppStorage("taxRate") var taxRate: Double = 3.3
    
    private let currencyFormat: FloatingPointFormatStyle<Double>.Currency = .currency(code: "KRW")
    
    private let percentFormat: FloatingPointFormatStyle<Double> = .number.precision(.fractionLength(1))
    
    //입력란을 무조건 입력해야하는 문제가있음
    var body: some View {
        NavigationStack{
            VStack { //하위 뷰를 수직 정렬 HStack(수평정렬)
                Text("Hello, hoW_Work")
                Form {
                    Section("시급 설정") {
                        HStack {
                            Text("시간당 시급")
                            Spacer()
                            // 시급을 입력받는 TextField
                            TextField("시급 입력", value: $hourly, format: currencyFormat)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                        // 저장된 시급 확인
                        Text("저장된 시급: \(hourly)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Section("세율 설정 (단위: %)") {
                        
                        // 1. 세율을 표시하는 슬라이더
                        VStack(alignment: .leading) {
                            Text("현재 세율: **\(taxRate, format: percentFormat)%**")
                            // 세율을 0%에서 50% 사이에서 조절
                            Slider(value: $taxRate, in: 0...50, step: 0.5) {
                                Text("세율")
                            }
                        }
                        
                        // 2. 세율을 직접 입력하는 TextField
                        HStack {
                            Text("세율 (%)")
                            Spacer()
                            TextField("세율 입력", value: $taxRate, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                        
                        // 저장된 세율 확인
                        Text("저장된 세율: \(taxRate, specifier: "%.1f")%")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .navigationTitle("시급 및 세금 설정")
                }
                
                NavigationLink("next"){
                    SecondView()
                }
                
                //수정
            }
        }
        .padding()
    }
}
