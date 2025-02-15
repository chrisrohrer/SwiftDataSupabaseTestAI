//
//  ViewModel.swift
//  SupaFeatures
//
//  Created by Mikaela Caron on 7/23/23.
//

import Foundation
import Supabase
import Realtime
import SwiftUI


//@MainActor
final class AuthVM: ObservableObject {
    
    static let shared = AuthVM()
    
    @Published var userId: UUID? = nil
    @Published var user: String? = nil

    @Published var loggedInFullName: String? = nil

    @Published var isLoading: Bool = true

    var isAuthenticated: Bool {
        userId != nil
    }
        
    init() {
        subscribeToAuthChanges()
    }
    
    
    // MARK: - Authentication
        
    func subscribeToAuthChanges() {
        Task { @MainActor in
            for await state in supabase.auth.authStateChanges {
                if [.initialSession, .signedIn, .signedOut].contains(state.event) {
                    Task { @MainActor in
                        
                        let role = state.session?.user.role
                        let user = state.session?.user.email
                        
                        self.userId = state.session?.user.id
                        self.user = state.session?.user.email
                        
                        print("Users Auth changed:", state.event, isAuthenticated)
                        print("AuthVM **** Role:", role as Any, "user:", user as Any, "userId:", self.userId as Any)
                        self.isLoading = false

                    }
                }
            }
        }
    }
    
    func signIn(email: String, password: String) {
        Task {
            do {
                _ = try await supabase.auth.signIn(email: email, password: password)
            } catch {
                print(#function, error.localizedDescription)
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try await supabase.auth.signOut()
            } catch {
                print(#function, error.localizedDescription)
            }
        }
    }
}
