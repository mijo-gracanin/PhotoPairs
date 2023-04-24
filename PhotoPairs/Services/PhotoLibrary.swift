//
//  PhotoLibrary.swift
//  PhotoPairs
//
//  Created by Mijo Gracanin on 12.03.2023..
//

import Foundation
import Photos
import UIKit

protocol PhotoLibrary {
    @MainActor func getRandomPhotos(width: CGFloat, height: CGFloat, limit: Int) async -> Result<[UIImage], AuthorizationError>
}

enum AuthorizationError: Error {
    case insufficientPhotoLibraryAccess
}

struct ProdPhotoLibrary: PhotoLibrary {
    func getRandomPhotos(width: CGFloat, height: CGFloat, limit: Int) async -> Result<[UIImage], AuthorizationError> {
        var authorizationStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if authorizationStatus != .authorized {
            authorizationStatus = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            guard authorizationStatus == .authorized || authorizationStatus == .limited else {
                return .failure(.insufficientPhotoLibraryAccess)
            }
        }
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        let count = fetchResult.count > limit ? limit : fetchResult.count
        
        let randomIndices = generateDistinctRanodmInts(inRange: fetchResult.count, count: count)
        
        var images = [UIImage]()
        
        for idx in 0..<count {
            let asset = fetchResult.object(at: randomIndices[idx])
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: width, height: height),
                contentMode: .aspectFit,
                options: nil
            ) { image, info in
                guard let image = image, let isDegraded = info?[PHImageResultIsDegradedKey] as? NSNumber else {
                    fatalError("\(info ?? [:])")
                }
                
                guard !isDegraded.boolValue else {
                    return
                }
                
                images.append(image)
            }
        }
        
        return .success(images)
    }
    
    private func generateDistinctRanodmInts(inRange rangeMax: Int, count: Int) -> [Int] {
        var availableInts = Array<Int>(repeating: -1, count: rangeMax)
        var randomInts = [Int]()
        
        for _ in 0..<rangeMax {
            let idx = Int.random(in: 0..<availableInts.count)
            if availableInts[idx] > -1 {
                randomInts.append(availableInts[idx])
            } else {
                randomInts.append(idx)
            }
            availableInts[idx] = availableInts.last! > -1 ? availableInts.last! : availableInts.endIndex - 1
            _ = availableInts.popLast()
        }
        return randomInts
    }
}

struct MockPhotoLibrary: PhotoLibrary {
    func getRandomPhotos(width: CGFloat, height: CGFloat, limit: Int) async -> Result<[UIImage], AuthorizationError> {
        return .success([UIImage(systemName: "trash.fill")!,
                         UIImage(systemName: "folder.fill")!,
                         UIImage(systemName: "scribble.variable")!,
                         UIImage(systemName: "lasso.and.sparkles")!,
                         UIImage(systemName: "paperplane.fill")!,
                         UIImage(systemName: "doc.text.below.ecg.fill")!,
                         UIImage(systemName: "terminal")!,
                         UIImage(systemName: "book.fill")!
                        ])
    }
}
