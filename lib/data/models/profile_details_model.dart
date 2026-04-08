import '../../domain/entities/profile_details.dart';
import 'delivery_partner_model.dart';

class ProfileDetailsModel extends ProfileDetails {
  const ProfileDetailsModel({
    required DeliveryPartnerModel super.deliveryPartner,
    required VehicleDetailsModel super.vehicleDetails,
    required BankDetailsModel super.bankDetails,
    required List<DocumentDetailsModel> super.documents,
  });

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final documentsJson = data['delivery_documents'] as List<dynamic>? ?? [];

    return ProfileDetailsModel(
      deliveryPartner: DeliveryPartnerModel.fromJson(
        data['delivery_partner'] as Map<String, dynamic>? ?? {},
      ),
      vehicleDetails: VehicleDetailsModel.fromJson(
        data['delivery_vehicle_details'] as Map<String, dynamic>? ?? {},
      ),
      bankDetails: BankDetailsModel.fromJson(
        data['delivery_bank_details'] as Map<String, dynamic>? ?? {},
      ),
      documents:
          documentsJson
              .map(
                (item) => DocumentDetailsModel.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryPartner': (deliveryPartner as DeliveryPartnerModel).toJson(),
      'vehicleDetails': (vehicleDetails as VehicleDetailsModel).toJson(),
      'bankDetails': (bankDetails as BankDetailsModel).toJson(),
      'documents':
          documents
              .map((item) => (item as DocumentDetailsModel).toJson())
              .toList(),
    };
  }
}

class VehicleDetailsModel extends VehicleDetails {
  const VehicleDetailsModel({
    required super.vehicleType,
    required super.vehicleNumber,
    required super.status,
  });

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    return VehicleDetailsModel(
      vehicleType: (json['vehicle_type'] ?? '').toString(),
      vehicleNumber: (json['vehicle_number'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'status': status,
    };
  }
}

class BankDetailsModel extends BankDetails {
  const BankDetailsModel({
    required super.bankName,
    required super.accountNumber,
    required super.ifscCode,
    required super.accountType,
    required super.status,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      bankName: (json['bank_name'] ?? '').toString(),
      accountNumber: (json['account_number'] ?? '').toString(),
      ifscCode: (json['ifsc_code'] ?? '').toString(),
      accountType: (json['account_type'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_name': bankName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'account_type': accountType,
      'status': status,
    };
  }
}

class DocumentDetailsModel extends DocumentDetails {
  const DocumentDetailsModel({
    required super.documentType,
    required super.documentName,
    required super.documentNumber,
    required super.status,
  });

  factory DocumentDetailsModel.fromJson(Map<String, dynamic> json) {
    return DocumentDetailsModel(
      documentType: (json['document_type'] ?? '').toString(),
      documentName: (json['document_name'] ?? '-').toString(),
      documentNumber: (json['document_number'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_type': documentType,
      'document_name': documentName,
      'document_number': documentNumber,
      'status': status,
    };
  }
}
