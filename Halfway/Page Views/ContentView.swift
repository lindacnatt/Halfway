//
//  ContentView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-07.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DatePicker(selection: /*@START_MENU_TOKEN@*/.constant(Date())/*@END_MENU_TOKEN@*/, label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
