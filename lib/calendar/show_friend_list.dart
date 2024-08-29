import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ShowFriendList extends StatelessWidget {
  const ShowFriendList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('friends')
          .where('userId', isEqualTo: currentUserId)
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
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var friendData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              String friendId = friendData['friendId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (userSnapshot.hasError) {
                    return Text('Error: ${userSnapshot.error}');
                  }

                  var userData = userSnapshot.data!.data() as Map<String, dynamic>? ?? {};
                  String profilePath = userData['profilePath'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Navigate to user's plan page
                        print('Tapped on user ${userData['name']}');
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: profilePath.isNotEmpty
                            ? CachedNetworkImageProvider(profilePath)
                            : null,
                        child: profilePath.isEmpty
                            ? Icon(Icons.person, size: 30)
                            : null,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}