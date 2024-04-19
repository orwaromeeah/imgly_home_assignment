//
//  PhotoCollectionViewController.swift
//  imgly_home_assignment
//
//  Created by Orwa Romeeah on 4/19/24.
//

import UIKit


class PhotoCollectionViewController: UICollectionViewController{
    var images: [UIImage] = []
    var Sortedimages :[UIImage]=[]
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionviewwidth = collectionView.frame.width
        let itemWidth = (collectionviewwidth -  CGFloat(1))/4
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        downloadImages()
    }
    
//MARK: UIColloectionViewControllerDataSource :
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image_cell", for: indexPath) as! photoCollectionViewCell
        cell.source = Sortedimages[indexPath.item]
        
        return cell
    }
    
    func downloadImages() {
        for index in 0..<16 {
            let urlString = "https://img.ly/static/pvesdk-student-tha/\(index).png"
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                   
                        DispatchQueue.main.async {
                            print(image.greennessOfFirstPixel())
                           self.images.append(image)
                            if(self.images.count==16){
                                self.Sortedimages = bubbleSortImagesByGreenness(self.images)
                                self.collectionView.reloadData()
                            }
                        }
                    } else {
                        print("Failed to download image: \(index)")
                    }
                }.resume()
            }
        }
    }


}



func bubbleSortImagesByGreenness(_ images: [UIImage]) -> [UIImage] {
    // Bubble sort images by greenness
    var sortedImages = images
    
    for i in 0..<sortedImages.count {
        for j in 1..<sortedImages.count - i {
            let greenness1 = sortedImages[j-1].greennessOfFirstPixel()
            let greenness2 = sortedImages[j].greennessOfFirstPixel()
            
            if greenness1 < greenness2 {
                // Swap
                let temp = sortedImages[j-1]
                sortedImages[j-1] = sortedImages[j]
                sortedImages[j] = temp
            }
        }
    }
    
    // Return sorted images
    return sortedImages
}


//MARK: UIColloectionViewControllerDataSource :

extension UIImage {
    func greennessOfFirstPixel() -> CGFloat {
        guard let cgImage = self.cgImage else { return 0 }
        
        let width = cgImage.width
        let height = cgImage.height
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let rawData = UnsafeMutablePointer<UInt8>.allocate(capacity: bytesPerRow * height)
        
        defer {
            rawData.deallocate()
        }
        
        let context = CGContext(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue)
        
        guard let imageContext = context else { return 0 }
        
        imageContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let pixel = rawData
        let red = CGFloat(pixel[0]) / 255.0
        let green = CGFloat(pixel[1]) / 255.0
        let blue = CGFloat(pixel[2]) / 255.0
        
        // Calculate greenness of the first pixel
        return green / (red + green + blue)
    }
}





