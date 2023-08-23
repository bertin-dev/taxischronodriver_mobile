import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../varibles/variables.dart';

class CodePromocomponent extends StatefulWidget {
  const CodePromocomponent({super.key});

  @override
  State<CodePromocomponent> createState() => _CodePromocomponentState();
}

class _CodePromocomponentState extends State<CodePromocomponent> {
  TextEditingController controller = TextEditingController();
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: dredColor,
        elevation: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 35,
          ),
        ),
        title: Text(
          'Code promo taxi-chrono',
          style: police.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: loader ? const LoadingComponen() : codeComponent(),
    ));
  }

  Widget codeComponent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        child: Column(
          children: [
            spacerHeight(110),
            Text(
              "L'utilisation d'un code promo vous offre une réduction dans toutes vos transactions et des bonnus dans les services que vous payez chez TAXI CHONO",
              style: police.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.justify,
            ),
            spacerHeight(30),
            champsdeRecherche(
              changement: (val) {},
              hintext: "entrez votre code promo ici",
              iconData: Icons.book,
              controller: controller,
            ),
            spacerHeight(120),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (controller.text.trim().length < 4) {
                    Fluttertoast.showToast(
                        msg: 'Veillez remplir le code promo correctement',
                        backgroundColor: Colors.red,
                        toastLength: Toast.LENGTH_SHORT);
                  } else {
                    setState(() {
                      loader = true;
                    });
                    try {
                      await firestore
                          .collection("Codes Promo")
                          .doc(authentication.currentUser!.uid)
                          .set({
                        "code": controller.text,
                        "userid": authentication.currentUser!.uid,
                      }).then((value) {
                        setState(() {
                          loader = false;
                        });
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(
                            msg: 'Votre code promo a été validé avec succès',
                            backgroundColor: Colors.green,
                            toastLength: Toast.LENGTH_SHORT);
                      });
                    } catch (e) {
                      setState(() {
                        loader = false;
                      });
                    }
                  }
                },
                icon: const Icon(Icons.check, size: 40),
                label: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Valider',
                    style: police,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
            spacerHeight(10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, size: 40),
                label: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Annuler',
                    style: police,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
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
