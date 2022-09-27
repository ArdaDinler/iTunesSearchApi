//
//  ListViewModel.swift
//  iTunesSearchApi
//
//  Created by Arda Dinler on 27.09.2022.
//

import Foundation
import Combine
import Kingfisher
import UIKit.UIImage

class ViewModel {
    //MARK: Enum Types
    enum ImageSize: Int {
        case below100KB
        case below250KB
        case below500KB
        case upper500KB
    }

    enum ImageType: String {
        case jpeg
        case png
    }

    //MARK: - Properties
    @Published var sections: [Section]?

    let maxDownloadImageCountAtTime = 3
    var pictureUrls = [String]()
    var service: ServiceProtocol?

    var searchQuery: String = "" {
        didSet {
            search(query: searchQuery)
        }
    }

    //MARK: - Init
    init(service: ServiceProtocol = Service.shared) {
        self.service = service
    }

    //MARK: - Methods
    func createNewSections() {
        sections = [
            Section(title: "0-100kb", pictures: []),
            Section(title: "100-250kb", pictures: []),
            Section(title: "250-500kb", pictures: []),
            Section(title: "500+kb", pictures: [])
        ]
    }

    /// This function be used for getting total number of pictures count from the all sections
    func getAllSectionPicturesCount() -> Int {
        if let array = (sections?.flatMap { $0.pictures }) {
            return array.count
        }
        return 0
    }

    /// This function for getting itunes software screenshot ulrs by using search query
    ///
    /// - Parameters:
    ///     - query: It is used for the word to be queried in itunes search api
    ///     - success: Successful response completion handler for the queried request
    ///     - failure: Incorrect response completion handler for the queried request
    ///
    func search(query: String,
                success: ((_ result: ResponseModel) -> Void)? = nil,
                failure: ((_ error: ErrorModel) -> Void)? = nil) {

        service?.search(query: query, success: { [weak self] (data) in
            if let strongSelf = self,
                let results = data.results {
                strongSelf.pictureUrls = (results.compactMap { $0.screenshotUrls }).flatMap { $0 }
                if strongSelf.pictureUrls.isEmpty {
                    strongSelf.sections = []
                } else {
                    strongSelf.downloadImages(images: strongSelf.pictureUrls)
                }
            } else {
                print("Error occured while assigning parsed data.")
            }

        }, failure: { [weak self] (error) in
            print(error.localizedDescription)
            guard let strongSelf = self else { return }
            strongSelf.sections = []
        })
    }

    /// This function download all images according to screenshotUrls of content data previously have gotten.
    ///
    ///> Info: You can change maxDownloadImageCountAtTime. If you increase this property, you can download more images async.
    ///
    /// - Parameters:
    ///     - images: The url strings of the images to be pulled from the server
    ///
    func downloadImages(images: [String]) {
        createNewSections()

        let downloadQueue = DispatchQueue.global(qos: .userInitiated)
        let downloadGroup = DispatchGroup()
        let downloadSemaphore = DispatchSemaphore(value: maxDownloadImageCountAtTime)

        downloadQueue.async() { [weak self] in
            guard let strongSelf = self else { return }

            for (_, image) in images.enumerated() {
                downloadGroup.enter()
                downloadSemaphore.wait()
                strongSelf.getImage(imageUrl: image, downloadGroup: downloadGroup, downloadSemaphore: downloadSemaphore)
            }

            downloadGroup.notify(queue: DispatchQueue.main) {}
        }
    }

    /// This function gets image according to url from remote server by using Kingfisher framework.
    ///
    /// ```
    /// This function also caches images by using image url for the cache key to be more performent.
    /// ```
    ///> Warning: Always number of  enter and wait count to be equal to leave and signal count
    ///
    /// - Parameters:
    ///     - imageUrl: The url of the image to be pulled from the server
    ///     - downloadGroup: Using parameter for leaving from group when image is dowloaded
    ///     - downloadSemaphore: Using parameter for signaling when image is dowloaded
    ///
    func getImage(imageUrl: String, downloadGroup: DispatchGroup, downloadSemaphore: DispatchSemaphore) {
        if let targetUrl = URL(string: imageUrl) {
            // profileImage.kf.indicatorType = .activity
            let imgSrc = ImageResource(downloadURL: targetUrl, cacheKey: imageUrl)
            KingfisherManager.shared.retrieveImage(with: imgSrc, options: nil, progressBlock: nil) { [weak self] result in
                guard let strongSelf = self,
                      let sections = strongSelf.sections,
                      !sections.isEmpty,
                      !strongSelf.searchQuery.isEmpty,
                      strongSelf.pictureUrls.contains(imageUrl) else { return }
                switch result {
                case .success(let value):
                    print("Image: \(value.image). Got from: \(value.cacheType)")
                    let imageType: ImageType = imageUrl.contains(".jpg") || imageUrl.contains(".jpeg") ? .jpeg : .png
                    switch strongSelf.getImageSizeCat(image: value.image, type: imageType) {
                    case .below100KB:
                        sections[0].pictures.append(Picture(thumbnail: value.image))
                    case .below250KB:
                        sections[1].pictures.append(Picture(thumbnail: value.image))
                    case .below500KB:
                        sections[2].pictures.append(Picture(thumbnail: value.image))
                    case .upper500KB:
                        sections[3].pictures.append(Picture(thumbnail: value.image))
                    }
                    strongSelf.sections = sections
                    downloadGroup.leave()
                    downloadSemaphore.signal()
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        } else {
            downloadGroup.leave()
            downloadSemaphore.signal()
        }
    }

    /// This function finds image size according to type of image. Then return image size category by this calculation
    ///
    /// ```
    /// getImageSizeCat(image: image, type .jpg)
    /// ```
    ///
    /// > Warning: The other type of image (excluding jpeg, jpg, png) is not taken into account. For feature development, be awera of this.
    ///
    /// - Parameters:
    ///     - image: The picture to be calculated.
    ///     - type: the type of picture. Ex: jpeg, jpg or png
    ///
    /// - Returns: Four range of category according to app`ImageSize`.
    func getImageSizeCat(image: UIImage, type: ImageType) -> ImageSize {
        guard let data = type == .jpeg ? image.jpegData(compressionQuality: 1.0) : image.pngData() else { return .below100KB }
        let imgData = NSData(data: data)
        let imageSize: Int = imgData.count
        let cat = Double(imageSize) / 1024.0
        switch cat {
        case 0..<100:
            return .below100KB
        case 100..<250:
            return .below250KB
        case 250..<500:
            return .below500KB
        default:
            return .upper500KB
        }
    }
}
