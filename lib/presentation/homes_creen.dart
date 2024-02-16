import 'package:flutter/material.dart';
import 'package:time_to_train/widgets/horizontal_view_card.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time to Train'),
        actions: const [
           CircleAvatar(
             child: Text("IP") //TODO: Replace with user's initials
           ),
          SizedBox(width: 10,)
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            HorizontalCardView(),
            SizedBox(height: 15,),
            HorizontalCardView()
          ],
        ),
      ),
    );
  }
}

