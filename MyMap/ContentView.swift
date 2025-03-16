//
//  ContentView.swift
//  MyMap
//
//  Created by ピットラボ on 2025/03/01.
//

import SwiftUI

struct ContentView: View {
    //  入力中の文字を保持
    @State var inputText: String = ""
    
    //  検索キーワードを保持
    @State var displaySearchKey: String = "東京駅"
    @State var displayMapType : MapType = .standard
    var body: some View {
        VStack {
            TextField("キーワード", text: $inputText, prompt: Text("キーワードを入力してください"))
                //  入力が完了した時
                .onSubmit {
                    displaySearchKey = inputText
                }
                .padding()
            
            ZStack(alignment: .bottomTrailing) {
                MapView(searchKey: displaySearchKey, mapType: displayMapType)
                
                //  マップ種類切り替えボタン
                Button {
                    if displayMapType == .standard {
                        displayMapType = .satellite
                    } else if displayMapType == .satellite {
                        displayMapType = .hybrid
                    } else {
                        displayMapType = .standard
                    }
                } label: {
                    Image(systemName: "map")
                        .resizable()
                        .frame(width: 35.0, height: 35.0)
                }
                .padding(.trailing, 20.0)
                .padding(.bottom, 30.0)
            }
        }
    }
}

#Preview {
    ContentView()
}
