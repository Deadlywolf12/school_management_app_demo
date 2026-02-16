import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:school_management_demo/models/classes_model.dart';
import 'package:school_management_demo/models/subjects_model.dart';
import 'package:school_management_demo/models/user_account_models.dart';
import 'package:school_management_demo/provider/classes_pro.dart';
import 'package:school_management_demo/provider/subjects_pro.dart';
import 'package:school_management_demo/provider/user_registration_provider.dart';
import 'package:school_management_demo/theme/colors.dart';
import 'package:school_management_demo/theme/spacing.dart';

class UserCreationScreen extends StatefulWidget {
  const UserCreationScreen({Key? key}) : super(key: key);

  @override
  State<UserCreationScreen> createState() => _UserCreationScreenState();
}

class _UserCreationScreenState extends State<UserCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Primary color
  static const Color primaryColor = Color(0xFF77CED9);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSubjects();
      fetchClasses();
    });
  }

  // Controllers for common fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Controllers for Student
  final _studentNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _enrollmentYearController = TextEditingController();
  final _emergencyNumberController = TextEditingController();
  final _studentAddressController = TextEditingController();

  // Controllers for Teacher
  final _teacherNameController = TextEditingController();
  final _teacherEmployeeIdController = TextEditingController();
  final _teacherPhoneController = TextEditingController();
  final _teacherAddressController = TextEditingController();
  final _salaryController = TextEditingController();

  // Controllers for Staff
  final _staffNameController = TextEditingController();
  final _staffEmployeeIdController = TextEditingController();
  final _staffPhoneController = TextEditingController();
  final _staffAddressController = TextEditingController();
  final _staffSalaryController = TextEditingController();

  // Controllers for Parent
  final _parentNameController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  final _parentAddressController = TextEditingController();

  // Selected values
  String _selectedRole = 'student';
  String? _selectedGender;
  String? _selectedDepartment;
  SchoolClass? _selectedClass; // ✅ Changed to SchoolClass object
  Subject? _selectedSubject; // ✅ Already correct
  String? _selectedBloodGroup;
  DateTime? _dateOfBirth;
  DateTime? _joiningDate;

  // Dropdown options
  final List<String> _roles = ['admin', 'student', 'teacher', 'staff', 'parent'];
  final List<String> _genders = ['male', 'female'];
  final List<String> _departments = [
    'Science',
    'Mathematics',
    'English',
    'Social Studies',
    'Computer Science',
    'Arts',
    'Physical Education',
    'Administration',
    'Finance',
    'Maintenance',
  ];
  
  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _emailController.dispose();
    _passwordController.dispose();
    _studentNameController.dispose();
    _studentIdController.dispose();
    _enrollmentYearController.dispose();
    _emergencyNumberController.dispose();
    _studentAddressController.dispose();
    _teacherNameController.dispose();
    _teacherEmployeeIdController.dispose();
    _teacherPhoneController.dispose();
    _teacherAddressController.dispose();
    _salaryController.dispose();
    _staffNameController.dispose();
    _staffEmployeeIdController.dispose();
    _staffPhoneController.dispose();
    _staffAddressController.dispose();
    _staffSalaryController.dispose();
    _parentNameController.dispose();
    _guardianNameController.dispose();
    _parentPhoneController.dispose();
    _parentAddressController.dispose();
  }

  void _clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _studentNameController.clear();
    _studentIdController.clear();
    _enrollmentYearController.clear();
    _emergencyNumberController.clear();
    _studentAddressController.clear();
    _teacherNameController.clear();
    _teacherEmployeeIdController.clear();
    _teacherPhoneController.clear();
    _teacherAddressController.clear();
    _salaryController.clear();
    _staffNameController.clear();
    _staffEmployeeIdController.clear();
    _staffPhoneController.clear();
    _staffAddressController.clear();
    _staffSalaryController.clear();
    _parentNameController.clear();
    _guardianNameController.clear();
    _parentPhoneController.clear();
    _parentAddressController.clear();

    setState(() {
      _selectedGender = null;
      _selectedDepartment = null;
      _selectedClass = null;
      _selectedSubject = null;
      _selectedBloodGroup = null;
      _dateOfBirth = null;
      _joiningDate = null;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isDateOfBirth) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: isDateOfBirth ? DateTime(1950) : DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isDateOfBirth) {
          _dateOfBirth = picked;
        } else {
          _joiningDate = picked;
        }
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<UserRegistrationProvider>();

    // Create user account
    final account = UserAccount(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: _selectedRole,
    );

    UserRegistration registration;

    // Create role-specific details
    if (_selectedRole == 'student') {
      final studentDetails = StudentDetails(
        name: _studentNameController.text.trim(),
        studentId: _studentIdController.text.trim(),
        classLevel: _selectedClass!.id, // ✅ Pass class ID
        enrollmentYear: int.parse(_enrollmentYearController.text.trim()),
        emergencyNumber: _emergencyNumberController.text.trim().isNotEmpty
            ? _emergencyNumberController.text.trim()
            : null,
        address: _studentAddressController.text.trim().isNotEmpty
            ? _studentAddressController.text.trim()
            : null,
        bloodGroup: _selectedBloodGroup,
        dateOfBirth: _dateOfBirth,
        gender: _selectedGender,
      );

      registration = UserRegistration(
        account: account,
        studentDetails: studentDetails,
      );
    } else if (_selectedRole == 'teacher') {
      final teacherDetails = TeacherDetails(
        name: _teacherNameController.text.trim(),
        employeeId: _teacherEmployeeIdController.text.trim(),
        department: _selectedDepartment!,
        subject: _selectedSubject!.id, // ✅ Pass subject ID
        phoneNumber: _teacherPhoneController.text.trim(),
        address: _teacherAddressController.text.trim().isNotEmpty
            ? _teacherAddressController.text.trim()
            : null,
        joiningDate: _joiningDate!,
        salary: _salaryController.text.trim(),
        gender: _selectedGender,
      );

      registration = UserRegistration(
        account: account,
        teacherDetails: teacherDetails,
      );
    } else if (_selectedRole == 'staff') {
      final staffDetails = StaffDetails(
        name: _staffNameController.text.trim(),
        employeeId: _staffEmployeeIdController.text.trim(),
        department: _selectedDepartment!,
        roleDetails: '', // You can add a field for this
        phoneNumber: _staffPhoneController.text.trim(),
        address: _staffAddressController.text.trim().isNotEmpty
            ? _staffAddressController.text.trim()
            : null,
        joiningDate: _joiningDate!,
        salary: _staffSalaryController.text.trim(),
        gender: _selectedGender,
      );

      registration = UserRegistration(
        account: account,
        staffDetails: staffDetails,
      );
    } else if (_selectedRole == 'parent') {
      final parentDetails = ParentDetails(
        name: _parentNameController.text.trim(),
        guardianName: _guardianNameController.text.trim(),
        phoneNumber: _parentPhoneController.text.trim(),
        address: _parentAddressController.text.trim().isNotEmpty
            ? _parentAddressController.text.trim()
            : null,
      );

      registration = UserRegistration(
        account: account,
        parentDetails: parentDetails,
      );
    } else {
      // Admin - no additional details
      registration = UserRegistration(account: account);
    }

    // Submit
    final success = await provider.createUser(registration);

    if (success && mounted) {
      _showSuccessDialog();
    } else if (mounted && provider.hasError) {
      _showErrorSnackBar(provider.errorMessage ?? 'Failed to create user');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success icon with animation
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              24.kH,
              const Text(
                'Success!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              12.kH,
              Text(
                'User created successfully',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              24.kH,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearForm();
                        context.read<UserRegistrationProvider>().reset();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Create Another',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
                  12.kW,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  bool _isLoading = false;

  Future<void> fetchSubjects() async {
    setState(() {
      _isLoading = true;
    });

    final provider = Provider.of<SubjectsProvider>(context, listen: false);
    final result = await provider.fetchSubjectsForUserCreation(context: context);

    if (result) {
      setState(() {
        _isLoading = false;
      });
    } else {
      _showErrorSnackBar("Failed to load subjects");
    }
  }

  Future<void> fetchClasses() async {
    final provider = Provider.of<ClassesProvider>(context, listen: false);
    await provider.fetchAllClasses(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Create User'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<UserRegistrationProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Role Selector
                  _buildRoleSelector(),
                  24.kH,

                  // Common Fields (Email & Password)
                  _buildCommonFields(),
                  24.kH,

                  // Role-specific fields
                  if (_selectedRole != 'admin') ..._buildRoleSpecificFields(),

                  32.kH,

                  // Submit Button
                  _buildSubmitButton(provider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person_add,
                  color: primaryColor,
                  size: 24,
                ),
              ),
              12.kW,
              const Text(
                'Select User Role',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          16.kH,
          DropdownButtonFormField<String>(
            value: _selectedRole,
            decoration: InputDecoration(
              labelText: 'Role *',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryColor, width: 2),
              ),
            ),
            items: _roles.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(role.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
                _clearForm();
              });
            },
            validator: (value) => value == null ? 'Please select a role' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildCommonFields() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          16.kH,
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email *',
              labelStyle: const TextStyle(color: AppTheme.primaryColor),
              prefixIcon: const Icon(Icons.email, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          16.kH,
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password *',
              labelStyle: const TextStyle(color: AppTheme.primaryColor),
              prefixIcon: const Icon(Icons.lock, color: primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryColor, width: 2),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRoleSpecificFields() {
    switch (_selectedRole) {
      case 'student':
        return [_buildStudentFields()];
      case 'teacher':
        return [_buildTeacherFields()];
      case 'staff':
        return [_buildStaffFields()];
      case 'parent':
        return [_buildParentFields()];
      default:
        return [];
    }
  }

  Widget _buildStudentFields() {
    return Consumer<ClassesProvider>(
      builder: (context, classProvider, child) {
        final classes = classProvider.getListOfClasses ?? [];
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Student Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              16.kH,
              TextFormField(
                controller: _studentNameController,
                decoration: _inputDecoration('Student Name *', Icons.person),
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Name is required' : null,
              ),
              16.kH,
              TextFormField(
                controller: _studentIdController,
                decoration: _inputDecoration('Student ID *', Icons.badge),
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Student ID is required' : null,
              ),
              16.kH,
              // ✅ Fixed: Class dropdown with SchoolClass objects
              DropdownButtonFormField<SchoolClass>(
                value: _selectedClass,
                decoration: _inputDecoration('Class *', Icons.class_),
                items: classes.map((cls) {
                  return DropdownMenuItem(
                    value: cls,
                    child: Text('Class ${cls.classNumber} - ${cls.section}'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedClass = value),
                validator: (value) => value == null ? 'Class is required' : null,
              ),
              16.kH,
              TextFormField(
                controller: _enrollmentYearController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration('Enrollment Year *', Icons.calendar_today),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Enrollment year is required';
                  }
                  final year = int.tryParse(value!);
                  if (year == null || year < 2000 || year > DateTime.now().year) {
                    return 'Enter a valid year';
                  }
                  return null;
                },
              ),
              16.kH,
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: _inputDecoration('Gender', Icons.wc),
                items: _genders.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              16.kH,
              GestureDetector(
                onTap: () => _selectDate(context, true),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: _inputDecoration('Date of Birth', Icons.cake),
                    controller: TextEditingController(
                      text: _dateOfBirth != null
                          ? DateFormat('MMM dd, yyyy').format(_dateOfBirth!)
                          : '',
                    ),
                  ),
                ),
              ),
              16.kH,
              DropdownButtonFormField<String>(
                value: _selectedBloodGroup,
                decoration: _inputDecoration('Blood Group', Icons.bloodtype),
                items: _bloodGroups.map((bg) {
                  return DropdownMenuItem(
                    value: bg,
                    child: Text(bg),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedBloodGroup = value),
              ),
              16.kH,
              TextFormField(
                controller: _emergencyNumberController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('Emergency Number', Icons.phone),
              ),
              16.kH,
              TextFormField(
                controller: _studentAddressController,
                maxLines: 3,
                decoration: _inputDecoration('Address', Icons.location_on),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTeacherFields() {
    return Consumer<SubjectsProvider>(
      builder: (context, subjectProvider, child) {
        final subjects = subjectProvider.getListOfSubjects ?? [];
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Teacher Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              16.kH,
              TextFormField(
                controller: _teacherNameController,
                decoration: _inputDecoration('Teacher Name *', Icons.person),
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Name is required' : null,
              ),
              16.kH,
              TextFormField(
                controller: _teacherEmployeeIdController,
                decoration: _inputDecoration('Employee ID *', Icons.badge),
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Employee ID is required' : null,
              ),
              16.kH,
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                decoration: _inputDecoration('Department *', Icons.business),
                items: _departments.map((dept) {
                  return DropdownMenuItem(
                    value: dept,
                    child: Text(dept),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedDepartment = value),
                validator: (value) => value == null ? 'Department is required' : null,
              ),
              16.kH,
              // ✅ Fixed: Subject dropdown
              DropdownButtonFormField<Subject>(
                value: _selectedSubject,
                decoration: _inputDecoration('Subject *', Icons.book),
                items: subjects.map((subj) {
                  return DropdownMenuItem(
                    value: subj,
                    child: Text(subj.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedSubject = value),
                validator: (value) => value == null ? 'Subject is required' : null,
              ),
              16.kH,
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: _inputDecoration('Gender', Icons.wc),
                items: _genders.map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              16.kH,
              TextFormField(
                controller: _teacherPhoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration('Phone Number *', Icons.phone),
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Phone number is required' : null,
              ),
              16.kH,
              GestureDetector(
                onTap: () => _selectDate(context, false),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: _inputDecoration('Joining Date *', Icons.calendar_month),
                    controller: TextEditingController(
                      text: _joiningDate != null
                          ? DateFormat('yyyy, MM, dd').format(_joiningDate!)
                          : '',
                    ),
                    validator: (value) =>
                        _joiningDate == null ? 'Joining date is required' : null,
                  ),
                ),
              ),
              16.kH,
              TextFormField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Salary *', Icons.attach_money),
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Salary is required' : null,
              ),
              16.kH,
              TextFormField(
                controller: _teacherAddressController,
                maxLines: 3,
                decoration: _inputDecoration('Address', Icons.location_on),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStaffFields() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
     
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Staff Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          16.kH,
          TextFormField(
            controller: _staffNameController,
            decoration: _inputDecoration('Staff Name *', Icons.person),
            validator: (value) =>
                value?.trim().isEmpty ?? true ? 'Name is required' : null,
          ),
          16.kH,
          TextFormField(
            controller: _staffEmployeeIdController,
            decoration: _inputDecoration('Employee ID *', Icons.badge),
            validator: (value) =>
                value?.trim().isEmpty ?? true ? 'Employee ID is required' : null,
          ),
          16.kH,
          DropdownButtonFormField<String>(
            value: _selectedDepartment,
            decoration: _inputDecoration('Department *', Icons.business),
            items: _departments.map((dept) {
              return DropdownMenuItem(
                value: dept,
                child: Text(dept),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedDepartment = value),
            validator: (value) => value == null ? 'Department is required' : null,
          ),
          16.kH,
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: _inputDecoration('Gender', Icons.wc),
            items: _genders.map((gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender.toUpperCase()),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedGender = value),
          ),
          16.kH,
          TextFormField(
            controller: _staffPhoneController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration('Phone Number *', Icons.phone),
            validator: (value) =>
                value?.trim().isEmpty ?? true ? 'Phone number is required' : null,
          ),
          16.kH,
          GestureDetector(
            onTap: () => _selectDate(context, false),
            child: AbsorbPointer(
              child: TextFormField(
                decoration: _inputDecoration('Joining Date *', Icons.calendar_month),
                controller: TextEditingController(
                  text: _joiningDate != null
                      ? DateFormat('MMM dd, yyyy').format(_joiningDate!)
                      : '',
                ),
                validator: (value) =>
                    _joiningDate == null ? 'Joining date is required' : null,
              ),
            ),
          ),
          16.kH,
          TextFormField(
            controller: _staffSalaryController,
            keyboardType: TextInputType.number,
            decoration: _inputDecoration('Salary *', Icons.attach_money),
            validator: (value) =>
                value?.trim().isEmpty ?? true ? 'Salary is required' : null,
          ),
          16.kH,
          TextFormField(
            controller: _staffAddressController,
            maxLines: 3,
            decoration: _inputDecoration('Address', Icons.location_on),
          ),
        ],
      ),
    );
  }

  Widget _buildParentFields() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
      
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Parent Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          16.kH,
          TextFormField(
            controller: _parentNameController,
            decoration: _inputDecoration('Name *', Icons.person),
            validator: (value) =>
                value?.trim().isEmpty ?? true ? 'Name is required' : null,
          ),
          16.kH,
          TextFormField(
            controller: _guardianNameController,
            decoration: _inputDecoration('Guardian Name *', Icons.family_restroom),
            validator: (value) =>
                value?.trim().isEmpty ?? true ? 'Guardian name is required' : null,
          ),
          16.kH,
          TextFormField(
            controller: _parentPhoneController,
            keyboardType: TextInputType.phone,
            decoration: _inputDecoration('Phone Number *', Icons.phone),
            validator: (value) =>
                value?.trim().isEmpty ?? true ? 'Phone number is required' : null,
          ),
          16.kH,
          TextFormField(
            controller: _parentAddressController,
            maxLines: 3,
            decoration: _inputDecoration('Address', Icons.location_on),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(UserRegistrationProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: provider.isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: primaryColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: provider.isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Create User',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppTheme.primaryColor),
      prefixIcon: Icon(icon, color: primaryColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    );
  }
}