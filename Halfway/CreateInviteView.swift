//
//  CreateInviteView.swift
//  Halfway
//
//  Created by Linda Cnattingius on 2020-10-09.
//  Copyright © 2020 Halfway. All rights reserved.
//

import SwiftUI

struct CreateInviteView: View {
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack{
            MapView(annotations: userAnnotations).edgesIgnoringSafeArea(.all)
              VStack{
                        Spacer()
                        VStack{
                            Text("Halfway")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color.orange)
                            Text("Facilitating encounters")
                        }
                        Spacer()
                        Button(action: shareSheet) {
                            Text("Create Invite Link")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 90)
                                .padding()
                        }
                        .background(Color.orange)
                        .cornerRadius(.infinity)
                        .padding(.bottom)
                    }
                        .padding(.bottom)
            //            .sheet(isPresented: $showShareSheet) {
            //                ShareSheet(activityItems: ["Invitation Link"])
            //            }
        }
    }
    func shareSheet(){
        guard let link = URL(string: "https://www.apple.com") else { return }
        let av = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
    
}

//struct ShareSheet: UIViewControllerRepresentable {
//    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
//
//    let activityItems: [Any]
//    let applicationActivities: [UIActivity]? = nil
//    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
//    let callback: Callback? = nil
//
//    func makeUIViewController(context: Context) -> UIActivityViewController {
//        let controller = UIActivityViewController(
//            activityItems: activityItems,
//            applicationActivities: applicationActivities)
//        controller.excludedActivityTypes = excludedActivityTypes
//        controller.completionWithItemsHandler = callback
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
//        // nothing to do here
//    }
//}



struct CreateInviteView_Previews: PreviewProvider {
    static var previews: some View {
        CreateInviteView()
    }
}
