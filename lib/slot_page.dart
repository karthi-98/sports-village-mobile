import 'package:flutter/material.dart';

class SlotPage extends StatefulWidget {
  const SlotPage({super.key});

  @override
  State<SlotPage> createState() => _SlotPageState();
}

class _SlotPageState extends State<SlotPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

@override
  void initState() {
    _animationController = AnimationController(vsync: this,duration: const Duration(milliseconds: 300));
     _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SlideTransition(
        position: Tween<Offset>(
        begin: const Offset(.04,0),
        end: Offset.zero
      ).animate(_animationController),
        child: Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                onTap: (){Navigator.pop(context);},
                child: const Icon(Icons.arrow_back),
              ),
            ),
        ),
      ),
    );
  }
}