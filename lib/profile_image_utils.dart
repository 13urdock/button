import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> uploadProfileImage(File imageFile) async {
  try {
    // 현재 사용자의 ID를 가져옵니다.
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    // Firebase Storage의 참조를 생성합니다.
    final storageRef = FirebaseStorage.instance.ref();
    
    // 'profile' 폴더 내에 사용자 ID를 파일 이름으로 사용하여 이미지를 저장합니다.
    final profileImageRef = storageRef.child('profile/$userId.jpg');

    // 이미지를 업로드합니다.
    await profileImageRef.putFile(imageFile);

    // 업로드된 이미지의 다운로드 URL을 가져옵니다.
    final downloadURL = await profileImageRef.getDownloadURL();

    // Firestore의 사용자 문서에 profilePath를 업데이트합니다.
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'profilePath': downloadURL});

    return downloadURL;
  } catch (e) {
    print('Error uploading profile image: $e');
    return null;
  }
}

// 이 함수를 호출하여 갤러리에서 이미지를 선택하고 업로드합니다.
Future<void> pickAndUploadProfileImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
    String? downloadURL = await uploadProfileImage(imageFile);
    
    if (downloadURL != null) {
      print('Profile image uploaded successfully. URL: $downloadURL');
    } else {
      print('Failed to upload profile image.');
    }
  } else {
    print('No image selected.');
  }
}