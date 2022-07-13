import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:voting_dapp/pages/elecrtionInfo.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:voting_dapp/utils/constants.dart';
import 'package:web3dart/web3dart.dart';
// ignore_for_file: prefer_const_constructors

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(infuraUrl, httpClient!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Start Election'),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                hintText: "Enter Election Name",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                  onPressed: () async {
                    if (controller.text.isNotEmpty) {
                      await startElection(controller.text, ethClient!);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ElectionInfo(
                                  ethClient: ethClient!,
                                  electionName: controller.text)));
                    }
                  },
                  child: Text('Start Election')),
            ),
          ],
        ),
      ),
    );
  }
}
