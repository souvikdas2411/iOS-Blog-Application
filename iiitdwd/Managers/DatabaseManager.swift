//
//  DatabaseManager.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import Foundation
//TODO: import FirebaseFirestore
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init() {
        
    }
    
    public func insert(
        with blogPost: BlogPost,
        user: User,
        completion: @escaping(Bool) -> Void) {
        
    }
    
    public func getAllPosts(
        completion: @escaping([BlogPost]) -> Void) {
        
    }
    
    public func getPosts(
        for user: User,
        completion: @escaping([BlogPost]) -> Void) {
        
    }
    
    public func insetUser(
        with user: User,
        completion: @escaping(Bool) -> Void) {
        
    }
    
    
}
