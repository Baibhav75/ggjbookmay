import 'package:flutter/material.dart';
import '../../Model/sell_school_list_model.dart';
import '../../Service/HrmViewEmployee_service.dart';
import '../../Service/assign_recovery_service.dart';
import '../../Service/sell_school_list_service.dart';
import '/Model/HrmViewEmplyeeModel.dart';

class AssignRecoveryPage extends StatefulWidget {
  const AssignRecoveryPage({super.key});

  @override
  State<AssignRecoveryPage> createState() => _AssignRecoveryPageState();
}

class _AssignRecoveryPageState extends State<AssignRecoveryPage> {

  SellSchool? selectedSchool;
  EmployeeList? selectedEmployee;


  List<SellSchool> schoolList = [];
  List<EmployeeList> employeeList = [];

  bool isLoadingEmployee = false;
  bool isLoadingSchool = true;

  final HrmViewEmployeeService _employeeService =
  HrmViewEmployeeService();
  @override
  void initState() {
    super.initState();
    _fetchSchools();
  }

  /// 🔥 FETCH SCHOOL LIST API
  Future<void> _fetchSchools() async {
    try {
      final response = await SellSchoolListService.fetchSchools();

      setState(() {
        schoolList = response.schools;
        isLoadingSchool = false;
      });

    } catch (e) {
      setState(() {
        isLoadingSchool = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load schools")),
      );
    }
  }

  /// 🔥 FETCH EMPLOYEE FROM API
  Future<void> _fetchEmployees() async {
    setState(() {
      isLoadingEmployee = true;
    });

    try {
      final response = await _employeeService.fetchEmployees();

      setState(() {
        employeeList = response?.employeeList ?? [];
        isLoadingEmployee = false;
      });

    } catch (e) {
      setState(() {
        isLoadingEmployee = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load employees")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Recovery'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔹 SCHOOL DROPDOWN
            isLoadingSchool
                ? const CircularProgressIndicator()
                : DropdownButtonFormField<SellSchool>(
              value: selectedSchool,
              hint: const Text("Select School"),
              items: schoolList.map((school) {
                return DropdownMenuItem(
                  value: school,
                  child: Text(school.schoolName),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSchool = value;
                  selectedEmployee = null;
                  employeeList.clear();
                });

                // 🔥 CALL API AFTER SCHOOL SELECT
                _fetchEmployees();
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 EMPLOYEE DROPDOWN
            if (selectedSchool != null) ...[

              isLoadingEmployee
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<EmployeeList>(
                value: selectedEmployee,
                hint: const Text("Select Employee"),
                items: employeeList.map((emp) {
                  return DropdownMenuItem(
                    value: emp,
                    child: Text(emp.employeeName ?? "No Name"),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedEmployee = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 30),

            /// 🔹 SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (selectedSchool != null &&
                    selectedEmployee != null)
                    ? () async {

                  // 🔥 LOADER SHOW
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  // 🔥 API CALL
                  final result =
                  await AssignRecoveryService.assignRecovery(
                    schoolId: selectedSchool!.schoolId.toString(), // ✅ IMPORTANT FIX
                    employeeId: selectedEmployee!.employeid ?? "",
                  );

                  Navigator.pop(context); // ❌ close loader

                  // 🔥 RESPONSE HANDLE
                  if (result != null && result['success'] == true) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result['message'] ??
                              "Recovery Assigned Successfully",
                        ),
                      ),
                    );

                    // 🔥 RESET UI (optional but good)
                    setState(() {
                      selectedSchool = null;
                      selectedEmployee = null;
                      employeeList.clear();
                    });

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result?['message'] ?? "Assignment failed",
                        ),
                      ),
                    );
                  }
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1F4BA5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Assign",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}