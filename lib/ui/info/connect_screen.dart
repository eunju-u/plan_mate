import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../service/auth_service.dart';
import '../widget/header.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final AuthService _authService = AuthService();
  String copyCode = "";

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool isConnectValid = false;
  String partnerCode = "";

  @override
  void initState() {
    super.initState();
    startInit();
  }

  void startInit() async {
    String code = await _authService.getCopyCode();
    setState(() {
      copyCode = code;
    });
  }

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: copyCode));
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('초대 코드가 복사되었습니다.')),
    // );
  }

  void _shareCode(BuildContext context) {
    // 공유 기능을 구현하려면 `share_plus` 패키지를 사용할 수 있습니다.
    // 예시: Share.share(inviteCode);
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('공유 기능이 호출되었습니다.')),
    // );
  }

  void _enterCode() async {
    // 초대 코드 입력 기능을 구현합니다.
    bool isConnectPartner = await _authService.connectPartner(partnerCode);

    if (isConnectPartner) {
      if (context.mounted) {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('코드가 잘못 입력되었습니다. 다시 입력해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Header(back: false, close: true),
                    const SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0x47f8eed1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 15),
                          const Text(
                            '초대 코드',
                            style: TextStyle(color: Color(0xFF387478), fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            copyCode,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.copy, color: Colors.black),
                          label: const Text('복사', style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _copyCode(context),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.share, color: Colors.black),
                          label: const Text('공유', style: TextStyle(color: Colors.black)),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _shareCode(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      '초대 코드를 전달받으셨다면',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onChanged: (text) {
                          setState(() {
                            isConnectValid = text.isNotEmpty && text.length <= 20;
                            partnerCode = text;
                          }); // 텍스트 변경 시 UI 갱신
                        },
                        decoration: InputDecoration(
                          hintText: '초대 코드 입력...',
                          filled: true,
                          border: InputBorder.none,
                          fillColor: const Color(0x47f8eed1),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          suffixIcon: _controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close, color: Color(0xFF9E9E9E)),
                                  onPressed: () {
                                    _controller.clear(); // 입력 필드 내용 삭제
                                    setState(() {}); // UI 갱신
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 60),
                    ElevatedButton(
                      onPressed: isConnectValid
                          ? () {
                              _enterCode();
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isConnectValid ? const Color(0xFF387478) : const Color(0xFF9E9E9E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          '커플 연결하기',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
