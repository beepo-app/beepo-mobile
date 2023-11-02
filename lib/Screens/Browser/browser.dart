// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../Utils/styles.dart';
import '../../Widgets/components.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key); 

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {
  bool comingSoon = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: comingSoon
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      'assets/lottie/coming_soon.json',
                      height: 300,
                      width: 300,
                    ),
                    Text(
                      "Hey Beeper, Stay tuned we,re still cooking this awesome feature",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          : Container(
              color: Colors.white,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: EdgeInsets.only(left: 5, right: 10),
                      height: 132,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "DAPP Browser",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/Celo.png',
                                  height: 13, width: 13),
                              SizedBox(width: 5),
                              Text(
                                "Celo Network",
                                style: TextStyle(
                                  color: Color(0xccffffff),
                                  fontSize: 14,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down_sharp,
                                  color: Colors.white)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 28),
                            TextField(
                              decoration: InputDecoration(
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  borderSide:
                                      BorderSide(width: 1, color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(height: 28),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    BrowserContainer(
                                      image: 'assets/mobius.png',
                                      title: 'mobius',
                                    ),
                                    BrowserContainer(
                                      image: 'assets/mentofi.png',
                                      title: 'mentoFi',
                                    ),
                                    BrowserContainer2(
                                      image: 'assets/imMarketer.png',
                                      title: 'impactMarket',
                                    ),
                                    BrowserContainer(
                                      image: 'assets/immortal.png',
                                      title: 'Immortal',
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    BrowserContainer3(
                                      image: 'assets/pancake.png',
                                      title: 'pancakeswap',
                                    ),
                                    BrowserContainer(
                                      image: 'assets/sanshi.png',
                                      title: 'Sushi',
                                    ),
                                    BrowserContainer(
                                      image: 'assets/uniswap.png',
                                      title: 'Uniswap',
                                    ),
                                    BrowserContainer4(
                                      image: 'assets/opensea.png',
                                      title: 'Opensea',
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 35),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "NEWS",
                                style: TextStyle(
                                  color: secondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            SizedBox(height: 34),
                            ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 5,
                              separatorBuilder: (ctx, i) =>
                                  SizedBox(height: 20),
                              itemBuilder: (ctx, i) {
                                return Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  width: 317,
                                  height: 116,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: secondaryColor,
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          'assets/news.png',
                                          height: 87,
                                          width: 104,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              "Here’s Why Blockchain is the Technology For The Future Here’s Why Blockchain is the Technology For The Future, Here’s Why Blockchain is the Technology For The Future",
                                              maxLines: 4,
                                              style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 27),
                                            Text(
                                              "technology.com",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
