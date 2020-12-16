//
//  SessionView.swift
//  Halfway
//
//  Created by Johannes on 2020-10-08.
//  Copyright © 2020 Halfway. All rights reserved.
//
//About: View shown during a session between two users.

import SwiftUI
import MapKit

struct SessionView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State var showingEndOptions = false
    @State var usersHaveMet = false
    @ObservedObject var usersViewModel = UsersViewModel()
    @ObservedObject private var locationViewModel = LocationViewModel()
    @ObservedObject var createInviteViewModel = CreateInviteViewModel()
    @ObservedObject var profile: UserInfo = .shared
    var body: some View {
        ZStack{
            if (usersViewModel.users.count > 0) {//&& (usersViewModel.friendsImageFetched){
                MapView(usersViewModel: usersViewModel, usersHaveMet: $usersHaveMet)
                    .edgesIgnoringSafeArea(.all)
                    .sheet(isPresented: $usersHaveMet){
                        UsersHaveMetSheet(usersHaveMet: $usersHaveMet)
                    }
            }
            else{
                //TODO: Add waiting view
                MapView()
                    .edgesIgnoringSafeArea(.all)
                
            }
            VStack{
                HStack{
                    Button(action: {
                        print("End session pressed")
                        self.showingEndOptions.toggle()
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .foregroundColor(Color.black)
                    }
                    
                    .alert(isPresented: $showingEndOptions) {
                        Alert(
                            title: Text("End session?"),
                            message: Text("This will close the session and you will no longer see each other on the map"),
                            primaryButton: .destructive(Text("Yes"), action: {
                                withAnimation{
                                    viewRouter.currentPage = .createInvite
                                }
                                
                                
                            }),
                            secondaryButton: .cancel(Text("No"), action: {})
                            
                        )
                    }
                    .padding()
                    .background(Color.white)
                    .mask(Circle())
                    .shadow(radius: 6, x: 6, y: 6)
                    
                    Spacer()
                    if usersHaveMet{
                        Text("User have met")
                    }
                }
                Spacer()
                if (usersViewModel.users.count == 0){
                    if createInviteViewModel.invitationSent{
                        Text("Waiting for friend")
                            .font(.headline)
                            .padding(.bottom)
                    }
                    
                    Button(action: {
                        createInviteViewModel.shareSheet(sessionId: viewRouter.sessionId)
                    },
                    label: {Text(createInviteViewModel.invitationSent ? "Send a new link" : "Send invite link")
                    }).buttonStyle(PrimaryButtonStyle())
                }
                
            }.padding()
        }
        .onAppear() {
            print("session appeared \(viewRouter.sessionId)")
            if viewRouter.sessionId != "" {
                usersViewModel.sessionId = viewRouter.sessionId
                usersViewModel.currentUser = viewRouter.currentUser
            }else{
                //Needed to remove from firebase when app is forcequited (See Scenedelagate)
                viewRouter.sessionId = usersViewModel.sessionId
                viewRouter.currentUser = usersViewModel.currentUser
            }
            usersViewModel.setInitialUserData(name: profile.name, Lat: locationViewModel.userCoordinates.latitude, Long: locationViewModel.userCoordinates.longitude)
            usersViewModel.storeImage(image: profile.uiImage!)
            usersViewModel.fetchData()
        }
        .onDisappear() {
            print("session disappeared")
            usersViewModel.removeUserFromSession(sessionId: viewRouter.sessionId, currentUser: viewRouter.currentUser)
            viewRouter.sessionId = ""
            viewRouter.currentUser = "user1"
        }
        
    }      
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView().environmentObject(ViewRouter())
    }
}
