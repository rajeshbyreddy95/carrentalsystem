package com.project.carrentalsystem.service;

import com.oracle.bmc.Region;
import com.oracle.bmc.auth.ConfigFileAuthenticationDetailsProvider;
import com.oracle.bmc.objectstorage.ObjectStorageClient;
import com.oracle.bmc.objectstorage.requests.DeleteObjectRequest;
import com.oracle.bmc.objectstorage.requests.GetObjectRequest;
import com.oracle.bmc.objectstorage.requests.PutObjectRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;

@Service
@Slf4j
public class OciStorageService {

    @Value("${oci.config-path}")
    private String configPath;

    @Value("${oci.config-profile}")
    private String configProfile;

    @Value("${oci.namespace}")
    private String namespace;

    @Value("${oci.bucket}")
    private String bucket;

    @Value("${oci.region}")
    private String region;

    private ObjectStorageClient objectStorageClient;

    /**
     * Initialize OCI Object Storage Client
     */
    private synchronized ObjectStorageClient getObjectStorageClient() {
        if (objectStorageClient == null) {
            try {
                ConfigFileAuthenticationDetailsProvider provider = 
                    new ConfigFileAuthenticationDetailsProvider(configPath, configProfile);
                
                objectStorageClient = ObjectStorageClient.builder()
                        .region(Region.fromRegionCodeOrId(region))
                        .build(provider);
                
                log.info("✅ OCI Object Storage client initialized successfully");
            } catch (Exception e) {
                log.error("❌ Failed to initialize OCI Object Storage client: " + e.getMessage());
                throw new RuntimeException("OCI Storage initialization failed", e);
            }
        }
        return objectStorageClient;
    }

    /**
     * Upload file to OCI Object Storage
     */
    public String uploadFile(MultipartFile file, String documentType, Long userId) {
        try {
            if (file == null || file.isEmpty()) {
                throw new IllegalArgumentException("File is empty");
            }

            // Generate unique filename
            String originalFileName = file.getOriginalFilename();
            String fileExtension = getFileExtension(originalFileName);
            String objectName = generateObjectName(userId, documentType, fileExtension);

            log.info("📤 Uploading file: {} to OCI bucket: {}", objectName, bucket);

            // Upload to OCI - Buffer the stream to support mark/reset for retries
            try {
                // Read file into byte array to avoid stream issues with retries
                byte[] fileBytes = file.getBytes();
                
                log.info("📋 File details - Size: {} bytes, Type: {}", fileBytes.length, file.getContentType());
                
                PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                        .namespaceName(namespace)
                        .bucketName(bucket)
                        .objectName(objectName)
                        .contentLength((long) fileBytes.length)
                        .putObjectBody(new java.io.ByteArrayInputStream(fileBytes))
                        .contentType(file.getContentType())
                        .build();

                log.info("📡 Sending request to OCI...");
                getObjectStorageClient().putObject(putObjectRequest);
                
                log.info("✅ File uploaded successfully: {}", objectName);

                // Generate public URL
                String publicUrl = generatePublicUrl(objectName);
                log.info("🔗 Public URL: {}", publicUrl);
                
                return publicUrl;
            } catch (IOException e) {
                log.error("❌ File upload failed (IOException): {}", e.getMessage(), e);
                throw new RuntimeException("Failed to upload file to OCI Storage", e);
            } catch (com.oracle.bmc.model.BmcException bmcEx) {
                log.error("❌ OCI API Error - Status: {}, Code: {}, Message: {}", 
                    bmcEx.getStatusCode(), bmcEx.getServiceCode(), bmcEx.getMessage());
                log.error("Full error:", bmcEx);
                throw new RuntimeException("OCI API Error: " + bmcEx.getMessage(), bmcEx);
            }
        } catch (Exception e) {
            log.error("⚠️ Warning: File upload failed: {}", e.getMessage(), e);
            log.error("Exception type: {}", e.getClass().getName());
            if (e.getCause() != null) {
                log.error("Caused by: {} - {}", e.getCause().getClass().getName(), e.getCause().getMessage());
            }
            throw new RuntimeException("Failed to upload file to OCI Storage", e);
        }
    }

    /**
     * Upload file to OCI Object Storage (for cars)
     */
    public String uploadFile(MultipartFile file, String folderPath) {
        try {
            if (file == null || file.isEmpty()) {
                throw new IllegalArgumentException("File is empty");
            }

            // Generate unique filename
            String originalFileName = file.getOriginalFilename();
            String fileExtension = getFileExtension(originalFileName);
            String objectName = folderPath + "/" + UUID.randomUUID().toString() + fileExtension;

            log.info("📤 Uploading file: {} to OCI bucket: {}", objectName, bucket);

            // Upload to OCI
            try {
                byte[] fileBytes = file.getBytes();
                
                log.info("📋 File details - Size: {} bytes, Type: {}", fileBytes.length, file.getContentType());
                
                PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                        .namespaceName(namespace)
                        .bucketName(bucket)
                        .objectName(objectName)
                        .contentLength((long) fileBytes.length)
                        .putObjectBody(new java.io.ByteArrayInputStream(fileBytes))
                        .contentType(file.getContentType())
                        .build();

                log.info("📡 Sending request to OCI...");
                getObjectStorageClient().putObject(putObjectRequest);
                
                log.info("✅ File uploaded successfully: {}", objectName);

                // Generate public URL
                String publicUrl = generatePublicUrl(objectName);
                log.info("🔗 Public URL: {}", publicUrl);
                
                return publicUrl;
            } catch (IOException e) {
                log.error("❌ File upload failed (IOException): {}", e.getMessage(), e);
                throw new RuntimeException("Failed to upload file to OCI Storage", e);
            } catch (com.oracle.bmc.model.BmcException bmcEx) {
                log.error("❌ OCI API Error - Status: {}, Code: {}, Message: {}", 
                    bmcEx.getStatusCode(), bmcEx.getServiceCode(), bmcEx.getMessage());
                throw new RuntimeException("OCI API Error: " + bmcEx.getMessage(), bmcEx);
            }
        } catch (Exception e) {
            log.error("⚠️ Warning: File upload failed: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to upload file to OCI Storage", e);
        }
    }

    /**
     * Download file from OCI Object Storage
     */
    public byte[] downloadFile(String objectName) {
        try {
            GetObjectRequest getObjectRequest = GetObjectRequest.builder()
                    .namespaceName(namespace)
                    .bucketName(bucket)
                    .objectName(objectName)
                    .build();

            var getObjectResponse = getObjectStorageClient().getObject(getObjectRequest);
            
            log.info("📥 Downloaded file: {}", objectName);
            
            return getObjectResponse.getInputStream().readAllBytes();
        } catch (IOException e) {
            log.error("❌ File download failed: {}", e.getMessage());
            throw new RuntimeException("Failed to download file from OCI Storage", e);
        }
    }

    /**
     * Delete file from OCI Object Storage
     */
    public void deleteFile(String objectName) {
        try {
            getObjectStorageClient().deleteObject(
                    DeleteObjectRequest.builder()
                            .namespaceName(namespace)
                            .bucketName(bucket)
                            .objectName(objectName)
                            .build()
            );
            log.info("✅ File deleted: {}", objectName);
        } catch (Exception e) {
            log.error("❌ File deletion failed: {}", e.getMessage());
        }
    }

    /**
     * Generate unique object name
     */
    private String generateObjectName(Long userId, String documentType, String extension) {
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
     * Generate public URL for the uploaded file
     */
    private String generatePublicUrl(String objectName) {
        return String.format("https://objectstorage.%s.oraclecloud.com/n/%s/b/%s/o/%s",
                region.toLowerCase(),
                namespace,
                bucket,
                objectName.replace("/", "%2F"));
    }

    /**
     * Cleanup: Close OCI client
     */
    public void closeClient() {
        if (objectStorageClient != null) {
            objectStorageClient.close();
            log.info("OCI Object Storage client closed");
        }
    }
}
