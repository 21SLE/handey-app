import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:handey_app/src/business_logic/user/user_model.dart';
import 'package:handey_app/src/business_logic/user/user_provider.dart';
import 'package:handey_app/src/view/utils/border.dart';
import 'package:handey_app/src/view/utils/colors.dart';
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
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              signUpBackGroundImg(),
              signUpForm()
            ],
          )
      ),
    );
  }

  Widget signUpBackGroundImg() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/images/loginscreen.png'),
        ),
      ),
    );
  }

  Widget signUpForm() {
    return Padding(
      padding: EdgeInsets.all(size.getSize(50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Space(height: 30),
          buildTitleText(),
          Space(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              emailTextFormField(),
              Space(width: 10),
              emailDuplicationCheckBtn(),
            ],
          ),
          Space(height: 5),
          pwTextFormField(),
          Space(height: 5),
          pwCheckTextFormField(),
          Space(height: 5),
          userNameTextFormField(),
          Space(height: 20),
          registerButton()
        ],
      ),
    );
  }

  Text buildTitleText() {
    return Text(
      'HANDEY',
      style: rTxtStyle.copyWith(fontSize: size.getSize(30), fontWeight: FontWeight.w700, color: cheeseYellow),
    );
  }

  Widget emailTextFormField() {
    return Container(
      width: size.getSize(160.0),
      height: size.getSize(50.0),
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
            horizontal: size.getSize(5.0),
            vertical: size.getSize(10.0),
          ),
          counterText: "",
          border: underlineInputBorder(),
          focusedBorder: underlineFocusedBorder(),
          enabledBorder: underlineInputBorder(),
        ),
        onChanged: (txt) {
          setState(() {
            isEmailValid = false;
          });
        },
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
            color: isEmailValid ? regularYellow : Colors.white,
            border: Border.all(color: regularYellow, width: 2.0),
            borderRadius: BorderRadius.circular(size.getSize(6.0))),
        child: isEmailValid
            ? Icon(Icons.check, color: Colors.white)
            : Text(
              '중복확인',
              style: rTxtStyle.copyWith(color: regularYellow)
        ),
      ),
    );
  }

  Widget pwTextFormField() {
    return Container(
      width: size.getSize(240.0),
      height: size.getSize(50.0),
      child: TextFormField(
        controller: pwTEC,
        focusNode: pwFNode,
        textAlign: TextAlign.left,
        minLines: 1,
        style: rTxtStyle,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: '비밀번호를 입력하세요.',
          hintStyle: TextStyle(
            fontSize: size.getSize(16.0),
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.getSize(5.0),
            vertical: size.getSize(10.0),
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
      width: size.getSize(240.0),
      height: size.getSize(50.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validatePwCheck,
        controller: pwCheckTEC,
        focusNode: pwCheckFNode,
        textAlign: TextAlign.left,
        minLines: 1,
        style: rTxtStyle,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: '비밀번호 확인',
          hintStyle: TextStyle(
            fontSize: size.getSize(16.0),
            color: Colors.grey,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.getSize(5.0),
            vertical: size.getSize(10.0),
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
      width: size.getSize(240.0),
      height: size.getSize(50.0),
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
            horizontal: size.getSize(5.0),
            vertical: size.getSize(10.0),
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
        width: size.getSize(200.0),
        height: size.getSize(45.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: regularYellow,
            borderRadius: BorderRadius.circular(size.getSize(6.0))),
        child: Text(
            '회원가입 하기',
          style: rTxtStyle.copyWith(color: Colors.white),
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
            title: '회원가입에 성공하셨습니다!\nHANDEY에 오신 것을 환영합니다.',
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
