//
//  SignOutView.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 20.09.2022.
//

import SwiftUI

struct SignOutView: View {
    @StateObject var store: SignOutStore

    var body: some View {
        VStack {
            // if you want, you can change it to store.user and show properties from BE
            // don't forget to unwrap option property User
            Text("ID")
            Text("title")
            Text("completed")
            Button("Sign Out") {
                print("I just tapped on button")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
        .onAppear(perform: load)
    }

    func load() {
        Task {
            await store.fetch()
        }
    }
}

struct SignOutView_Previews: PreviewProvider {
    static var previews: some View {
        SignOutView(store: SignOutStore(validationManager: ValidationManager(), apiManager: APIManager()))
    }
}
