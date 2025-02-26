import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CheckinWidget extends StatefulWidget {
  const CheckinWidget({super.key});

  @override
  _CheckinWidgetState createState() => _CheckinWidgetState();
}

class _CheckinWidgetState extends State<CheckinWidget> {
  final TextEditingController _codeController = TextEditingController();

  void _submitCode() {
    String code = _codeController.text;
    if (code.length == 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mã điểm danh: $code')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đủ 4 chữ số')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Điểm danh"),
        centerTitle: true,
        backgroundColor: Color(0XFFFFFF2F2),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Nhập mã điểm danh",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Mã điểm danh sẽ được cung cấp trong quá trình điểm danh",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            /// Ô nhập mã theo từng ô một
            PinCodeTextField(
              appContext: context,
              length: 4,
              controller: _codeController,
              keyboardType: TextInputType.number,
              textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(10),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                inactiveColor: Colors.grey,
                activeColor: Colors.blueAccent,
                selectedColor: Colors.blue,
                selectedFillColor: Colors.white,
              ),
              onChanged: (value) {},
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Xác nhận",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Thoát",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFFFFF2F2),
    );
  }
}
