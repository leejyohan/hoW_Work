//
//  ContentView.swift
//  hoW_Work
//
//  Created by 이지현 on 9/23/25.
//

import SwiftUI

//View 시각적 요소 정의
struct ContentView: View {
    var body: some View {
        NavigationStack{
            VStack { //하위 뷰를 수직 정렬 HStack(수평정렬)
                Text("Hello, hoW_Work")
                
                NavigationLink("next"){
                    SecondView()
                }

                //수정
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
