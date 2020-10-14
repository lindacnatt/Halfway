//
//  ContentView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-07.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showModal = false
    var body: some View {
        
        
        Button("Show Finished-Modal") {self.showModal.toggle()}
        .sheet(isPresented: $showModal) {
            FinishedView(showModal: self.$showModal)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
