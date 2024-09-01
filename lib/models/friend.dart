import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Friend {
  final String id; // 문서 ID (친구의 userId)
  final String status;

  Friend({
    required this.id,
    required this.status,
  });

  factory Friend.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Friend(
      id: doc.id, // 문서 ID를 친구의 ID로 사용
      status: data['status'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'status': status,
    };
  }
}