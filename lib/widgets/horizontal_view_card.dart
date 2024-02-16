import 'package:flutter/material.dart';
class HorizontalCardView extends StatelessWidget {
  const HorizontalCardView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return  SizedBox(
      height: 350,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              //controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context,index){
                return const SizedBox(
                  width: 250,
                  child: CardView(),
                );
              }
            )
          )
        ],
      ),
    );
  }
}


class CardView extends StatelessWidget {
  const CardView({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child:  Column(
        children: [
          SizedBox(
            width: 250,
            height: 150,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(5),
                topLeft: Radius.circular(5),
              ),
              child: Container(
                color: color.primary,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      Text("Titulo", 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                      Text("Subtitulo",)
                    ],
                  )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


/*
 card nativa de flutter
  child: Card(
                    child: Column(
                      children: [
                        //Image.asset('assets/images/placeholder.png',height: 150,),
                        const SizedBox(height: 10,),
                        const Text("Title"),
                        const SizedBox(height: 10,),
                        const Text("Description")
                      ],
                    ),
                  ),

 */