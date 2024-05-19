import 'dart:io';
import 'package:dowajo/Screens/inject/inject_add.dart';
import 'package:dowajo/Screens/inject/inject_list_provider.dart';
import 'package:dowajo/Screens/inject/inject_record.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';
import 'package:dowajo/components/models/injectModel.dart';
import 'package:provider/provider.dart';
import 'package:dowajo/components/calendar/today_banner.dart';
import 'package:dowajo/database/inject_database.dart';
import 'package:dowajo/Screens/inject/inject_Update.dart';

class InjectScreen extends StatefulWidget {
  const InjectScreen({Key? key}) : super(key: key);

  @override
  _InjectScreenState createState() => _InjectScreenState();
}

class _InjectScreenState extends State<InjectScreen> {
  var dbHelper = InjectDatabaseHelper.instance;
  late Future<List<InjectModel>> futureInject;
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final injectModelProvider =
    //     Provider.of<InjectModelProvider>(context); // 변경된 부분
    final injectModelProvider = context.watch<InjectModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          _AppBar(),
          Expanded(
            flex: 10,
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<InjectModel>>(
                    future: futureInject,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<InjectModel>> snapshot) {
                      // Future가 완료되었을 때
                      if (snapshot.connectionState == ConnectionState.done) {
                        // 에러가 발생했을 때
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        // 데이터가 없을 때
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Column(
                            children: [
                              Spacer(flex: 1),
                              Text(
                                "등록된 기록이 없어요",
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      const Color.fromARGB(255, 123, 123, 123),
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                "새로운 주사를 추가할까요?",
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      const Color.fromARGB(255, 123, 123, 123),
                                ),
                              ),
                              SizedBox(height: 12),
                              SizedBox(
                                width: 210,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => inject_add()),
                                    );
                                    setState(() {});
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFFA6CBA5)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                    elevation:
                                        MaterialStateProperty.all<double>(0),
                                  ),
                                  child: Text(
                                    " 추가하기 +",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(flex: 1),
                            ],
                          );
                        }
                        //데이터가 있을 때
                        List<InjectModel>? injects = snapshot.data;

                        return ListView.builder(
                          itemCount: injects!.length,
                          itemBuilder: (BuildContext context, int index) {
                            //   final dt = DateFormat.jm()
                            //      .parse(data[index].injectEndTime);
                            //  final newFormat = DateFormat('a h:mm', 'ko_KR');
                            //  final koreanTime = newFormat.format(dt);

                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25),
                                        ),
                                      ),
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(height: 15),
                                            // ElevatedButton(
                                            //   onPressed: () {},
                                            //   style: ElevatedButton.styleFrom(
                                            //     elevation: 0,
                                            //     backgroundColor:
                                            //         Colors.transparent,
                                            //     minimumSize: Size(
                                            //         MediaQuery.of(context)
                                            //             .size
                                            //             .width,
                                            //         60),
                                            //   ),
                                            //   child: const Text('수정하기'),
                                            // ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        injectUpdate(
                                                            inject:
                                                                injects[index]),
                                                  ),
                                                ).then((_) {
                                                  // 수정 페이지에서 돌아온 후
                                                  Navigator.of(context).pop();
                                                  // 화면을 갱신
                                                  setState(() {
                                                    futureInject = dbHelper
                                                        .getAllInjects();
                                                  });
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                minimumSize: Size(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    60),
                                              ),
                                              child: const Text('수정하기'),
                                            ),

                                            const SizedBox(height: 5),
                                            const Divider(thickness: 4),
                                            const SizedBox(height: 10),
                                            ElevatedButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                minimumSize: Size(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    60),
                                              ),
                                              child: const Text('삭제하기'),
                                            ),

                                            // ElevatedButton(
                                            //   onPressed: () async {
                                            //     // id가 null인지 확인
                                            //     if (medicines[index].id !=
                                            //         null) {
                                            //       // id가 null이 아니라면 삭제
                                            //       await DatabaseHelper
                                            //           .instance
                                            //           .delete(medicines[index]
                                            //               .id!);

                                            //       // 삭제가 완료되면 FutureBuilder를 다시 빌드
                                            //       setState(() {
                                            //         futureMedicines = dbHelper
                                            //             .getAllMedicines();
                                            //       });
                                            //     }
                                            //     Navigator.of(context).pop();
                                            //   },
                                            //   style: ElevatedButton.styleFrom(
                                            //     elevation: 0,
                                            //     backgroundColor:
                                            //         Colors.transparent,
                                            //     minimumSize: Size(
                                            //         MediaQuery.of(context)
                                            //             .size
                                            //             .width,
                                            //         60),
                                            //   ),
                                            //   child: const Text('삭제하기'),
                                            // ),
                                            const SizedBox(height: 10),
                                            const Divider(thickness: 4),
                                            const SizedBox(height: 5),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    Colors.transparent,
                                                minimumSize: Size(
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    60),
                                              ),
                                              child: const Text('닫기'),
                                            ),
                                            const SizedBox(height: 18),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(3),
                                    padding: EdgeInsets.all(6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 5),
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 3,
                                                color: Color(0xFFA6CBA5)),
                                          ),
                                          child: ClipOval(
                                            child: Image.file(
                                              File(
                                                  injects[index].injectPicture),
                                              width: 65,
                                              height: 65,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // 텍스트를 왼쪽 정렬
                                          children: [
                                            Text(
                                              "${injects[index].injectName}, 유형: ${injects[index].injectType}",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 136, 171, 134)),
                                            ),
                                            /*Text(
                                                "${injectModelProvider.injects[index].injectDay}      ${injectModelProvider.injects[index].injectStartTime} ~ ${injectModelProvider.injects[index].injectEndTime}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),*/
                                            Text(
                                              "${injects[index].injectDay}      ${injects[index].injectStartTime} ~ ${injects[index].injectEndTime}",
                                              style: TextStyle(
                                                fontSize: 18,
                                              ),
                                            ),
                                            injects[index].injectChange
                                                ? Text(
                                                    "교체 예정",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  )
                                                : Container(),
                                            SizedBox(height: 4),
                                            // Text(
                                            //   koreanTime,
                                            //   style: TextStyle(
                                            //       fontSize: 17,
                                            //       fontWeight: FontWeight.bold,
                                            //       color: Color.fromARGB(221, 53, 53, 53)),
                                            // ),
                                            SizedBox(height: 2),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (index != injects.length - 1)
                                  Divider(
                                    color: Color.fromARGB(255, 236, 236, 236),
                                    thickness: 2.0,
                                  ),
                              ],
                            );
                          },
                        );
                      }
                      // Future가 아직 완료되지 않았을 때
                      return CircularProgressIndicator(); // 로딩 인디케이터 표시
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FutureBuilder<List<InjectModel>>(
        future: futureInject,
        builder:
            (BuildContext context, AsyncSnapshot<List<InjectModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<InjectModel>? injects = snapshot.data;
              if (injects!.isEmpty) {
                return FloatingActionButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => inject_add()),
                    );
                    setState(() {});
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  child: Image.asset(
                    'repo/icons/plus.png', // Image asset 사용
                  ),
                );
              } else {
                return Container(); // 데이터가 없으면 빈 컨테이너를 반환하여 버튼을 표시하지 않음
              }
            }
          }
          return Container();
        },
      ),

      // ? FloatingActionButton(
      //     onPressed: () async {
      //       await Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (_) => inject_add()),
      //       );
      //       setState(() {});
      //     },
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(30),
      //     ),
      //     backgroundColor: Colors.transparent,
      //     elevation: 0.0,
      //     child: Image.asset(
      //       'repo/icons/plus.png', // Image asset 사용
      //     ),
      //   )
      // : Container(), //데이터가 없는 경우 빈 컨테이너를 반환
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm, size: 25),
            label: '알람',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: '기록',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFFA6CBA5),
        onTap: (int index) {
          _onItemTapped(index);
          if (_currentIndex == 0 && index == 0) {
            return; // 이미 알람 화면이므로 아무것도 하지 않음
          } else {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InjectScreen()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InjectRecord()),
                ); //기록 화면으로 변경하기);
                break;
            }
          }
        },
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      title: Text('주사', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        ),
      ),
    );
  }
}
