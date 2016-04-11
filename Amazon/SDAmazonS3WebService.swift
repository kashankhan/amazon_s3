//
//  SDAmazonS3WebService.swift
//  ShreddDemand
//
//  Created by Kabir on 20/10/2015.
//  Copyright © 2015 Folio3. All rights reserved.
//

import Foundation
import AWSCore

class SDAmazonS3WebService {

    private var s3BucketName: String!
    private var amazonBaseUri: String!
    private var awsUploadService: SDAmazonS3UploadWebService!
    private var awsDownloadService: SDAmazonS3DownloadWebService!
    
    /**
    new instance of SDAmazonS3WebService
    
    - Parameter amazonBaseUri: amazon base uri
    - Parameter s3 Bucket Name: created on amazon
    - Parameter accessKey: Provided by amazon
    - Parameter secretKey: Provided by amazon
    - Parameter defaultServiceRegionType: Region of service.
    
    - Throws: nil
    
    - Returns: new instance of SDAmazonS3WebService
    */
    

    required init(amazonBaseUri: String, s3BucketName: String!, accessKey: String, secretKey: String, defaultServiceRegionType: Int) {
        self.amazonBaseUri = amazonBaseUri
        self.s3BucketName = s3BucketName
        let region = AWSRegionType (rawValue: defaultServiceRegionType)!
        self.setupManager(accessKey, secretKey: secretKey, defaultServiceRegionType: region)
        self.setupServices()
    }
    
    /**
    Setting up Amazon web service manager
    
    - Parameter accessKey: Provided by amazon
    - Parameter secretKey: Provided by amazon
    - Parameter defaultServiceRegionType: Region of service.
    
    
    - Throws: nil
    
    - Returns: nil
    */
    
    private func setupManager(accessKey: String, secretKey: String, defaultServiceRegionType: AWSRegionType) {
        let credentialsProvider =  AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(region: defaultServiceRegionType, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.defaultServiceManager().defaultServiceConfiguration = configuration
    }
    
    /**
    setting up services.
    
    - Throws: nil
    
    - Returns: nil
    */
    
    private func setupServices() {
        self.awsDownloadService = SDAmazonS3DownloadWebService(amazonBaseUri: self.amazonBaseUri, bucket: self.s3BucketName)
        self.awsUploadService = SDAmazonS3UploadWebService(amazonBaseUri: self.amazonBaseUri, bucket: self.s3BucketName)
    }
    
    /**
   Upload file on Amazon S3
    
    - Parameter url: file url
    - Parameter key: Path where data needs to be reside. Optional parameter if key is nil resource will be upload on root.
    - Parameter completion: Get from amazon cognito console
    
    - Throws: nil
    
    - Returns: create request SDAWSS3TransferManagerUploadRequest
    */
    func upload(url: NSURL, key: String?, completion: SDAS3WSCompletionCallback) -> SDAWSS3TransferManagerUploadRequest {
      return self.awsUploadService.upload(url, key: key, completion: completion)
    }
    
    /**
    download content from Amazon S3
    
    - Parameter image: file url
    - Parameter completion: Get from amazon cognito console
    
    - Throws: nil
    
    - Returns: create request SDAWSS3TransferManagerDownloadRequest
    */
    func download(url: NSURL, completion: SDAS3WSCompletionCallback) -> SDAWSS3TransferManagerDownloadRequest {
        return self.awsDownloadService.download(url, completion: completion)
    }
}