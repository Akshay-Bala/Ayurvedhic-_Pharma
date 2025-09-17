class ModelTreatmentList {
    ModelTreatmentList({
        required this.status,
        required this.message,
        required this.treatments,
    });

    final bool? status;
    final String? message;
    final List<Treatment> treatments;

    factory ModelTreatmentList.fromJson(Map<String, dynamic> json){ 
        return ModelTreatmentList(
            status: json["status"],
            message: json["message"],
            treatments: json["treatments"] == null ? [] : List<Treatment>.from(json["treatments"]!.map((x) => Treatment.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "treatments": treatments.map((x) => x?.toJson()).toList(),
    };

}

class Treatment {
    Treatment({
        required this.id,
        required this.branches,
        required this.name,
        required this.duration,
        required this.price,
        required this.isActive,
        required this.createdAt,
        required this.updatedAt,
    });

    final int? id;
    final List<Branch> branches;
    final String? name;
    final String? duration;
    final String? price;
    final bool? isActive;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    factory Treatment.fromJson(Map<String, dynamic> json){ 
        return Treatment(
            id: json["id"],
            branches: json["branches"] == null ? [] : List<Branch>.from(json["branches"]!.map((x) => Branch.fromJson(x))),
            name: json["name"],
            duration: json["duration"],
            price: json["price"],
            isActive: json["is_active"],
            createdAt: DateTime.tryParse(json["created_at"] ?? ""),
            updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "branches": branches.map((x) => x?.toJson()).toList(),
        "name": name,
        "duration": duration,
        "price": price,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
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
