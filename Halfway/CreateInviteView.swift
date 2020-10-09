//
//  CreateInviteView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-09.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct CreateInviteView: View {
    var body: some View {
        VStack{
            Spacer()
            VStack{
                Text("Halfway")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.orange)
                Text("Facilitating encounters")
                
            }
            .padding(.bottom,200)
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
            Text("Create Invite Link")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 90)
                .padding()
                
            }
            .background(Color.orange)
            .cornerRadius(.infinity)
            .padding(.bottom)
        }.padding(.bottom)
    
        
    }
}

struct CreateInviteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateInviteView()
    }
}
