class FirebaseStorageErrorHandler {
  FirebaseStorageErrorHandler._();

  static String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'storage/unknown':
        return 'An unknown error occurred. Please try again later.';
      case 'storage/object-not-found':
        return 'No object exists at the desired reference. The file might have been deleted or never uploaded.';
      case 'storage/bucket-not-found':
        return 'No bucket is configured for Cloud Storage. Please check your Firebase setup.';
      case 'storage/project-not-found':
        return 'No project is configured for Cloud Storage. Please check your Firebase project settings.';
      case 'storage/quota-exceeded':
        return 'Quota on your Cloud Storage bucket has been exceeded. If on Spark plan, consider upgrading to Blaze.';
      case 'storage/unauthenticated':
        return 'User is unauthenticated. Please authenticate and try again.';
      case 'storage/unauthorized':
        return 'User is not authorized. Check your security rules to ensure the user has appropriate permissions.';
      case 'storage/retry-limit-exceeded':
        return 'The operation has been retried too many times. Please try uploading again.';
      case 'storage/invalid-checksum':
        return 'The file on the client does not match the checksum of the file received by the server. Try uploading again.';
      case 'storage/canceled':
        return 'The user canceled the upload. Please try again if needed.';
      case 'storage/invalid-event-name':
        return 'Invalid event name provided. Valid event names are [running, progress, pause].';
      case 'storage/invalid-url':
        return 'Invalid URL format. Ensure the URL is correct, either gs://bucket/object or https://firebasestorage.googleapis.com/...';
      case 'storage/invalid-argument':
        return 'Invalid argument passed. The file or data type must be a File, Blob, or UInt8 Array.';
      case 'storage/no-default-bucket':
        return 'No bucket has been set in your config. Ensure you have set a storage bucket in Firebase configuration.';
      case 'storage/cannot-slice-blob':
        return 'The file might have changed locally. Try uploading again after verifying that the file is intact.';
      case 'storage/server-file-wrong-size':
        return 'The file size on the client does not match the size received by the server. Try uploading again.';
      default:
        return 'An unknown error occurred. Please check your network or Firebase settings.';
    }
  }
}
