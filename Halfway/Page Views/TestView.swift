//
//  TestView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-11-06.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct TestView: View {
    @ObservedObject private var viewModel = UsersViewModel() // so that the view doe not rewrite it self when data is updated.
    var body: some View {
        VStack {
            List(viewModel.users){ user in
                VStack{
                    Text(user.name)
                }
                
            }.onAppear(){
                self.viewModel.fetchData()
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
