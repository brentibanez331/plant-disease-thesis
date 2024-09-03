import 'package:flutter/material.dart';

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: const Color.fromARGB(255, 63, 133, 231),
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              // Top divider outside the container
              if (index == 0) const Divider(thickness: 1),
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                NetworkImage('https://placeholder.com/40x40'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Account Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '2d',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '⋅',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 25),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '1.2K views',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem(
                                    value: "EditPost", child: Text("Edit")),
                                const PopupMenuItem(
                                    value: "DeletePost", child: Text("Delete"))
                              ];
                            },
                            onSelected: (String value) {
                              // Handle menu item selection
                              print('Selected: $value');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom divider outside the container
              const Divider(thickness: 1),
            ],
          );
        },
      ),
    );
  }
}
