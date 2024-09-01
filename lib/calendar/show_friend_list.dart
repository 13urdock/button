import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:danchu/profile_image_utils.dart';

class ShowFriendList extends StatelessWidget {
  const ShowFriendList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserId)
            .collection('friends')
            .where('status', isEqualTo: 'accepted')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return Container(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var friendData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                String friendId = friendData['friendId'];

                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .where('id', isEqualTo: friendId)
                      .limit(1)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (userSnapshot.hasError) {
                      return Text('Error: ${userSnapshot.error}');
                    }
                    if (userSnapshot.data == null || userSnapshot.data!.docs.isEmpty) {
                      return Text('User not found');
                    }

                    var userData = userSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                    String profilePath = userData['profilePath'] ?? '';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Navigate to user's plan page
                          print('Tapped on user ${userData['nickname']}');
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: profilePath.isNotEmpty
                                ? CachedNetworkImageProvider(profilePath)
                                : null,
                            child: profilePath.isEmpty
                                ? Icon(Icons.person, size: 30)
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      )
    );
  }
}