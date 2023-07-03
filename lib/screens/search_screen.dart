import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/screens/profile_screen.dart';
import 'package:event_app/utils/add_space.dart';
import 'package:event_app/utils/navigate_to.dart';
import 'package:event_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowsUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void cancelSearch() {
    setState(() {
      isShowsUsers = false;
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          style: const TextStyle(
            color: Colors.black,
          ),
          controller: searchController,
          decoration: InputDecoration(
            prefixIcon: isShowsUsers
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => cancelSearch(),
                  )
                : const Icon(Icons.search),
            hintText: 'Search for an user',
            hintStyle: const TextStyle(
              color: Colors.black54,
            ),
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowsUsers = true;
            });
          },
        ),
      ),
      body: isShowsUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length ?? 0,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => pushTo(
                        context,
                        ProfileScreen(
                          uid: snapshot.data?.docs[index]['uid'] ?? "",
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              snapshot.data?.docs[index]['photoUrl'] ?? ""),
                        ),
                        title:
                            Text(snapshot.data?.docs[index]['username'] ?? ""),
                      ),
                    );
                  },
                );
              },
            )
          : Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // icon
                  const Icon(
                    Icons.search,
                    size: 30,
                  ),
                  addHorizontalSpace(10),
                  // nothing to show here yet
                  const CustomText(
                    text: 'Nothing to show here yet...',
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),
                ],
              ),
            ),
    );
  }
}
