import 'delivery_partner.dart';

class ProfileDetails {
  const ProfileDetails({
    required this.deliveryPartner,
    required this.vehicleDetails,
    required this.bankDetails,
    required this.documents,
  });

  final DeliveryPartner deliveryPartner;
  final VehicleDetails vehicleDetails;
  final BankDetails bankDetails;
  final List<DocumentDetails> documents;
}

class VehicleDetails {
  const VehicleDetails({
    required this.vehicleType,
    required this.vehicleNumber,
    required this.status,
  });

  final String vehicleType;
  final String vehicleNumber;
  final String status;
}

class BankDetails {
  const BankDetails({
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.accountType,
    required this.status,
  });

  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String accountType;
  final String status;
}

class DocumentDetails {
  const DocumentDetails({
    required this.documentType,
    required this.documentName,
    required this.documentNumber,
    required this.status,
  });

  final String documentType;
  final String documentName;
  final String documentNumber;
  final String status;
}
