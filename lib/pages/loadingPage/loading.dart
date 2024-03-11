import 'package:flutter/material.dart';
import 'dart:async';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _DarkLoaderState();
}

class _DarkLoaderState extends State<Loading> {
  // var _size1 = 10.0;
  // var _size2 = 5.0;
  // var _size3 = 5.0;
  //
  // @override
  // void initState() {
  //   // Loader animation using Timer.periodic
  //   Timer.periodic(const Duration(milliseconds: 250), (timer) {
  //     if (mounted) {
  //       setState(() {
  //         // Adjust the sizes of the circles in a periodic manner
  //         if (_size1 == 10.0) {
  //           _size1 = _size1 - 5.0;
  //           _size2 = _size2 + 5.0;
  //         } else if (_size2 == 10.0) {
  //           _size2 = _size2 - 5.0;
  //           _size3 = _size3 + 5.0;
  //         } else if (_size3 == 10.0) {
  //           _size3 = _size3 - 5.0;
  //           _size1 = _size1 + 5.0;
  //         }
  //       });
  //     }
  //   });
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;
    return Container(
        color: Colors.transparent.withOpacity(0.6),
        child: Center(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
            ),
            child:
            Center(
              child: SizedBox(
                child: Center(child: Image.asset('assets/images/logo.png')),
              ),
            ),


          ),
        )
    ) ;
    //   Container(
    //   color: Colors.transparent.withOpacity(0.6),
    //   child: Container(
    //     alignment: Alignment.center,
    //     height: media.height,
    //     width: media.width,
    //     decoration: BoxDecoration(
    //       color: Colors.black.withOpacity(0.8),
    //     ),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             AnimatedContainer(
    //               duration: const Duration(milliseconds: 225),
    //               height: _size1,
    //               width: _size1,
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: Colors.white,
    //               ),
    //             ),
    //             const SizedBox(width: 5),
    //             AnimatedContainer(
    //               duration: const Duration(milliseconds: 225),
    //               height: _size2,
    //               width: _size2,
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: Colors.white,
    //               ),
    //             ),
    //             const SizedBox(width: 5),
    //             AnimatedContainer(
    //               duration: const Duration(milliseconds: 225),
    //               height: _size3,
    //               width: _size3,
    //               decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //                 color: Colors.white,
    //               ),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}