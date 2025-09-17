import 'package:flutter/material.dart';
import 'package:machine_test/Models/model_patientlist.dart';
import 'package:machine_test/Views/pdfview.dart';
import 'package:machine_test/Views/viewpage.dart';

class Registerpage extends StatelessWidget {
  final Patient? patient;
  Registerpage({super.key, this.patient});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController treatmentDateController = TextEditingController();

  final ValueNotifier<List<Map<String, TextEditingController>>>
  treatmentsNotifier = ValueNotifier<List<Map<String, TextEditingController>>>(
    [],
  );

  void addTreatment() {
    treatmentsNotifier.value = List.from(treatmentsNotifier.value)
      ..add({
        'name': TextEditingController(),
        'men': TextEditingController(),
        'women': TextEditingController(),
      });
  }

  void removeTreatment(int index) {
    treatmentsNotifier.value = List.from(treatmentsNotifier.value)
      ..removeAt(index);
  }

  @override
  Widget build(BuildContext context) {
    if (patient != null) {
      nameController.text = patient!.name ?? '';
      whatsappController.text = patient!.phone ?? '';
      addressController.text = patient!.address ?? '';
      locationController.text = patient!.branch!.location ?? "";
      totalAmountController.text = patient!.totalAmount?.toString() ?? '';
      discountController.text = patient!.discountAmount?.toString() ?? '';
      advanceController.text = patient!.advanceAmount?.toString() ?? '';
      balanceController.text = patient!.balanceAmount?.toString() ?? '';
      treatmentDateController.text =
          patient!.dateNdTime?.toString().split(' ')[0] ?? '';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(patient != null ? 'Edit Booking' : 'New Booking'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Viewpage()),
            );
          },
        ),
        actions: [
          IconButton(icon: Icon(Icons.notifications_sharp), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField('Name', nameController),
              SizedBox(height: 15),
              _buildTextField(
                'WhatsApp Number',
                whatsappController,
                TextInputType.phone,
              ),
              SizedBox(height: 15),
              _buildTextField(
                'Address',
                addressController,
                TextInputType.multiline,
                3,
              ),
              SizedBox(height: 15),
              _buildTextField('Location', locationController),
              SizedBox(height: 15),
              _buildTextField('Branch', branchController),
              SizedBox(height: 15),
              _buildTextField(
                'Total Amount',
                totalAmountController,
                TextInputType.number,
              ),
              SizedBox(height: 15),
              _buildTextField(
                'Discount Amount',
                discountController,
                TextInputType.number,
              ),
              SizedBox(height: 15),
              _buildTextField(
                'Advance Amount',
                advanceController,
                TextInputType.number,
              ),
              SizedBox(height: 15),
              _buildTextField(
                'Balance Amount',
                balanceController,
                TextInputType.number,
              ),
              SizedBox(height: 15),
              _buildTextField(
                'Treatment Date',
                treatmentDateController,
                TextInputType.datetime,
              ),
              SizedBox(height: 20),

              ValueListenableBuilder<List<Map<String, TextEditingController>>>(
                valueListenable: treatmentsNotifier,
                builder: (context, treatments, child) {
                  return Column(
                    children: List.generate(treatments.length, (index) {
                      var treatment = treatments[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Treatment ${index + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => removeTreatment(index),
                                    icon: Icon(Icons.close, color: Colors.red),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              _buildTextField('Combo Name', treatment['name']!),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildTextField(
                                      'No. of Men',
                                      treatment['men']!,
                                      TextInputType.number,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: _buildTextField(
                                      'No. of Women',
                                      treatment['women']!,
                                      TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: addTreatment,
                  icon: Icon(Icons.add, color: Color(0xFF006837)),
                  label: Text(
                    'Add Treatment',
                    style: TextStyle(color: Color(0xFF006837)),
                  ),
                ),
              ),
              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Booking saved successfully!')),
  );

  List<PatientdetailsSet> details = treatmentsNotifier.value.map((treatmentMap) {
    return PatientdetailsSet(
      id: null,
      treatment: null,
      treatmentName: treatmentMap['name']!.text.isNotEmpty ? treatmentMap['name']!.text : '-',
      male: treatmentMap['men']!.text.isNotEmpty ? treatmentMap['men']!.text : '0',
      female: treatmentMap['women']!.text.isNotEmpty ? treatmentMap['women']!.text : '0',
      patient: double.tryParse(totalAmountController.text) ?? 0,
    );
  }).toList();

  final updatedPatient = Patient(
    id: patient?.id ?? 0,
    isActive: true,
    payment: "",
    price: "",
    updatedAt: "",
    user: "",
    createdAt: "",
    name: nameController.text,
    phone: whatsappController.text,
    address: addressController.text,
    totalAmount: double.tryParse(totalAmountController.text),
    discountAmount: double.tryParse(discountController.text),
    advanceAmount: double.tryParse(advanceController.text),
    balanceAmount: double.tryParse(balanceController.text),
    dateNdTime: treatmentDateController.text,
    branch: patient?.branch,
    patientdetailsSet: details,
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PdfExportAndViewPage(patient: updatedPatient),
    ),
  );
},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF006837),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Save & Generate Bill',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, [
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }
}
