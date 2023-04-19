import 'package:beepo/Utils/styles.dart';
import 'package:flutter/material.dart';

class TransferPage extends StatefulWidget {
  const TransferPage({Key key}) : super(key: key);

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: bg,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 7, right: 25),
                    height: 121,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Color(0xff0e014c),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        )),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_outlined,
                                  size: 28,
                                  color: Colors.white,
                                ),
                                onPressed: () {}),
                            const Text(
                              "Transfer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const ReusableTransferText(
              text: "-0.06171059372171178 ETH",
              color: Colors.red,
              size: 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            const ReusableTransferText(
              text: "~\$113,96",
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ReusableTransferText(
                    text: "Date",
                    size: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  ReusableTransferText(
                    text: "2-19-2023 18:12",
                    size: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReusableTransferText(
                    text: "Status",
                    size: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  ReusableTransferText(
                    text: "Completed",
                    size: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                    color: Colors.green.shade500,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ReusableTransferText(
                    text: "Transaction Type",
                    size: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  ReusableTransferText(
                    text: "Internal",
                    size: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReusableTransferText(
                    text: "Recipient",
                    size: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.green,
                        backgroundImage: AssetImage("assets/profile.png"),
                      ),
                      SizedBox(width: 5),
                      SizedBox(
                        width: 90,
                        child: ReusableTransferText(
                          text: "Sender Name",
                          size: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0,
                          color: Colors.grey,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ReusableTransferText(
                    text: "Network Fee",
                    size: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                  Spacer(),
                  Expanded(
                    child: ReusableTransferText(
                      text: "0.000333492745005 ETH(\$0.56)",
                      size: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                      color: Colors.grey,
                      align: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              child: const ReusableTransferText(
                text: "More Details",
                size: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
                color: secondaryColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableTransferText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final double letterSpacing;
  final FontWeight fontWeight;
  final TextOverflow textOverflow;
  final TextAlign align;
  const ReusableTransferText({
    Key key,
    @required this.text,
    this.color,
    this.size,
    this.fontWeight,
    this.letterSpacing = 2,
    this.textOverflow,
    this.align,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
        overflow: textOverflow,
      ),
      textAlign: align,
    );
  }
}
