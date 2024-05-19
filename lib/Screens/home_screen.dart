import 'package:dowajo/Screens/macro_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/menu_item.dart';
//import 'heart_screen.dart';
import 'package:dowajo/Screens/inject_screen.dart';
import 'medicine_screen.dart';
import 'alarms_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 235, 238, 240),
        //backgroundColor: Color.fromARGB(255, 219, 225, 228),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "도와조",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //SizedBox(height: 15),
                // buildLogo(),
                buildHeading(),
                buildMenu1(context),
                buildMenu2(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Padding buildLogo() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 80, bottom: 20),
  //     child: Center(
  //       child: Icon(
  //         Icons.water_drop_rounded,
  //         size: 100,
  //         color: Colors.blue.shade900,
  //       ),
  //     ),
  //   );
  // }

  // Padding buildHeading() {
  //   return const Padding(
  //     padding: EdgeInsets.only(top: 60, bottom: 80),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //           "도와조",
  //           style: TextStyle(
  //             fontSize: 30,
  //             fontWeight: FontWeight.bold,
  //             color: Color(0xff112a42),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Padding buildHeading() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, bottom: 25, left: 5, right: 5),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 214, 212, 212), // 그림자 색상
              spreadRadius: 0, // 그림자 확산 정도
              blurRadius: 3, // 그림자 흐림 정도
              offset: Offset(0, 0), // 그림자 위치 (가로, 세로)
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 14.0, right: 14.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '환자 정보',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 10.0,
                    left: 20.0,
                    right: 20.0,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 하는 정도
                    child: Image.network(
                      'https://img.seoul.co.kr/img/upload/2022/04/28/SSI_20220428230010_V.jpg',
                      fit: BoxFit.cover,
                      height: 150,
                      width: 110,
                    ),
                  ),

                  // Container(
                  //   width: 100,
                  //   height: 100,
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey[400],
                  //     shape: BoxShape.circle,
                  //   ),
                  // ),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '백현 (남)',
                      style: TextStyle(
                        color: Color.fromARGB(255, 98, 98, 98),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '생년월일: ',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '1992-05-06',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        // SizedBox(width: 20),
                        // Text(
                        //   '성별: ',
                        //   style: TextStyle(
                        //       fontSize: 15,
                        //       color: Colors.grey,
                        //       fontWeight: FontWeight.bold),
                        // ),
                        // Text(
                        //   '남',
                        //   style: TextStyle(fontSize: 15, color: Colors.grey),
                        // ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '병명: ',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '독감',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '병실: ',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '506호',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildMenu1(BuildContext context) {
    return SizedBox(
      height: 168,
      width: 323,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35), // 모서리 둥글게
              boxShadow: [
                // 그림자 추가
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 0.0), // 아이콘 위에 패딩 추가
                  child: IconButton(
                    //주사 쿠퍼티노 아이콘 쓸만한게 없어서 대체
                    icon: Image.asset('repo/icons/inject.png',
                        width: 26, height: 26),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const InjectScreen())); //원래 homescreen였는데, 에러남
                    },
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 11.0), // 아이콘과 텍스트 사이에 공간 추가
                  child: Text("주사",
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontFamily: 'Cupertino',
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 23),
          MenuItem(
            text: "투여약",
            icon: Icons.medication,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MedicineScreen()));
            },
            iconColor: const Color.fromARGB(255, 137, 182, 112),
          ),
        ],
      ),
    );
  }

  SizedBox buildMenu2(BuildContext context) {
    return SizedBox(
      height: 168,
      width: 323,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MenuItem(
            text: "매크로 설정",
            icon: CupertinoIcons.gear_alt_fill,
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MacroScreen()));
            },
            iconColor: const Color.fromARGB(255, 113, 161, 183),
          ),
          const SizedBox(width: 23),
          MenuItem(
            text: "알림 모아보기",
            icon: CupertinoIcons.bell_circle_fill,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AlarmsScreen()));
            },
            iconColor: const Color.fromARGB(255, 249, 196, 150),
          ),
        ],
      ),
    );
  }
}
