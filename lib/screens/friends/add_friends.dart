import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  List<String> friends = []; // List to store user's friends

  String searchEmail = ''; // Variable to store the email being searched
  String currentUserEmail =
      FirebaseAuth.instance.currentUser!.email!; // Get the current user's email

  Future<void> getUserFriends() async {
    // Function to get the user's friends from the database
    // Implement your logic here to fetch the friends from the database
    // Update the friends list with the fetched data
    final currentUserDoc = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(currentUserEmail)
        .get();
    print(currentUserEmail);
    print(currentUserDoc.data());
    final friendsArray = currentUserDoc.data()?['friends'] as List<dynamic>;
    if (friendsArray != null) {
      setState(() {
        friends = friendsArray.cast<String>();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserFriends();
  }

  void searchUser() {
    // Function to search for a user in the database
    // Implement your logic here to search for the user using the searchEmail variable
    // Add the user to the friends list if found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friends'),
      ),
      body: Column(
        children: [
          // Section for user's friends
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(friends[index]),
                );
              },
            ),
          ),
          // Search button and input field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchEmail = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search by email',
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    searchUser();
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
