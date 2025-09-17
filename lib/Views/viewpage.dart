import 'package:flutter/material.dart';
import 'package:machine_test/Controllers/fetchPatients.dart';
import 'package:machine_test/Controllers/logincontrollr.dart';
import 'package:machine_test/Views/loginpage.dart';
import 'package:machine_test/Views/registerpage.dart';
import 'package:provider/provider.dart';

class Viewpage extends StatelessWidget {
  Viewpage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final loginController = Provider.of<LoginController>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('View Page'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Loginpage()),
            );
          },
        ),
        actions: [
          IconButton(icon: Icon(Icons.notifications_sharp), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Search for treatments',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF006837),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Search',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                    ),
                    hint: Text('Sort By'),
                    items: ['Name', 'Date', 'ID']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select Date',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {}
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            Expanded(
              child: Consumer<PatientProvider>(
                builder: (context, patientProvider, child) {
                  if (patientProvider.patients.isEmpty &&
                      !patientProvider.loading) {
                    patientProvider.fetchPatients(loginController.token);
                  }

                  if (patientProvider.loading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (patientProvider.patients.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_off, size: 80, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'No patients found',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: patientProvider.patients.length,
                    itemBuilder: (context, index) {
                      final patient = patientProvider.patients[index];
                      return Card(
                        elevation: 2,
                        color: Colors.green.shade100,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ID: ${patient.id} - ${patient.name ?? 'No Name'}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                             Text(
  'Date: ${patient.dateNdTime != null ? patient.dateNdTime!.toString().split(' ')[0] : '-'}',
),

                              SizedBox(height: 4),
                              Text(patient.address ?? '-'),
                              Divider(height: 20, thickness: 1),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'View Booking Details',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Registerpage(patient: patient,token: loginController.token,),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: screenWidth,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Registerpage(patient: null,token: loginController.token,),
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
                  'Register',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
