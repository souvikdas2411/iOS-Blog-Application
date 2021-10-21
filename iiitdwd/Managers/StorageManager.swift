//
//  StorageManager.swift
//  iiitdwd
//
//  Created by Souvik Das on 21/10/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    
    private let container = Storage.storage().reference()
    
    private init() {
        
    }
    
    public func uploadUserProfilePicture(
        email: String,
        image: UIImage,
        completion: @escaping (Bool) -> Void){
        
    }
    
    public func uploadBlogHeaderImage(
        blogPost: BlogPost,
        image: UIImage,
        completion: @escaping (Bool) -> Void){
        
    }
    
    public func downloadUrlForProfilePicture(
        user: User,
        completion: @escaping (URL?) -> Void){
        
    }
    
    public func downloadUrlForPostHeader(
        blogPost: BlogPost,
        completion: @escaping (URL?) -> Void){
        
    }
}
