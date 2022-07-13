import 'package:flutter/material.dart';
import 'package:voting_dapp/services/functions.dart';
import 'package:web3dart/web3dart.dart';
// ignore_for_file: prefer_const_constructors

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;

  const ElectionInfo(
      {Key? key, required this.ethClient, required this.electionName})
      : super(key: key);

  @override
  State<ElectionInfo> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizedVoterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
      ),
      body: Container(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FutureBuilder<Object>(
                        future: getCandidatesNum(widget.ethClient),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Text(
                            snapshot.data.toString().substring(0),
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                    SizedBox(
                      height: 13,
                    ),
                    Text(
                      'Total Candidates',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    FutureBuilder<Object>(
                        future: totalVote(widget.ethClient),
                        builder: (context, snapshot) {
                          return Text(
                            snapshot.data.toString().substring(0),
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }),
                    SizedBox(
                      height: 13,
                    ),
                    Text(
                      'Total Votes',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addCandidateController,
                    decoration: InputDecoration(
                      hintText: 'Enter Candidate Name',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    addCandidate(addCandidateController.text, widget.ethClient);
                  },
                  child: Text('Add Candidate'),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: authorizedVoterController,
                    decoration: InputDecoration(
                      hintText: 'Enter Voter Address',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    authorizedVoter(
                        authorizedVoterController.text, widget.ethClient);
                  },
                  child: Text('Authorize Voter'),
                )
              ],
            ),
            Divider(),
            FutureBuilder<List>(
              future: getCandidatesNum(widget.ethClient),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      for (int i = 0; i < snapshot.data![0].toInt(); i++)
                        FutureBuilder<List>(
                            future: candidateInfo(i, widget.ethClient),
                            builder: (context, candidatesnapshot) {
                              if (candidatesnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return ListTile(
                                  title: Text(
                                      'Name: ${candidatesnapshot.data![0][0]}'),
                                  subtitle: Text(
                                      'Votes: ${candidatesnapshot.data![0][1]}'),
                                  trailing: ElevatedButton(
                                      onPressed: () {
                                        vote(i, widget.ethClient);
                                      },
                                      child: Text('Vote')),
                                );
                              }
                            }),
                    ],
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
