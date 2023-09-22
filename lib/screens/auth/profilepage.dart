import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:taxischronodriver/modeles/autres/transaction.dart';

import '../../varibles/variables.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: dredColor,
        body: SingleChildScrollView(
          // physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await authentication.signOut();
                      },
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Mon Profil',
                  textAlign: TextAlign.center,
                  style: police.copyWith(
                      fontSize: 30, fontWeight: FontWeight.w800, color: blanc),
                ),
                const SizedBox(
                  height: 22,
                ),
                SizedBox(
                  height: height * 0.43,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      double innerHeight = constraints.maxHeight;
                      double innerWidth = constraints.maxWidth;
                      return Stack(
                        // fit: StackFit.expand,
                        children: [
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: innerHeight * 0.72,
                              width: innerWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 80,
                                    ),
                                    Text(
                                        authentication
                                            .currentUser!.displayName!,
                                        textAlign: TextAlign.center,
                                        style: police.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              'Ma note',
                                              style: police.copyWith(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade700),
                                            ),

                                            // La note .

                                            StreamBuilder<List<TransactionApp>>(
                                                stream: TransactionApp
                                                    .allTransaction(
                                                        authentication
                                                            .currentUser!.uid),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasError &&
                                                      snapshot.hasData &&
                                                      snapshot.data != null) {
                                                    var note = 0.0;
                                                    for (var i
                                                        in snapshot.data!) {
                                                      note += i.noteChauffeur ??
                                                          2.5;
                                                    }
                                                    note = note /
                                                        snapshot.data!.length;
                                                    return RatingBar.builder(
                                                      initialRating: note,
                                                      // minRating: 1,
                                                      maxRating: note,
                                                      minRating: note,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 17,
                                                      itemBuilder:
                                                          (context, _) =>
                                                              const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        // print(rating);
                                                      },
                                                    );
                                                  } else {
                                                    // print(snapshot.error);
                                                    return const Center(
                                                      child: LoadingComponen(),
                                                    );
                                                  }
                                                }),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 25,
                                            vertical: 8,
                                          ),
                                          child: Container(
                                            height: 50,
                                            width: 3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Mes Trajets',
                                              style: police.copyWith(
                                                  fontSize: 16,
                                                  color: Colors.grey.shade700),
                                            ),
                                            StreamBuilder<List<TransactionApp>>(
                                                stream: TransactionApp
                                                    .allTransaction(
                                                        authentication
                                                            .currentUser!.uid),
                                                builder: (context, snapshot) {
                                                  return Text(
                                                    !snapshot.hasError &&
                                                            snapshot.hasData
                                                        ? snapshot.data!.length
                                                            .toString()
                                                        : '0',
                                                    style: police.copyWith(
                                                        fontSize: 16,
                                                        color: Colors
                                                            .grey.shade700),
                                                  );
                                                }),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   top: 110,
                          //   right: 20,
                          //   child: Icon(
                          //     Icons.settings,
                          //     color: Colors.grey[700],
                          //     size: 30,
                          //   ),
                          // ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Center(
                                  child: Image.asset(
                                    'images/user.png',
                                    width: innerWidth * 0.45,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: height * 0.5,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        spacerHeight(20),

                        // commentaires sur le chauffeurs.

                        Text(
                          'Commentaires et remarques',
                          style: police.copyWith(
                              color: const Color.fromRGBO(39, 105, 171, 1),
                              fontSize: 18),
                        ),
                        const Divider(
                          thickness: 1.5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: StreamBuilder<List<TransactionApp>>(
                              stream: TransactionApp.allTransaction(
                                  authentication.currentUser!.uid),
                              builder: (context, snapshot) {
                                return !snapshot.hasError &&
                                        snapshot.hasData &&
                                        snapshot.data!.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          final data = snapshot.data!;
                                          if (data[index]
                                                      .commentaireClientSurLeChauffeur !=
                                                  null &&
                                              data[index]
                                                  .commentaireClientSurLeChauffeur!
                                                  .trim()
                                                  .isNotEmpty) {
                                            return Container(
                                              margin: const EdgeInsets.all(5),
                                              padding: const EdgeInsets.all(18),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(30),
                                                  topRight: Radius.circular(30),
                                                  bottomLeft:
                                                      Radius.circular(30),
                                                ),
                                                color: Colors.blue.shade100,
                                              ),
                                              child: Center(
                                                  child: Text(data[index]
                                                      .commentaireClientSurLeChauffeur!)),
                                            );
                                          } else {
                                            return const SizedBox.shrink();
                                          }
                                        })
                                    : snapshot.hasData && snapshot.data!.isEmpty
                                        ? const Padding(
                                            padding: EdgeInsets.only(top: 100),
                                            child: Center(
                                                child: Icon(
                                                    Icons.hourglass_empty)),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.only(top: 100),
                                            child: Center(
                                              child: LoadingComponen(),
                                            ),
                                          );
                              }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
