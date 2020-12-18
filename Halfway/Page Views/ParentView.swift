//
//  ParentView.swift
//  Halfway
//
//  Created by Johannes on 2020-11-24.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct ParentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        switch viewRouter.currentPage {
            case .splash:
                SplashView()
            case .settingLocation:
                SettingLocationView()
           case .userProfile:
                UserProfileView()
            case .createInvite:
                CreateInviteView()
            case .session:
                SessionView()
                    .transition(.slide)
            default:
                Text("Default")
        }
        
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView().environmentObject(ViewRouter())
    }
}
