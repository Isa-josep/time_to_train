import 'package:flutter/material.dart';

class MenuItem{ 
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem({
    required this.title, 
    required this.subTitle, 
    required this.link, 
    required this.icon
  });
}

const appMenuItems = <MenuItem>[

  MenuItem(
    title: 'Inicio',
    subTitle: 'Página principal',
    link: '/',
    icon: Icons.home,
  ),

  MenuItem(
    title: 'Inicio',
    subTitle: 'Página principal',
    link: '/',
    icon: Icons.home,
  ),

  MenuItem(
    title: 'Inicio',
    subTitle: 'Página principal',
    link: '/',
    icon: Icons.home,
  ),

  MenuItem(
    title: 'Inicio',
    subTitle: 'Página principal',
    link: '/',
    icon: Icons.home,
  ),

  MenuItem(
    title: 'Custom theme',
    subTitle: 'Cambar el tema de la app',
    link: '/theme_changer_screen',
    icon: Icons.color_lens_outlined,
  ),
  
  
];