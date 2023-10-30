import 'package:flutter/material.dart';
import 'package:taxischronodriver/screens/component/tansactionview.dart';

import '../modeles/autres/transaction.dart';
import '../varibles/variables.dart';

class MesRequettes extends StatefulWidget {
  const MesRequettes({super.key});

  @override
  State<MesRequettes> createState() => _MesRequettesState();
}

class _MesRequettesState extends State<MesRequettes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vos Courses",
            style: police.copyWith(fontWeight: FontWeight.bold)),
        backgroundColor: dredColor,
      ),
      body: StreamBuilder<List<TransactionApp>>(
          stream:
              TransactionApp.allTransaction(authentication.currentUser!.uid),
          builder: (context, snapshot) {
            return (snapshot.hasError)
                ? Center(
                    child: Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: police.copyWith(
                      fontSize: 18,
                    ),
                  ))
                : (!snapshot.hasData || snapshot.data!.isEmpty)
                    ? Center(
                        child: Text(
                        "Vous n'avez encors effectué aucune course",
                        textAlign: TextAlign.center,
                        style: police.copyWith(
                          fontSize: 18,
                        ),
                      ))
                    : ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return TransactionView(
                              transactionApp: snapshot.data![index]);
                        });
          }),
    );
  }
}
