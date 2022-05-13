import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';

import 'Screens/browser_page.dart';
import 'Screens/chatDm_screen.dart';
import 'Screens/sendToken_screen.dart';
import 'Utils/styles.dart';

class FilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  FilledButton({this.text, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 237,
      height: 42,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            color ?? primaryColor,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlnButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  OutlnButton({this.text, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 237,
      height: 42,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: blue,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(width: 1, color: blue)),
          backgroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatTab extends StatefulWidget {
  ChatTab({Key key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: 20),
            Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFFC4C4C4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 35,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  "Update Status",
                  style: TextStyle(
                    color: Color(0xb2ffffff),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  padding: const EdgeInsets.only(right: 10),
                  shrinkWrap: true,
                  itemCount: 6,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (ctx, i) => const SizedBox(width: 10),
                  itemBuilder: (ctx, i) {
                    return Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/profile_img.png',
                            height: 60,
                            width: 60,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          "James",
                          style: TextStyle(
                            color: const Color(0xb2ffffff),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: const [
                      Expanded(
                        child: Text(
                          "Messages",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.search,
                        color: Color(0xff908f8d),
                        size: 20,
                      ),
                      SizedBox(width: 20),
                      Icon(
                        Icons.more_vert_outlined,
                        color: Color(0xff908f8d),
                        size: 18,
                      ),
                    ],
                  ),

                  // SizedBox(height: 4),
                  Column(
                    children: [
                      ListView.separated(
                        padding: const EdgeInsets.only(top: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 8,
                        separatorBuilder: (ctx, i) => const SizedBox(height: 0),
                        itemBuilder: (ctx, i) {
                          return ListTile(
                            onTap: () => Get.to(const ChatDm()),
                            contentPadding: EdgeInsets.zero,
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: Image.asset(
                                'assets/profile.png',
                                height: 50,
                                width: 50,
                              ),
                            ),
                            title: Row(
                              children: const [
                                Expanded(
                                  child: Text(
                                    "Precious ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Text(
                                  "9:13",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: const Text(
                              "Hey Buddy, got the contract ready for deployment yet?",
                              style: TextStyle(
                                color: Color(0x82000000),
                                fontSize: 11,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  //),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CallTab extends StatefulWidget {
  CallTab({Key key}) : super(key: key);

  @override
  State<CallTab> createState() => _CallTabState();
}

class _CallTabState extends State<CallTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Row(
              children: const [
                Expanded(
                  child: Text(
                    "Messages",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                Icon(
                  Icons.search,
                  color: Color(0xff908f8d),
                  size: 20,
                ),
                SizedBox(width: 20),
                Icon(
                  Icons.more_vert_outlined,
                  color: Color(0xff908f8d),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 27),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  'assets/profile2.png',
                  height: 50,
                  width: 50,
                ),
              ),
              title: const Text(
                "Precious ",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              subtitle: const Text(
                "9:13",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),

                // );
                // },
              ),
              trailing: const Icon(
                Icons.phone_missed_sharp,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageSender1 extends StatelessWidget {
  const MessageSender1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: const Radius.circular(0),
            bottomLeft: const Radius.circular(30),
            bottomRight: const Radius.circular(30),
          ),
          color: const Color(0xffFF9C34),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Hey there, you up?",
              style: const TextStyle(
                color: const Color(0xff0e014c),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.bottomRight,
              child: const Text(
                "9:13",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageSender2 extends StatelessWidget {
  const MessageSender2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: const Radius.circular(30),
            bottomLeft: const Radius.circular(30),
            bottomRight: const Radius.circular(30),
          ),
          color: const Color(0xffFF9C34),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "What’s with the statement about \nthe missing documents today, i\nheard you discussing earlier with\nJane?\n\nuhmmm is there something i \nshould be worried about?\nuh!?",
              style: TextStyle(
                color: Color(0xff0e014c),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.bottomRight,
              child: const Text(
                "9:13",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageSender3 extends StatelessWidget {
  const MessageSender3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(30),
            topRight: const Radius.circular(0),
            bottomLeft: const Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Color(0xffFF9C34),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              "Is rhat funny?",
              style: TextStyle(
                color: Color(0xff0e014c),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.bottomRight,
              child: const Text(
                "9:13",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageReceiver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(0),
            topRight: const Radius.circular(30),
            bottomLeft: const Radius.circular(30),
            bottomRight: const Radius.circular(30),
          ),
          color: Color(0xe50d004c),
        ),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "😂🤣 wdy mean?",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.bottomRight,
              child: const Text(
                "9:13",
                style: TextStyle(
                  color: const Color(0xffe3dede),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageReceiver2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: const Radius.circular(0),
            topRight: const Radius.circular(30),
            bottomLeft: const Radius.circular(30),
            bottomRight: const Radius.circular(30),
          ),
          color: const Color(0xe50d004c),
        ),
        padding: const EdgeInsets.all(10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "😒 chill buddy, it’s no big \ndeal.    We we’re just cruising ‘bout\nto see how you’d react",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.bottomRight,
              child: const Text(
                "9:13",
                style: const TextStyle(
                  color: Color(0xffe3dede),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WalletListTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtext;
  final String amount;

  WalletListTile({this.image, this.title, this.subtext, this.amount});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 62,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0x3f000000),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: const Color(0xfffffbfb),
      ),
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        onTap: () => Get.to(SendToken()),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: Image.asset(
            image,
            height: 34,
            width: 34,
            fit: BoxFit.cover,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Text(
              "\$3,456",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                subtext,
                style: const TextStyle(
                  color: Color(0xcc000000),
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: const Color(0xcc000000),
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BrowserContainer extends StatelessWidget {
  final String image;
  final String title;

  BrowserContainer({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(BrowserPage()),
          child: Container(
            padding: const EdgeInsets.all(0),
            width: 55,
            height: 53,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(image),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff0e014c),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class BrowserContainer2 extends StatelessWidget {
  final String image;
  final String title;

  BrowserContainer2({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(BrowserPage()),
          child: Container(
            padding: const EdgeInsets.all(0),
            width: 55,
            height: 53,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                const BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: const Color(0xff0e014c),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class BrowserContainer3 extends StatelessWidget {
  final String image;
  final String title;

  BrowserContainer3({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(BrowserPage()),
          child: Container(
            padding: const EdgeInsets.all(0),
            width: 55,
            height: 53,
            decoration: BoxDecoration(
              color: const Color(0xff40D6E1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                const BoxShadow(
                  color: const Color(0x3f000000),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(
              image,
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: const Color(0xff0e014c),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class BrowserContainer4 extends StatelessWidget {
  final String image;
  final String title;

  BrowserContainer4({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(BrowserPage()),
          child: Container(
            padding: const EdgeInsets.all(0),
            width: 55,
            height: 53,
            decoration: BoxDecoration(
              color: const Color(0xff2081E2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                const BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(
              image,
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff0e014c),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class ContainerButton extends StatelessWidget {
  const ContainerButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 180,
      decoration: BoxDecoration(
        boxShadow: [
          const BoxShadow(
            color: const Color(0x0c000234),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  bottomLeft: const Radius.circular(35),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  const Text(
                    'Swap',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const Spacer(),
                  const VerticalDivider(),
                ],
              ),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 60,
              color: const Color.fromRGBO(255, 255, 255, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  const Text(
                    'Granda',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                  const Spacer(),
                  const VerticalDivider(),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: const Radius.circular(35),
                  bottomRight: const Radius.circular(35),
                ),
              ),
              child: const Text(
                'About',
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
