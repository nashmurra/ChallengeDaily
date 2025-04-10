//
//  ImageUploader.swift
//  ChallengeDaily
//
//  Created by Nash Murra on 3/6/25.
//
import FirebaseFirestore
import UIKit

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        // Convert the image to JPEG data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("DEBUG: Failed to compress image")
            completion(nil)
            return
        }

        // Encode the image data as a Base64 string
        let base64String = imageData.base64EncodedString()
        completion(base64String)
    }
}

