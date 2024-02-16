import 'package:flutter/material.dart';
import 'package:time_to_train/widgets/horizontal_view_card.dart';
import 'package:time_to_train/widgets/menu_lat.dart';
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Time to Train'),
      ),
      body: const _Home(),
      drawer: SideMenu( scaffoldKey: scaffoldKey )
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          HorizontalCardView(),
          SizedBox(height: 15,),
          HorizontalCardView()
        ],
      ),
    );
  }
}

