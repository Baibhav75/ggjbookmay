import 'package:flutter/material.dart';
import 'package:bookworld/Service/secure_storage_service.dart';
import 'package:bookworld/adminPage/admin_page.dart';

import '../Model/MPIN_model.dart';
import '../Model/login_model.dart';
import '../Service/mpin_service.dart';

class MpinScreen extends StatefulWidget {
  final dynamic userData;

  const MpinScreen({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<MpinScreen> createState() => _MpinScreenState();
}

class _MpinScreenState extends State<MpinScreen> {
  final SecureStorageService _storageService = SecureStorageService();
  final MpinService _mpinService = MpinService();

  String _enteredPin = '';
  String _errorMessage = '';
  bool _isLoading = false;

  static const int _pinLength = 4;

  // ✅ ADD HERE 👇
  LoginModel mapToLoginModel(AdminData data) {
    return LoginModel(
      adminName: data.adminName,
      adminEmail: "",
      mobileNo: data.mobileNo,
    );
  }

  Color get _primaryColor => Colors.blue[900]!;

  @override
  void initState() {
    super.initState();
  }

  void _onKeyPress(String value) {
    if (_enteredPin.length < _pinLength && !_isLoading) {
      setState(() {
        _enteredPin += value;
        _errorMessage = '';
      });

      if (_enteredPin.length == _pinLength) {
        _processCompletePin();
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty && !_isLoading) {
      setState(() {
        _enteredPin =
            _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = '';
      });
    }
  }

  Future<void> _processCompletePin() async {
    await Future.delayed(const Duration(milliseconds: 200));

    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    final response = await _mpinService.loginWithMpin(_enteredPin);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response.success) {
      _navigateToAdminPage(response.data);
    } else {
      setState(() {
        _errorMessage = response.message;
      });

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      setState(() {
        _enteredPin = '';
      });
    }
  }

  void _navigateToAdminPage(AdminData? data) {
    if (!mounted || data == null) return;

    final loginModel = mapToLoginModel(data);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AdminPage(userData: loginModel),
      ),
    );
  }

  Future<void> _handleLogout() async {
    await _storageService.clearAllCredentials();
    if (!mounted) return;
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Enter MPIN'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _showLogoutDialog(),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),

            // 🔒 Header
            Icon(
              Icons.lock_outline,
              size: 60,
              color: _primaryColor,
            ),
            const SizedBox(height: 20),

            Text(
              'Enter your MPIN',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _primaryColor,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              'Enter a 4-digit MPIN for secure access',
              style:
              TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),

            // 🔵 PIN Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pinLength, (index) {
                return _buildPinDot(index < _enteredPin.length);
              }),
            ),

            // ❌ Error Message
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                _errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],

            // ⏳ Loader
            if (_isLoading) ...[
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
            ],

            const Spacer(),

            // 🔢 Keypad
            _buildKeypad(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDot(bool isFilled) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled ? _primaryColor : Colors.grey[300],
        border: Border.all(
          color:
          isFilled ? _primaryColor : Colors.grey[400]!,
          width: 2,
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 20),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 20),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 70, height: 70),
              _buildKeyButton('0'),
              _buildBackspaceButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
      numbers.map((n) => _buildKeyButton(n)).toList(),
    );
  }

  Widget _buildKeyButton(String number) {
    return InkWell(
      onTap: () => _onKeyPress(number),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[100],
        ),
        alignment: Alignment.center,
        child: Text(
          number,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return InkWell(
      onTap: _onBackspace,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 70,
        height: 70,
        alignment: Alignment.center,
        child: Icon(
          Icons.backspace_outlined,
          size: 30,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text(
            "Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _handleLogout();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red),
            child: const Text("Logout",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}