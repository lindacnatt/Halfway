//
//  ContentView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-07.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var data = UserRepository()
    
    var body: some View {
        List(data.users){ user in
            Text(user.name).font(.largeTitle)
            Text(user.city)
            Text(user.food)
            
        }.onAppear(){
            self.data.load()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
