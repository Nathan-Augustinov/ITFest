import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:it_fest/constants/app_colors.dart';
import 'package:it_fest/constants/app_texts.dart';
import 'package:it_fest/constants/insets.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  List<String> friends = []; // List to store user's friends

  String searchEmail = '';
  String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;
  String? foundUserEmail;
  bool isUserFound = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getUserFriends();
  }

//TODO: sa nu uitam sa adaugam relatie prietenie si invers
  Future<void> getUserFriends() async {
    final currentUserDoc = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(currentUserEmail)
        .get();
    print(currentUserEmail);
    print(currentUserDoc.data());
    final friendsArray = currentUserDoc.data()?['friends'] as List<dynamic>;
    setState(() {
      friends = friendsArray.cast<String>();
    });
  }

  Future<bool> existsSearchedUser(email) async {
    final searchedUserDoc = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(email)
        .get();
    if (searchedUserDoc.exists) {
      return true;
    }
    return false;
  }

  Future<void> searchUser() async {
    if (searchEmail == currentUserEmail) {
      // The searched email is the current user's email
      setState(() {
        isUserFound =
            false; // or true, depending on how you want to handle this scenario
        foundUserEmail = null; // Clear or handle accordingly
        errorMessage = "You cannot add yourself.";
      });
    } else {
      final bool userExists = await existsSearchedUser(searchEmail);
      if (userExists) {
        // Check if the user is already in the current user's friends list
        bool isAlreadyFriend = friends.contains(searchEmail);
        if (isAlreadyFriend) {
          setState(() {
            isUserFound = false;
            foundUserEmail = null;
            errorMessage = "User is already in your friends list.";
          });
        } else {
          // The user exists and is not the current user or already a friend
          setState(() {
            isUserFound = true;
            foundUserEmail = searchEmail;
            errorMessage = ""; // Clear any previous error message
          });
        }
      } else {
        // User does not exist
        setState(() {
          isUserFound = false;
          foundUserEmail = null;
          errorMessage = "User not found.";
        });
      }
    }
  }

  void addUserAsFriend(String friendEmail) async {
    final currentUserDoc = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(currentUserEmail)
        .get();
    final friendsArray = currentUserDoc.data()?['friends'] as List<dynamic>;
    friendsArray.add(friendEmail);
    await currentUserDoc.reference.update({'friends': friendsArray});
    getUserFriends();
  }

  void deleteUserAsFriend(String friendEmail) async {
    final currentUserDoc = await FirebaseFirestore.instance
        .collection('accounts')
        .doc(currentUserEmail)
        .get();
    final friendsArray = currentUserDoc.data()?['friends'] as List<dynamic>;
    friendsArray.remove(friendEmail);
    await currentUserDoc.reference.update({'friends': friendsArray});
    getUserFriends();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreen,
      appBar: AppBar(
        title: const Text('Add Friends'),
        backgroundColor: AppColors.green,
      ),
      body: Container(
        color: AppColors.lightGreen,
        padding: AppInsets.leftRight20.copyWith(top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
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
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      searchUser();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0, // Removes shadow from the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Search'),
                  ),
                ],
              ),
              if (isUserFound)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      Text(
                        'User Found: $foundUserEmail',
                        style:
                            const TextStyle(color: Colors.green, fontSize: 16),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          addUserAsFriend(foundUserEmail!);
                          isUserFound = false;
                        },
                        child: const Text('Add as Friend'),
                      ),
                    ],
                  ),
                )
              else if (errorMessage != '')
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              const SizedBox(height: 40),
              Text(
                'Your friends',
                style: AppTexts.font16Bold,
              ),
              const SizedBox(height: 16),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          friends[index][0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        friends[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.error),
                        onPressed: () {
                          deleteUserAsFriend(friends[index]);
                          print('Delete ${friends[index]}');
                        },
                      ),
                    ),
                  );
                },
              ),
              // Search button and input field
            ],
          ),
        ),
      ),
    );
  }
}
