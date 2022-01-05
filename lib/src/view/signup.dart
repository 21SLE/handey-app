import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/user/user_model.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/utils/border.dart';
import 'package:handey_app/src/view/utils/popup_custom.dart';
import 'package:handey_app/src/view/utils/screen_size.dart';
import 'package:handey_app/src/view/utils/space.dart';
import 'package:handey_app/src/view/utils/text_style.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ScreenSize size;

  TextEditingController emailTEC;
  TextEditingController pwTEC;
  TextEditingController pwCheckTEC;
  TextEditingController userNameTEC;

  FocusNode emailFNode;
  FocusNode pwFNode;
  FocusNode pwCheckFNode;
  FocusNode userNameFNode;

  bool isEmailValid;
  bool isPwValid;
  bool isUserNameValid;

  @override
  void initState() {
    super.initState();
    emailTEC = TextEditingController();
    pwTEC = TextEditingController();
    pwCheckTEC = TextEditingController();
    userNameTEC = TextEditingController();
    emailFNode = FocusNode();
    pwFNode = FocusNode();
    pwCheckFNode = FocusNode();
    userNameFNode = FocusNode();
    isEmailValid = false;
    isPwValid = false;
    isUserNameValid = false;
  }

  @override
  void dispose() {
    emailTEC.dispose();
    pwTEC.dispose();
    pwCheckTEC.dispose();
    userNameTEC.dispose();
    emailFNode.dispose();
    pwFNode.dispose();
    pwCheckFNode.dispose();
    userNameFNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = ScreenSize();
    size.setMediaSize(MediaQuery.of(context).size);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTitleText(),
              Space(height: 60),
              Row(
                children: [
                  emailTextFormField(),
                  Space(width: 10),
                  emailDuplicationCheckBtn(),
                ],
              ),
              Space(height: 12),
              pwTextFormField(),
              Space(height: 12),
              pwCheckTextFormField(),
              Space(height: 12),
              userNameTextFormField(),
              Space(height: 40),
              registerButton()
            ],
          ),
        )
      ),
    );
  }

  Text buildTitleText() {
    return Text(
      '회원가입',
      style: rTxtStyle.copyWith(fontSize: 30),
    );
  }

  Widget emailTextFormField() {
    return Container(
      width: size.getSize(170.0),
      height: size.getSize(54.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validateEmail,
        controller: emailTEC,
        focusNode: emailFNode,
        textAlign: TextAlign.left,
        minLines: 1,
        style: rTxtStyle,
        decoration: InputDecoration(
          hintText: '이메일을 입력하세요.',
          hintStyle: TextStyle(
            fontSize: size.getSize(16.0),
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.getSize(10.0),
            vertical: size.getSize(15.0),
          ),
          counterText: "",
          border: underlineInputBorder(),
          focusedBorder: underlineFocusedBorder(),
          enabledBorder: underlineInputBorder(),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return '이메일이 올바르지 않습니다.';
    else
      return null;
  }

  Widget emailDuplicationCheckBtn() {
    return GestureDetector(
      onTap:() {
        onTapEmailDuplicationCheckBtn(context);
      },
      child: Container(
        width: size.getSize(70.0),
        height: size.getSize(40.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(size.getSize(6.0))),
        child: Text(
            '중복확인'
        ),
      ),
    );
  }

  Widget pwTextFormField() {
    return Container(
      width: size.getSize(250.0),
      height: size.getSize(54.0),
      child: TextFormField(
        controller: pwTEC,
        focusNode: pwFNode,
        textAlign: TextAlign.left,
        minLines: 1,
        style: rTxtStyle,
        decoration: InputDecoration(
          hintText: '비밀번호를 입력하세요.',
          hintStyle: TextStyle(
            fontSize: size.getSize(16.0),
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.getSize(10.0),
            vertical: size.getSize(15.0),
          ),
          counterText: "",
          border: underlineInputBorder(),
          focusedBorder: underlineFocusedBorder(),
          enabledBorder: underlineInputBorder(),
        ),
      ),
    );
  }

  Widget pwCheckTextFormField() {
    return Container(
      width: size.getSize(250.0),
      height: size.getSize(54.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validatePwCheck,
        controller: pwCheckTEC,
        focusNode: pwCheckFNode,
        textAlign: TextAlign.left,
        minLines: 1,
        style: rTxtStyle,
        decoration: InputDecoration(
          hintText: '비밀번호 확인',
          hintStyle: TextStyle(
            fontSize: size.getSize(16.0),
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.getSize(10.0),
            vertical: size.getSize(15.0),
          ),
          counterText: "",
          border: underlineInputBorder(),
          focusedBorder: underlineFocusedBorder(),
          enabledBorder: underlineInputBorder(),
        ),
      ),
    );
  }

  String validatePwCheck(String value) {
    if (pwTEC.text == pwCheckTEC.text && value != null) {
      isPwValid = true;
      return null;
    }
    else {
      return '비밀번호가 일치하지 않습니다.';
    }
  }

  Widget userNameTextFormField() {
    return Container(
      width: size.getSize(250.0),
      height: size.getSize(54.0),
      child: TextFormField(
        controller: userNameTEC,
        textAlign: TextAlign.left,
        minLines: 1,
        style: rTxtStyle,
        decoration: InputDecoration(
          hintText: '닉네임을 입력해주세요.',
          hintStyle: TextStyle(
            fontSize: size.getSize(16.0),
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.getSize(10.0),
            vertical: size.getSize(15.0),
          ),
          counterText: "",
          border: underlineInputBorder(),
          focusedBorder: underlineFocusedBorder(),
          enabledBorder: underlineInputBorder(),
        ),
        onChanged: (value) {
          if(value.isNotEmpty){
            setState(() {
              isUserNameValid = true;
            });
          }
        }
      ),
    );
  }

  Widget registerButton() {
    return GestureDetector(
      onTap:() {
        onTapRegisterButton(context);
      },
      child: Container(
        width: size.getSize(100.0),
        height: size.getSize(60.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(size.getSize(6.0))),
        child: Text(
            '회원가입 하기'
        ),
      ),
    );
  }

  onTapEmailDuplicationCheckBtn(context) async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    bool emailDuplicated = await userProvider.checkEmailDuplication(emailTEC.text);

    if (emailDuplicated) {
      /// 이메일 중복
      await showCustomPopUp(
          context: context,
          title: '이미 존재하는\n이메일입니다.',
          confirmText: '확인');
      emailTEC.clear();
      emailFNode.requestFocus();
    } else {
      await showCustomPopUp(
          context: context,
          title: '사용 가능한\n이메일입니다.',
          confirmText: '확인');

      setState(() {
        isEmailValid = true;
      });
      emailFNode.unfocus();
    }
  }

  onTapRegisterButton(context) async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if(!isEmailValid){
      await showCustomPopUp(
          context: context,
          title: '이메일을\n확인해주시기\n바랍니다',
          confirmText: '확인');
      emailFNode.requestFocus();
    } else if(!isPwValid) {
      await showCustomPopUp(
          context: context,
          title: '비밀번호를\n확인해주시기\n바랍니다',
          confirmText: '확인');
      pwCheckFNode.requestFocus();
    } else if(!isUserNameValid) {
      await showCustomPopUp(
          context: context,
          title: '닉네임을\n확인해주시기\n바랍니다',
          confirmText: '확인');
      userNameFNode.requestFocus();
    } else {
      /// 회원가입 요청 -> 회원가입 완료 팝업 -> 로그인 화면으로 이동
      UserModel user = new UserModel();
      user.email = emailTEC.text;
      user.password = pwTEC.text;
      user.userName = userNameTEC.text;
      bool signUpSucceeded = await userProvider.signUp(user);
      if(signUpSucceeded) {
        await showCustomPopUp(
            context: context,
            title: '회원가입에 성공하셨습니다!\nHandey에 오신 것을 환영합니다.',
            confirmText: '로그인하기');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Login()));
      } else {
        await showCustomPopUp(
            context: context,
            title: '회원가입이 실패했습니다.',
            confirmText: '확인');
      }
    }
  }
}
