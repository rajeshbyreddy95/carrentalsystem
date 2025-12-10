package com.project.carrentalsystem.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;
import software.amazon.awssdk.core.sync.RequestBody;

import java.io.IOException;
import java.util.UUID;

@Service
@Slf4j
public class S3StorageService {

    @Value("${aws.s3.access-key}")
    private String accessKey;

    @Value("${aws.s3.secret-key}")
    private String secretKey;

    @Value("${aws.s3.bucket-name}")
    private String bucketName;

    @Value("${aws.s3.region}")
    private String region;

    @Value("${aws.s3.endpoint:https://s3.amazonaws.com}")
    private String endpoint;

    private S3Client s3Client;

    /**
     * Initialize AWS S3 Client
     */
    private synchronized S3Client getS3Client() {
        if (s3Client == null) {
            try {
                AwsBasicCredentials awsCreds = AwsBasicCredentials.create(accessKey, secretKey);
                
                s3Client = S3Client.builder()
                        .region(Region.of(region))
                        .credentialsProvider(StaticCredentialsProvider.create(awsCreds))
                        .build();
                
                log.info("✅ AWS S3 client initialized successfully");
            } catch (Exception e) {
                log.error("❌ Failed to initialize AWS S3 client: " + e.getMessage());
                throw new RuntimeException("AWS S3 initialization failed", e);
            }
        }
        return s3Client;
    }

    /**
     * Upload file to AWS S3 (for user documents)
     */
    public String uploadFile(MultipartFile file, String documentType, Long userId) {
        try {
            if (file == null || file.isEmpty()) {
                throw new IllegalArgumentException("File is empty");
            }

            // Generate unique filename
            String originalFileName = file.getOriginalFilename();
            String fileExtension = getFileExtension(originalFileName);
            String objectKey = generateObjectKey(userId, documentType, fileExtension);

            log.info("📤 Uploading file: {} to S3 bucket: {}", objectKey, bucketName);

            try {
                byte[] fileBytes = file.getBytes();
                
                log.info("📋 File details - Size: {} bytes, Type: {}", fileBytes.length, file.getContentType());
                
                PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                        .bucket(bucketName)
                        .key(objectKey)
                        .contentType(file.getContentType())
                        .build();

                log.info("📡 Sending request to AWS S3...");
                getS3Client().putObject(putObjectRequest, RequestBody.fromBytes(fileBytes));
                
                log.info("✅ File uploaded successfully: {}", objectKey);

                // Generate S3 URL
                String fileUrl = generateS3Url(objectKey);
                log.info("🔗 S3 URL: {}", fileUrl);
                
                return fileUrl;
            } catch (IOException e) {
                log.error("❌ File upload failed (IOException): {}", e.getMessage(), e);
                throw new RuntimeException("Failed to upload file to AWS S3", e);
            } catch (S3Exception s3Ex) {
                log.error("❌ AWS S3 Error - Code: {}, Message: {}", 
                    s3Ex.awsErrorDetails().errorCode(), s3Ex.getMessage());
                throw new RuntimeException("AWS S3 Error: " + s3Ex.getMessage(), s3Ex);
            }
        } catch (Exception e) {
            log.error("⚠️ Warning: File upload failed: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to upload file to AWS S3", e);
        }
    }

    /**
     * Upload file to AWS S3 (for cars)
     */
    public String uploadFile(MultipartFile file, String folderPath) {
        try {
            if (file == null || file.isEmpty()) {
                throw new IllegalArgumentException("File is empty");
            }

            // Generate unique filename
            String originalFileName = file.getOriginalFilename();
            String fileExtension = getFileExtension(originalFileName);
            String objectKey = folderPath + "/" + UUID.randomUUID().toString() + fileExtension;

            log.info("📤 Uploading file: {} to S3 bucket: {}", objectKey, bucketName);

            try {
                byte[] fileBytes = file.getBytes();
                
                log.info("📋 File details - Size: {} bytes, Type: {}", fileBytes.length, file.getContentType());
                
                PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                        .bucket(bucketName)
                        .key(objectKey)
                        .contentType(file.getContentType())
                        .build();

                log.info("📡 Sending request to AWS S3...");
                getS3Client().putObject(putObjectRequest, RequestBody.fromBytes(fileBytes));
                
                log.info("✅ File uploaded successfully: {}", objectKey);

                // Generate S3 URL
                String fileUrl = generateS3Url(objectKey);
                log.info("🔗 S3 URL: {}", fileUrl);
                
                return fileUrl;
            } catch (IOException e) {
                log.error("❌ File upload failed (IOException): {}", e.getMessage(), e);
                throw new RuntimeException("Failed to upload file to AWS S3", e);
            } catch (S3Exception s3Ex) {
                log.error("❌ AWS S3 Error - Code: {}, Message: {}", 
                    s3Ex.awsErrorDetails().errorCode(), s3Ex.getMessage());
                throw new RuntimeException("AWS S3 Error: " + s3Ex.getMessage(), s3Ex);
            }
        } catch (Exception e) {
            log.error("⚠️ Warning: File upload failed: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to upload file to AWS S3", e);
        }
    }

    /**
     * Download file from AWS S3
     */
    public byte[] downloadFile(String objectKey) {
        try {
            GetObjectRequest getObjectRequest = GetObjectRequest.builder()
                    .bucket(bucketName)
                    .key(objectKey)
                    .build();

            var getObjectResponse = getS3Client().getObject(getObjectRequest);
            
            log.info("📥 Downloaded file: {}", objectKey);
            
            return getObjectResponse.readAllBytes();
        } catch (IOException e) {
            log.error("❌ File download failed: {}", e.getMessage());
            throw new RuntimeException("Failed to download file from AWS S3", e);
        }
    }

    /**
     * Delete file from AWS S3
     */
    public void deleteFile(String objectKey) {
        try {
            getS3Client().deleteObject(
                    DeleteObjectRequest.builder()
                            .bucket(bucketName)
                            .key(objectKey)
                            .build()
            );
            log.info("✅ File deleted: {}", objectKey);
        } catch (Exception e) {
            log.error("❌ File deletion failed: {}", e.getMessage());
        }
    }

    /**
     * Generate unique object key
     */
    private String generateObjectKey(Long userId, String documentType, String extension) {
        return String.format("users/%d/%s/%s%s", 
                userId, 
                documentType, 
                UUID.randomUUID().toString(),
                extension);
    }

    /**
     * Get file extension
     */
    private String getFileExtension(String fileName) {
        if (fileName != null && fileName.contains(".")) {
            return "." + fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
        }
        return ".bin";
    }

    /**
     * Generate S3 URL for the uploaded file
     */
    private String generateS3Url(String objectKey) {
        // Format: https://bucket-name.s3.region.amazonaws.com/object-key
        return String.format("https://%s.s3.%s.amazonaws.com/%s",
                bucketName,
                region,
                objectKey);
    }

    /**
     * Cleanup: Close S3 client
     */
    public void closeClient() {
        if (s3Client != null) {
            s3Client.close();
            log.info("AWS S3 client closed");
        }
    }
}
