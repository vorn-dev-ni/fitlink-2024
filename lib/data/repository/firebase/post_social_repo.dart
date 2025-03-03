// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/service/firestore/base_service.dart';
import 'package:demo/features/home/model/post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostSocialRepo {
  late BaseSocialMediaService baseSocialMediaService;
  PostSocialRepo({
    required this.baseSocialMediaService,
  });
  Future deletePost(String postId) async {
    try {
      return await baseSocialMediaService.deletePost(postId);
    } catch (e) {
      rethrow;
    }
  }

  Stream<Post> listenToPost(String postId) {
    try {
      return baseSocialMediaService.getPostSocial(postId).map(
        (event) {
          if (event.exists) {
            return Post.fromJson(event.data() as Map<String, dynamic>);
          }
          return Post();
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future addPost(Post post) async {
    try {
      return await baseSocialMediaService.addPost(post.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getTotalPosts() async {
    try {
      return await baseSocialMediaService.getTotalPosts();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Post>?> getOneTimePosts(String uid, int? pageSize) async {
    try {
      final snapShot =
          await baseSocialMediaService.getAllPostOneTime(pageSize ?? 8);
      if (snapShot.size <= 0) {
        return null;
      }

      List<Post> posts = await Future.wait(
        snapShot.docs.map((doc) async {
          Map<String, dynamic> postData = doc.data();
          DocumentReference? userRef = postData['userId'] as DocumentReference?;

          Map<String, dynamic>? userData =
              userRef != null ? await extractUserData(userRef) : null;

          bool isLiked = await checkUserLikePost(doc.id);

          return Post.fromJson({
            "postId": doc.id,
            "userLiked": isLiked,
            "likesCount": postData['likesCount'],
            "user": userData,
            "imageUrl": postData['imageUrl'],
            "caption": postData['caption'],
            "commentsCount": postData['commentsCount'],
            "tag": postData['tag'],
            "createdAt": postData['createdAt'],
            "type": postData['type'],
            "emoji": postData['emoji'],
            "feeling": postData['feeling'],
            'formattedCreatedAt': postData['createdAt'],
          });
        }).toList(),
      );

      return posts;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Post>?> getAllUserPost(String uid) {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        return baseSocialMediaService
            .getPostByUser(uid)
            .asyncMap((snapshot) async {
          List<Post> posts = await Future.wait(snapshot.docs.map((doc) async {
            if (doc.exists) {
              Map<String, dynamic> postData = doc.data();
              DocumentReference? userRef =
                  postData['userId'] as DocumentReference?;
              Map<String, dynamic>? userData =
                  userRef != null ? await extractUserData(userRef) : null;
              bool isLiked = await checkUserLikePost(doc.id);
              return Post.fromJson({
                "postId": doc.id,
                "userLiked": isLiked,
                "likesCount": doc.data()['likesCount'],
                "user": userData,
                "imageUrl": doc.data()['imageUrl'],
                "caption": doc.data()['caption'],
                "commentsCount": doc.data()['commentsCount'],
                "tag": doc.data()['tag'],
                "createdAt": doc.data()['createdAt'],
                "type": doc.data()['type'],
                "emoji": doc.data()['emoji'],
                "feeling": doc.data()['feeling'],
                'formattedCreatedAt': doc.data()['createdAt'],
              });
            }

            return Post();
          }));
          return posts;
        });
      }

      return const Stream.empty();
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Post>?> getAllPostV2(String? uid, int? pageSize) {
    try {
      return baseSocialMediaService
          .getHybridFeedWithPagination(uid, pageSize ?? 6)
          .asyncMap((snapshot) async {
        List<Post> posts = await Future.wait(snapshot.docs.map((doc) async {
          if (doc.exists) {
            Map<String, dynamic> postData = doc.data();
            DocumentReference? userRef =
                postData['userId'] as DocumentReference?;
            Map<String, dynamic>? userData =
                userRef != null ? await extractUserData(userRef) : null;
            bool isLiked = await checkUserLikePost(doc.id);
            return Post.fromJson({
              "postId": doc.id,
              "userLiked": isLiked,
              "likesCount": doc.data()['likesCount'],
              "user": userData,
              "imageUrl": doc.data()['imageUrl'],
              "caption": doc.data()['caption'],
              "commentsCount": doc.data()['commentsCount'],
              "tag": doc.data()['tag'],
              "createdAt": doc.data()['createdAt'],
              "type": doc.data()['type'],
              "emoji": doc.data()['emoji'],
              "feeling": doc.data()['feeling'],
              'formattedCreatedAt': doc.data()['createdAt'],
            });
          }

          return Post();
        }));
        return posts;
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Post>?> getAllPosts() {
    try {
      return baseSocialMediaService.getAllPosts().asyncMap((snapshot) async {
        List<Post> posts = await Future.wait(snapshot.docs.map((doc) async {
          if (doc.exists) {
            Map<String, dynamic> postData = doc.data();
            DocumentReference? userRef =
                postData['userId'] as DocumentReference?;
            Map<String, dynamic>? userData =
                userRef != null ? await extractUserData(userRef) : null;
            bool isLiked = await checkUserLikePost(doc.id);
            return Post.fromJson({
              "postId": doc.id,
              "userLiked": isLiked,
              "likesCount": doc.data()['likesCount'],
              "user": userData,
              "imageUrl": doc.data()['imageUrl'],
              "caption": doc.data()['caption'],
              "commentsCount": doc.data()['commentsCount'],
              "tag": doc.data()['tag'],
              "createdAt": doc.data()['createdAt'],
              "type": doc.data()['type'],
              "emoji": doc.data()['emoji'],
              "feeling": doc.data()['feeling'],
              'formattedCreatedAt': doc.data()['createdAt'],
            });
          }
          return Post();
        }));
        return posts;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future editPost(Post payload) async {
    try {
      if (payload.postId == null) {
        return;
      }
      return await baseSocialMediaService.updatePost(
          payload.toJsonUpdated(), payload.postId!);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUserLikePost(String postId) async {
    try {
      return await baseSocialMediaService.checkUserLike(postId);
    } catch (e) {
      rethrow;
    }
  }

  Stream<Post?> getSinglePost(String postId) {
    try {
      return baseSocialMediaService.getPostById(postId).asyncMap((doc) async {
        if (!doc.exists || doc.data() == null) return null;
        Map<String, dynamic> data = doc.data()!;
        final userRef = data['userId'] as DocumentReference?;
        final userData =
            userRef != null ? await extractUserData(userRef) : null;
        bool isLiked = await checkUserLikePost(postId);

        return Post.fromJson({
          "postId": doc.id,
          "userLiked": isLiked,
          "likesCount": data['likesCount'] ?? 0,
          "user": userData,
          "imageUrl": data['imageUrl'] ?? "",
          "caption": data['caption'] ?? "",
          "commentsCount": data['commentsCount'] ?? 0,
          "tag": data['tag'] ?? "",
          "createdAt": data['createdAt'],
          "type": data['type'],
          "emoji": data['emoji'],
          "feeling": data['feeling'],
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  Future updateLikeCount(String docId, int currentLikes) async {
    try {
      await baseSocialMediaService.updateLikeCount(docId, currentLikes);
    } catch (e) {
      rethrow;
    }
  }

  Future removeLikeCount(String docId, int currentLikes) async {
    try {
      await baseSocialMediaService.removeLikesCount(docId, currentLikes);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> extractUserData(DocumentReference ref) async {
    try {
      final result = await ref.get();

      if (result.exists) {
        return {'id': result.id, ...result.data() as Map<String, dynamic>};
      } else {
        return {'error': 'Document does not exist'};
      }
    } catch (e) {
      return {'error': 'An error occurred: $e'};
    }
  }
}
