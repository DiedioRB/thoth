import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscureText = true;
  String senha = '', email = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 101, 78, 146),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: Container()),
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 35,
                              color: Color.fromARGB(255, 101, 78, 146),
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Container(
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 34),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 241, 234, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextField(
                                onChanged: (value) {
                                  email = value;
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(143, 101, 78, 146),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 34),
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 241, 234, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Center(
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: TextField(
                                onChanged: (value) {
                                  senha = value;
                                },
                                obscureText: isObscureText,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Password',
                                  hintStyle: const TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(143, 101, 78, 146),
                                  ),
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(
                                        () {
                                          isObscureText = !isObscureText;
                                        },
                                      );
                                    },
                                    child: Icon(
                                      size: 30,
                                      isObscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color.fromARGB(
                                          255, 101, 78, 146),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: () {
                                //if (email == "a" && senha == "12") {
                                //  Navigator.pushReplacement(
                                //    context,
                                //    MaterialPageRoute(
                                //      builder: (context) => const WelcomePage(),
                                //    ),
                                //  );
                                //} else {
                                //  ScaffoldMessenger.of(context).showSnackBar(
                                //    const SnackBar(
                                //      content:
                                //          Text("Account not found, try again"),
                                //    ),
                                //  );
                                //}
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 101, 78, 146)),
                                shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 70),
                          height: 30,
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              const Text(
                                'Don\'t have any account? ',
                              ),
                              InkWell(
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 101, 78, 146)),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => const SingUpPage()),
                                  // );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
