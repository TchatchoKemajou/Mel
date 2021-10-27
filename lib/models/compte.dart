class Compte{
  final String compteId;
  final String compteName;
  final String compteEmail;
  final String comptePasssword;
  final String compteProfil;
  final String comptePhone;
  final Map<String, dynamic> compteAddress;
  final String compteType;
  final int compteFacture;
  final int compteCouponTotal;
  final int compteCouponUtiliser;
  final List<String> compteAbonnes;
  final List<String> compteAbonnement;
  final int compteWalter;
  final String comptePaiementMode;
  final DateTime compteCreateDate;

  Compte({this.compteId, this.compteName, this.compteEmail, this.comptePasssword, this.compteProfil, this.comptePhone, this.compteAddress, this.compteType,
    this.compteFacture, this.compteCouponTotal, this.compteCouponUtiliser, this.compteAbonnes, this.compteAbonnement, this.compteWalter, this.comptePaiementMode, this.compteCreateDate});

  factory Compte.fromJson(Map<String, dynamic> json){
    return Compte(
        compteId: json['compteId'] == null ? "" : json['compteId'],
        compteName: json['compteName'] == null ? "" : json['compteName'],
        compteEmail: json['compteEmail'] == null ? "" : json['compteEmail'],
        comptePasssword: json['comptePasssword'] == null ? "" : json['comptePasssword'],
        compteProfil: json['compteProfil'] == null ? "" : json['compteProfil'],
        comptePhone: json['comptePhone'] == null ?  "" : json['comptePhone'],
        compteAddress: json['compteAddress'] == null ? [] : json['compteAddress'],
        compteType: json['compteType'] == null ? "" : json['compteType'],
        compteFacture: json['compteFacture'] == null ? 0 : json['compteFacture'],
        compteCouponTotal: json['compteCouponTotal'] == null ? 0 : json['compteCouponTotal'],
        compteCouponUtiliser: json['compteCouponUtiliser'] == null ? 0 : json['compteCouponUtiliser'],
        compteAbonnes: json['compteAbonnes'] == null ? [] : json['compteAbonnes'].map<String>((i) => i as String).toList(),
    compteAbonnement: json['compteAbonnement'] == null ? [] : json['compteAbonnement'].map<String>((i) => i as String).toList(),
    compteWalter: json['compteWalter'] == null ? 0 : json['compteWalter'],
    comptePaiementMode: json['comptePaiementMode'] == null ? "" : json['comptePaiementMode'],
    compteCreateDate: json['compteCreateDate'] == null ? DateTime.now() : json['compteCreateDate'].toDate()
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'compteId' : compteId,
      'compteName': compteName,
      'compteEmail': compteEmail,
      'comptePasssword' : comptePasssword,
      'compteProfil' : compteProfil,
      'comptePhone' : comptePhone,
      'compteAddress' : compteAddress,
      'compteType' : compteType,
      'compteFacture' : compteFacture,
      'compteCouponTotal' : compteCouponTotal,
      'compteCouponUtiliser' : compteCouponUtiliser,
      'compteAbonnes': compteAbonnes,
      'compteAbonnement': compteAbonnement,
      'compteWalter' : compteWalter,
      'comptePaiementMode' : comptePaiementMode,
      'compteCreateDate' : compteCreateDate
    };
  }
}