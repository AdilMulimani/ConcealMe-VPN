import 'package:conceal_me/core/theme/app_palette.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/hive/models/vpn_history.dart';

class VpnHistoryPage extends StatelessWidget {
  const VpnHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyBox = Hive.box<VpnHistory>('vpnHistoryBox');

    return Scaffold(
      appBar: AppBar(title: Text('History')),
      body: ValueListenableBuilder(
        valueListenable: historyBox.listenable(),

        builder: (context, Box<VpnHistory> box, _) {
          final histories = box.values.toList().reversed.toList();

          if (histories.isEmpty) {
            return Center(child: Text('No VPN history yet.'));
          }

          return ListView.builder(
            itemCount: histories.length + 1,
            itemBuilder: (context, index) {
              // Header Row
              if (index == 0) {
                // Header row
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 8.0,
                  ),
                  child: Column(
                    spacing: 2.0,
                    children: [
                      Row(
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Country',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Duration',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_circle_down,
                                  color: AppPalette.primaryColor,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'KB',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_circle_up,
                                  color: Colors.orange,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'KB',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                );
              }

              final history = histories[index - 1];
              //print(history.createdAt.toString());
              final bytesInKbs = (double.tryParse(history.bytesIn.toString())! /
                      1000)
                  .toStringAsFixed(2);
              final bytesOutKbs =
                  (double.tryParse(history.bytesOut.toString())! / 1000)
                      .toStringAsFixed(2);
              // Value Rows
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 8.0,
                ),
                child: Dismissible(
                  onDismissed: (direction) {
                    // context.read<TodoListBloc>().add(
                    //   DeleteTodoEvent(id: todos[index].id),
                    // );
                  },
                  confirmDismiss: (direction) {
                    // return showDialog(
                    //   context: context,
                    //   builder: (context) {
                    //     return AlertDialog(
                    //       title: Text('Confirm Delete'),
                    //       content: Text('Are you sure you want to delete?'),
                    //       actions: [
                    //         TextButton(
                    //           onPressed: () {
                    //             Navigator.pop(context, true);
                    //           },
                    //           child: Text('Okay'),
                    //         ),
                    //         TextButton(
                    //           onPressed: () {
                    //             Navigator.pop(context, false);
                    //           },
                    //           child: Text('Cancel'),
                    //         ),
                    //       ],
                    //     );
                    //   },
                    // );
                    return showModalBottomSheet<bool>(
                      context: context,
                      backgroundColor: AppPalette.darkBlueBackgroundColor,
                      showDragHandle: true,
                      builder: (context) {
                        return IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              spacing: 8.0,
                              children: [
                                Text(
                                  'Delete This History?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                    color: Colors.redAccent,
                                  ),
                                ),
                                Divider(),
                                Text(
                                  history.country,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                    color: AppPalette.primaryColor,
                                  ),
                                ),
                                Divider(),
                                Text(
                                  '${DateFormat('hh:mm a dd-MM-yyyy').format(history.createdAt)} - ${DateFormat('hh:mm a dd-MM-yyyy').format(history.lastUpdatedAt)} ',
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      spacing: 4.0,
                                      children: [
                                        Icon(
                                          Icons.arrow_circle_down,
                                          color: AppPalette.primaryColor,
                                          size: 28,
                                        ),
                                        Text(
                                          bytesInKbs,
                                          style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            color: AppPalette.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      spacing: 4.0,
                                      children: [
                                        Icon(
                                          Icons.arrow_circle_up,
                                          color: Colors.orange,
                                          size: 28,
                                        ),
                                        Text(
                                          bytesOutKbs,
                                          style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Divider(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 8.0,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(180, 60),
                                            backgroundColor:
                                                AppPalette.cancelButtonColor,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await historyBox.delete(
                                              history.key,
                                            );
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(180, 60),
                                            backgroundColor:
                                                AppPalette.primaryColor,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: Text(
                                            'Yes, Delete',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  key: ValueKey(history.id),
                  background: BackgroundDismissible(direction: 0),
                  secondaryBackground: BackgroundDismissible(direction: 1),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: CountryFlag.fromCountryCode(
                            history.country,
                            height: 40,
                            width: 60,
                            shape: RoundedRectangle(8),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            history.duration,
                            style: const TextStyle(fontSize: 15.0),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: Text(
                            bytesInKbs,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: AppPalette.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: Text(
                            bytesOutKbs,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BackgroundDismissible extends StatelessWidget {
  const BackgroundDismissible({super.key, required this.direction});
  final int direction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      color: Colors.red,
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: Icon(Icons.delete, size: 30.0, color: Colors.white),
    );
  }
}
