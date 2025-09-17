import 'package:flutter/material.dart';
import 'package:machine_test/Controllers/fetchTreatementlist.dart';
import 'package:machine_test/Views/pdfview.dart';
import 'package:provider/provider.dart';
import '../Models/model_patientlist.dart' as patientModel;
import '../Models/model_treatmentList.dart';
import 'viewpage.dart';

class Registerpage extends StatefulWidget {
  final patientModel.Patient? patient;
  final String token;

  Registerpage({super.key, this.patient, required this.token});

  @override
  _RegisterpageState createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
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

  final ValueNotifier<String> paymentTypeNotifier =
      ValueNotifier<String>('Cash');
  final ValueNotifier<List<Map<String, TextEditingController>>>
      treatmentsNotifier = ValueNotifier<List<Map<String, TextEditingController>>>(
          []);

  @override
  void initState() {
    super.initState();

    // Fetch treatments using Provider
    Future.microtask(() {
      Provider.of<TreatmentProvider>(context, listen: false)
          .fetchTreatments(widget.token);
    });

    if (widget.patient != null) {
      nameController.text = widget.patient!.name ?? '';
      whatsappController.text = widget.patient!.phone ?? '';
      addressController.text = widget.patient!.address ?? '';
      locationController.text = widget.patient!.branch?.location ?? '';
      totalAmountController.text =
          widget.patient!.totalAmount?.toString() ?? '';
      discountController.text =
          widget.patient!.discountAmount?.toString() ?? '';
      advanceController.text =
          widget.patient!.advanceAmount?.toString() ?? '';
      balanceController.text =
          widget.patient!.balanceAmount?.toString() ?? '';
      treatmentDateController.text =
          widget.patient!.dateNdTime?.toString().split(' ')[0] ?? '';
    }

    totalAmountController.addListener(_updateBalance);
    discountController.addListener(_updateBalance);
    advanceController.addListener(_updateBalance);
  }

  void _updateBalance() {
    double total = double.tryParse(totalAmountController.text) ?? 0;
    double discount = double.tryParse(discountController.text) ?? 0;
    double advance = double.tryParse(advanceController.text) ?? 0;
    balanceController.text = (total - (discount + advance)).toStringAsFixed(2);
  }

  void addTreatment({Treatment? treatment, int men = 0, int women = 0}) {
    if (treatment == null) return;

    double price = double.tryParse(treatment.price ?? '0') ?? 0;
    double totalForTreatment = price * (men + women);

    totalAmountController.text =
        ((double.tryParse(totalAmountController.text) ?? 0) + totalForTreatment)
            .toStringAsFixed(2);

    treatmentsNotifier.value = List.from(treatmentsNotifier.value)
      ..add({
        'name': TextEditingController(text: treatment.name ?? ''),
        'men': TextEditingController(text: men.toString()),
        'women': TextEditingController(text: women.toString()),
      });

    _updateBalance();
  }

  void removeTreatment(int index) {
    if (index >= treatmentsNotifier.value.length) return;

    var treatment = treatmentsNotifier.value[index];
    String name = treatment['name']!.text;
    int men = int.tryParse(treatment['men']!.text) ?? 0;
    int women = int.tryParse(treatment['women']!.text) ?? 0;

    var t = Provider.of<TreatmentProvider>(context, listen: false).treatments
        .firstWhere(
      (tr) => tr.name == name,
      orElse: () => Treatment(
        name: name,
        price: '0',
        id: null,
        branches: [],
        duration: '',
        isActive: null,
        createdAt: null,
        updatedAt: null,
      ),
    );

    double price = double.tryParse(t.price ?? '0') ?? 0;
    double totalForTreatment = price * (men + women);

    totalAmountController.text =
        ((double.tryParse(totalAmountController.text) ?? 0) - totalForTreatment)
            .toStringAsFixed(2);

    treatmentsNotifier.value = List.from(treatmentsNotifier.value)..removeAt(index);
    _updateBalance();
  }

  void addTreatmentDialog(BuildContext context) {
    Treatment? selectedTreatment;
    final TextEditingController menController = TextEditingController();
    final TextEditingController womenController = TextEditingController();

    final provider = Provider.of<TreatmentProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Treatment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                provider.loading
                    ? CircularProgressIndicator()
                    : DropdownButtonFormField<Treatment?>(
                        value: selectedTreatment,
                        items: provider.treatments.map((t) {
                          return DropdownMenuItem<Treatment?>(
                            value: t,
                            child: Text(t.name ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) => selectedTreatment = value,
                        decoration: InputDecoration(
                          labelText: 'Select Treatment',
                          border: OutlineInputBorder(),
                        ),
                      ),
                SizedBox(height: 10),
                TextFormField(
                  controller: menController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'No. of Men',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: womenController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'No. of Women',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                int men = int.tryParse(menController.text) ?? 0;
                int women = int.tryParse(womenController.text) ?? 0;

                if (selectedTreatment != null) {
                  addTreatment(
                    treatment: selectedTreatment,
                    men: men,
                    women: women,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a treatment')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
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
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TreatmentProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.patient != null ? 'Edit Booking' : 'New Booking'),
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField('Name', nameController),
            SizedBox(height: 15),
            _buildTextField('WhatsApp Number', whatsappController, TextInputType.phone),
            SizedBox(height: 15),
            _buildTextField('Address', addressController, TextInputType.multiline, 3),
            SizedBox(height: 15),
            _buildTextField('Location', locationController),
            SizedBox(height: 15),
            _buildTextField('Branch', branchController),
            SizedBox(height: 15),
            Text('Payment Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ValueListenableBuilder<String>(
              valueListenable: paymentTypeNotifier,
              builder: (context, paymentType, child) {
                return Row(
                  children: ['Cash', 'Credit', 'Card'].map((type) {
                    return Row(
                      children: [
                        Radio<String>(
                          value: type,
                          groupValue: paymentType,
                          onChanged: (value) => paymentTypeNotifier.value = value!,
                        ),
                        Text(type),
                        SizedBox(width: 10),
                      ],
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 15),
            _buildTextField('Total Amount', totalAmountController, TextInputType.number),
            SizedBox(height: 15),
            _buildTextField('Discount Amount', discountController, TextInputType.number),
            SizedBox(height: 15),
            _buildTextField('Advance Amount', advanceController, TextInputType.number),
            SizedBox(height: 15),
            _buildTextField('Balance Amount', balanceController, TextInputType.number),
            SizedBox(height: 15),
            _buildTextField('Treatment Date', treatmentDateController, TextInputType.datetime),
            SizedBox(height: 20),

            // Treatments List
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
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Treatment ${index + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  onPressed: () => removeTreatment(index),
                                  icon: Icon(Icons.close, color: Colors.red),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            provider.loading
                                ? CircularProgressIndicator()
                                : DropdownButtonFormField<Treatment?>(
                                    value: provider.treatments.isNotEmpty
                                        ? provider.treatments.firstWhere(
                                            (t) => t.name == treatment['name']!.text,
                                            orElse: () => provider.treatments.first,
                                          )
                                        : null,
                                    items: provider.treatments.map((t) {
                                      return DropdownMenuItem<Treatment?>(
                                        value: t,
                                        child: Text(t.name ?? ''),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        treatment['name']!.text = value?.name ?? '';
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Select Treatment',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: treatment['men'],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'No. of Men',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: treatment['women'],
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'No. of Women',
                                      border: OutlineInputBorder(),
                                    ),
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
                onPressed: () => addTreatmentDialog(context),
                icon: Icon(Icons.add, color: Color(0xFF006837)),
                label: Text('Add Treatment', style: TextStyle(color: Color(0xFF006837))),
              ),
            ),
            SizedBox(height: 20),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  List<patientModel.PatientdetailsSet> patientDetails =
                      treatmentsNotifier.value.map((t) {
                    return patientModel.PatientdetailsSet(
                      id: null,
                      male: t['men']!.text,
                      female: t['women']!.text,
                      patient: null,
                      treatment: null,
                      treatmentName: t['name']!.text,
                    );
                  }).toList();

                  final patient = patientModel.Patient(
                    id: null,
                    name: nameController.text,
                    phone: whatsappController.text,
                    address: addressController.text,
                    branch: patientModel.Branch(
                      location: locationController.text,
                      id: null,
                      name: branchController.text,
                      patientsCount: 0,
                      phone: '',
                      mail: '',
                      address: '',
                      gst: '',
                      isActive: true,
                    ),
                    totalAmount: double.tryParse(totalAmountController.text),
                    discountAmount: double.tryParse(discountController.text),
                    advanceAmount: double.tryParse(advanceController.text),
                    balanceAmount: double.tryParse(balanceController.text),
                    dateNdTime: treatmentDateController.text,
                    patientdetailsSet: patientDetails,
                    user: '',
                    payment: paymentTypeNotifier.value,
                    price: null,
                    isActive: true,
                    createdAt: '',
                    updatedAt: '',
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfExportAndViewPage(patient: patient),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF006837),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Save & Generate Bill',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
