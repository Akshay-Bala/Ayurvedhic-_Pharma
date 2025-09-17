class ModelPatientsList {
    ModelPatientsList({
        required this.status,
        required this.message,
        required this.patient,
    });

    final bool? status;
    final String? message;
    final List<Patient> patient;

    factory ModelPatientsList.fromJson(Map<String, dynamic> json){ 
        return ModelPatientsList(
            status: json["status"],
            message: json["message"],
            patient: json["patient"] == null ? [] : List<Patient>.from(json["patient"]!.map((x) => Patient.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "patient": patient.map((x) => x?.toJson()).toList(),
    };

}

class Patient {
    Patient({
        required this.id,
        required this.patientdetailsSet,
        required this.branch,
        required this.user,
        required this.payment,
        required this.name,
        required this.phone,
        required this.address,
        required this.price,
        required this.totalAmount,
        required this.discountAmount,
        required this.advanceAmount,
        required this.balanceAmount,
        required this.dateNdTime,
        required this.isActive,
        required this.createdAt,
        required this.updatedAt,
    });

    final int? id;
    final List<PatientdetailsSet> patientdetailsSet;
    final Branch? branch;
    final String? user;
    final String? payment;
    final String? name;
    final String? phone;
    final String? address;
    final dynamic price;
    final num? totalAmount;
    final num? discountAmount;
    final num? advanceAmount;
    final num? balanceAmount;
    final String? dateNdTime;
    final bool? isActive;
    final String? createdAt;
    final String? updatedAt;

    factory Patient.fromJson(Map<String, dynamic> json){ 
        return Patient(
            id: json["id"],
            patientdetailsSet: json["patientdetails_set"] == null ? [] : List<PatientdetailsSet>.from(json["patientdetails_set"]!.map((x) => PatientdetailsSet.fromJson(x))),
            branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
            user: json["user"],
            payment: json["payment"],
            name: json["name"],
            phone: json["phone"],
            address: json["address"],
            price: json["price"],
            totalAmount: json["total_amount"],
            discountAmount: json["discount_amount"],
            advanceAmount: json["advance_amount"],
            balanceAmount: json["balance_amount"],
            dateNdTime: json["date_nd_time"],
            isActive: json["is_active"],
            createdAt: json["created_at"],
            updatedAt: json["updated_at"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "patientdetails_set": patientdetailsSet.map((x) => x?.toJson()).toList(),
        "branch": branch?.toJson(),
        "user": user,
        "payment": payment,
        "name": name,
        "phone": phone,
        "address": address,
        "price": price,
        "total_amount": totalAmount,
        "discount_amount": discountAmount,
        "advance_amount": advanceAmount,
        "balance_amount": balanceAmount,
        "date_nd_time": dateNdTime,
        "is_active": isActive,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };

}

class Branch {
    Branch({
        required this.id,
        required this.name,
        required this.patientsCount,
        required this.location,
        required this.phone,
        required this.mail,
        required this.address,
        required this.gst,
        required this.isActive,
    });

    final int? id;
    final String? name;
    final num? patientsCount;
    final String? location;
    final String? phone;
    final String? mail;
    final String? address;
    final String? gst;
    final bool? isActive;

    factory Branch.fromJson(Map<String, dynamic> json){ 
        return Branch(
            id: json["id"],
            name: json["name"],
            patientsCount: json["patients_count"],
            location: json["location"],
            phone: json["phone"],
            mail: json["mail"],
            address: json["address"],
            gst: json["gst"],
            isActive: json["is_active"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "patients_count": patientsCount,
        "location": location,
        "phone": phone,
        "mail": mail,
        "address": address,
        "gst": gst,
        "is_active": isActive,
    };

}

class PatientdetailsSet {
    PatientdetailsSet({
        required this.id,
        required this.male,
        required this.female,
        required this.patient,
        required this.treatment,
        required this.treatmentName,
    });

    final int? id;
    final String? male;
    final String? female;
    final num? patient;
    final num? treatment;
    final String? treatmentName;

    factory PatientdetailsSet.fromJson(Map<String, dynamic> json){ 
        return PatientdetailsSet(
            id: json["id"],
            male: json["male"],
            female: json["female"],
            patient: json["patient"],
            treatment: json["treatment"],
            treatmentName: json["treatment_name"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "male": male,
        "female": female,
        "patient": patient,
        "treatment": treatment,
        "treatment_name": treatmentName,
    };

}
