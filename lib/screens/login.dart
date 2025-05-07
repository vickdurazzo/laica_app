import 'package:flutter/material.dart';
import 'package:laica_app/models/user.dart';
import 'package:laica_app/utils/device_utils.dart';
import 'package:laica_app/utils/userProvider.dart';
import 'package:laica_app/widgets/app_subtitle.dart';
import 'package:provider/provider.dart';
import '../widgets/primary_button.dart';
import '../widgets/app_title.dart';
import '../widgets/form_input.dart';
// Importa o pacote de autenticação do Firebase
import 'package:firebase_auth/firebase_auth.dart';
// Importa o pacote para exibir mensagens rápidas (toasts)
import 'package:fluttertoast/fluttertoast.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    void _login(BuildContext context) async {
    try {
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!authResult.user!.emailVerified) {
        final user = FirebaseAuth.instance.currentUser;
        await user?.sendEmailVerification();
        await FirebaseAuth.instance.signOut();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Verifique seu e-mail antes de continuar.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

      final uid = authResult.user?.uid;
      if (uid == null) throw Exception('Erro ao obter UID do usuário.');

      // Buscar dados no Firestore
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users') // ou 'user', dependendo da sua coleção
          .doc(uid)
          .get();

      if (!docSnapshot.exists) throw Exception('Usuário não encontrado no Firestore.');

      final userData = docSnapshot.data();
      final userModel = UserModel.fromJson(userData!);

      // Salvar no estado global
      Provider.of<UserProvider>(context, listen: false).setUser(userModel);

      // Navegar para o menu
      Navigator.pushReplacementNamed(context, '/menu');
    } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Erro de autenticação.'),
            backgroundColor: Colors.red,
          ),
        );
      }
  }


    



    void uploadActivitiesToFirestore() async {
        final firestore = FirebaseFirestore.instance;

        final activities =[{
  "id": "family",
  "name": "Planeta da Família",
  "image": "assets/images/planets/familyPlanet.png",
  "color": "#F29DC1",
  "island": [
    {
      "id": "island_1",
      "name": "Ilha da Cozinha",
      "image": "assets/images/islands/ilhaCozinha.png",
      "activities": [
        {
          "id": "activity_1",
          "ordem":1,
          "name": "Nada de espiar",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746393382/planeta_sentimento_ilha_cozinha_olhos_vendados_rzpdtd.mp4"
          
        },
        {
          "id": "activity_2",
          "ordem":2,
          "name": "Receita da família",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746393522/planeta_sentimento_ilha_cozinha_receita_vp8tyw.mp4"
          
        }
      ]
    },
    {
      "id": "island_2",
      "name": "Ilha da União",
      "image": "assets/images/islands/ilhaUniao.png",
      "activities": [
        {
          "id": "activity_1",
          "ordem":1,
          "name": "Minha herança",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746394232/planeta_sentimento_ilha_uniao_desenho_fvs0tk.mp4"
         
        },
        {
          "id": "activity_2",
          "ordem":2,
          "name": "Conhecimento de Ansião",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746394019/planeta_sentimento_ilha_uniao_ansi%C3%A3o_opuyk7.mp4"
          
        }
      ]
    }
  ]
},
{
  "id": "earth",
  "name": "Planeta da Terra",
  "image": "assets/images/planets/earthPlanet.png",
  "color": "#7CD2A8",
  "island": [
    {
      "id": "island_1",
      "name": "Ilha da Sustentabilidade",
      "image": "assets/images/islands/ilhaSustentabilidade.png",
      "activities": [
        {
          "id": "activity_1",
          "ordem":1,
          "name": "Um presente para o mundo",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746394654/planeta_terra_ilha_sustentabilidade_planta_1_pvohih.mp4"
         
        },
        {
          "id": "activity_2",
          "ordem":2,
          "name": "Nada se destroi, tudo se transforma",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746394785/planeta_terra_ilha_sustentabilidade_reciclagem_k7l9gb.mp4"
         
        }
      ]
    },
    {
      "id": "island_2",
      "name": "Ilha da Solidariedade",
      "image": "assets/images/islands/ilhaSolidariedade.png",
      "activities": [
        {
          "id": "activity_1",
          "ordem":1,
          "name": "Sorriso no rosto",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746394383/planeta_terra_ilha_solidariedade_5_feli_exuv6s.mp4"
        
        },
        {
          "id": "activity_2",
          "ordem":2,
          "name": "Heroi do dia",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746394512/planeta_terra_ilha_solidariedade_doa%C3%A7%C3%A3o_ze4qxc.mp4"
         
        }
      ]
    }
  ]
},
{
  "id": "fun",
  "name": "Planeta da Diversão",
  "image": "assets/images/planets/funPlanet.png",
  "color": "#FFE483",
  "island": [
    {
      "id": "island_1",
      "name": "Ilha dos Experimentos",
      "image":"assets/images/islands/ilhaExperimentos.png",
      "activities": [
        
        {
          "id": "activity_1",
          "ordem":1,
          "name": "Oleo",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746392705/planeta_diversao_ilha_experiencia_oleo_l62edx.mp4"
          
        },
        {
          "id": "activity_2",
          "ordem":2,
          "name": "Ovo",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746393032/planeta_diversao_ilha_experiencia_ovo_k6jofy.mp4"
         
        },
        {
          "id": "activity_3",
          "ordem":3,
          "name": "Copo atleta",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746581283/slqpjddvveicu3pu81sr.mp4"
         
        }
       

      ]
    },
    {
      "id": "island_2",
      "name": "Ilha dos Brinquedos",
      "image": "assets/images/islands/ilhaBrinquedos.png",
      "activities": [
        {
          "id": "activity_1",
          "ordem":1,
          "name": "Som na caixa",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746393155/planeta_diversao_ilha_experiencia_som_ocjxxw.mp4"
         
        },
        {
          "id": "activity_2",
          "ordem":2,
          "name": "Cinema antigo",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746581721/planeta_diversao_ilha_experiencia_cinema_1_phruqy.mp4"
         
        },
        {
          "id": "activity_3",
          "ordem":3,
          "name": "Foguete",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746390250/ia5ygjdyomz2loocgxlg.mp4"
          
        }
        
      ]
    }
  ]
},
{
  "id": "feelings",
  "name": "Planeta dos Sentimentos",
  "image": "assets/images/planets/emotionsPlanet.png",
  "color": "#87A6FF",
  "island": [
    {
      "id": "island_1",
      "name": "Ilha das Reflexões",
      "image": "assets/images/islands/ilhaReflexoes.png",
      "activities": [
        {
          "id": "activity_1",
          "ordem":1,
          "name": "Espelho,espelho meu...",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746393711/planeta_sentimento_ilha_reflexoes_espelho_beyfcz.mp4"
         
        },
        {
          "id": "activity_2",
          "ordem":2,
          "name": "Pizza é União",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746393901/planeta_sentimento_ilha_reflexoes_pizza_kncvc0.mp4"
         
        },
        {
          "id": "activity_3",
          "ordem":3,
          "name": "Alguém especial",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746393616/planeta_sentimento_ilha_emo%C3%A7%C3%B5es_carta_bvj6bx.mp4"
          
        }
       
      ]
    },
    {
      "id": "island_2",
      "name": "Ilha da Emoções",
      "image": "assets/images/islands/ilhaEmocoes.png",
      "activities": [
        {
          "id": "activity_1",
          "ordem":1,
          "name": "O balão da ansiedade",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746581506/planeta_sentimento_ilha_emo%C3%A7%C3%B5es_bal%C3%A3o_1_ockeqj.mp4"
          
        },
        {
          "id": "activity_2",
          "ordem":2,
          "name": "A raiva faz parte?",
          "video": "https://res.cloudinary.com/da0kfwo1r/video/upload/v1746581638/planeta_sentimento_ilha_emo%C3%A7%C3%B5es_raiva_1_jtrzic.mp4"
          
        }
       
      ]
    }
  ]
}
];
 


        for (var activity in activities) {
          await firestore.collection('activities').add(activity);
          print('Atividade "${activity["title"]}" adicionada.');
        }

        print('Upload completo!');
      }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height;
    final screenWidth = size.width;
    final bool isMobile = DeviceUtils.isMobile();

    return Scaffold(
      backgroundColor: const Color(0xFF1B1A3B),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background.png',
            fit: BoxFit.cover,
          ),
          // Show banner if NOT mobile
          if (!isMobile)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: const Center(
                  child: Text(
                    'Esta aplicação funciona melhor em dispositivos móveis.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.04),
                          AppTitle(text: 'Exploradores'),
                          SizedBox(height: screenHeight * 0.01),
                          AppSubtitle(text: 'Acessem suas aventuras agora!'),
                          SizedBox(height: screenHeight * 0.04),
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'E-mail',
                            suffixIcon: Icons.email,
                            inputType: 'email',
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          CustomTextField(
                            controller: _passwordController,
                            labelText: 'Senha',
                            suffixIcon: Icons.lock_outline,
                            inputType: 'password',
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          PrimaryButton(
                            text: 'Decolar',
                            onPressed: () => _login(context),
                          ),
                          /*PrimaryButton(
                            text: 'enviar',
                            onPressed: () => uploadActivitiesToFirestore(),
                          ),*/
                          SizedBox(height: screenHeight * 0.04),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/password_recover');
                            },
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Esqueceu a senha ? ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      height: 22 / 14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Recuperar senha',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      height: 22 / 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Cadastrem-se fixo no rodapé
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Novos astronautas ? ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 22 / 14,
                              ),
                            ),
                            TextSpan(
                              text: 'Cadastrem-se',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                height: 22 / 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }
}