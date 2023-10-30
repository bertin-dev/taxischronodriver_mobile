class Packages {
  final int idPackage;
  double prixPackage;
  final int nombreDeTickets;

  Packages({
    required this.prixPackage,
    required this.idPackage,
    required this.nombreDeTickets,
  });

  factory Packages.fromMap(Map<String, dynamic> package) => Packages(
      prixPackage: package['prixPackage'],
      idPackage: package['idPackage'],
      nombreDeTickets: package['nombreDeTickets']);

  Map<String, dynamic> toMap() => {
        "prixPackage": prixPackage,
        "idPackage": idPackage,
        "nombreDeTickets": nombreDeTickets,
      };
}
