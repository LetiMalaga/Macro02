//
//  ContentView.swift
//  Pomdera Watch App
//
//  Created by Felipe Porto on 21/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var conection = Connection()
    var body: some View {
        VStack {

            Text(conection.message)
            
            Button(conection.message) {
                conection.sendMessage()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
