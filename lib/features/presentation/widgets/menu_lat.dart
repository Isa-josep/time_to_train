import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_to_train/config/menu/menu_items.dart';
class SideMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey ;
  const SideMenu({super.key, required this.scaffoldKey});
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int navDrawerIndex=0;
   
  @override
  Widget build(BuildContext context) {

    final hasNotch = MediaQuery.of(context).viewPadding.top>35;
    //final size = MediaQuery.of(context).size;
    return  NavigationDrawer(
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value){
        setState(() {
          navDrawerIndex=value;
        });
        final menuItem= appMenuItems[value];
        context.push(menuItem.link);
        widget.scaffoldKey.currentState?.closeDrawer(); //widget es la instancia de la clase SideMenu
      },
      children:  [
        Padding(
          padding: EdgeInsets.fromLTRB(28, hasNotch?0:20, 16, 10),
          child: Row(
            children: [
            Text("Hola Isa", style: Theme.of(context).textTheme.titleMedium),
                const Padding(padding: EdgeInsets.only(left: 90),),
                const Icon(Icons.account_circle, size: 40,), 
              ],
              
            ),
          ),


        ...appMenuItems
        .sublist(0,3) 
        .map((item) =>  
         NavigationDrawerDestination(
          icon: Icon(item.icon),
          label: Text(item.title),
          ),
        ),
       const  Padding(
          padding:  EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Divider(), // ** crea una linea divisora 
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 16, 10),
          child: Text("Mas opciones", 
          style: Theme.of(context).textTheme.titleSmall
          ),
        ),
        ...appMenuItems
        .sublist(3) 
        .map((item) =>  
         NavigationDrawerDestination(
          icon: Icon(item.icon),
          label: Text(item.title),
          ),
        ),
      ],
    );
  }
}