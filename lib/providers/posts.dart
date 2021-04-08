import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String authorId;
  String authorName;
  String title;
  String content;
  String type;
  String createdAt;
  String desc;
  Post(
      {@required this.authorId,
      @required this.title,
      @required this.authorName,
      @required this.content,
      @required this.type,
      @required this.createdAt,
      @required this.desc});
}

class Posts with ChangeNotifier {
  List<Post> _posts = [];

  Posts(this._posts);

  final firestoreInstance = FirebaseFirestore.instance;

  List<Post> get posts {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._posts];
  }

  Future<void> fetchAndSetPosts() async {
    try {
      // final response = await http.get(url);
      // final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // print(extractedData);
      // print(extractedData);
      // if (extractedData == null) {
      //   return;
      // }

      final List<Post> loadedProducts = [];
      // extractedData.forEach((prodId, prodData) {
      //   loadedProducts.add(Product(
      //     id: prodId,
      //     title: prodData['title'] ?? 'No Title',
      //     availability: prodData['availability'] ?? true,
      //     price: prodData['price'] ?? 0,
      //     imageUrl: prodData['imageUrl']==null || prodData['imageUrl']=='.'?
      //         'https://images.unsplash.com/photo-1487260211189-670c54da558d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80':prodData['imageUrl']
      //   ));
      // });
      // _items = loadedProducts;
      firestoreInstance.collection("posts").get().then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          print('##########');
          print(result.data());
          final data = result.data();
          print(data['authorName']);
          loadedProducts.add(Post(
              authorId: data['authorID'],
              title: data['title'],
              authorName: data['authorName'],
              content: data['content'],
              type: data['type'],
              createdAt: data['createdAt'],
              desc: data['description']));
        });
      });
      _posts = loadedProducts;
      print('@@@@@@@@@@');
      print(_posts[0].authorName);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
