import 'package:flutter/material.dart';
import 'package:bankingapp/app_styles.dart';
import 'package:bankingapp/size_configs.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BancolombiaLoginPage extends StatefulWidget {
  const BancolombiaLoginPage({Key? key}) : super(key: key);

  @override
  State<BancolombiaLoginPage> createState() => _BancolombiaLoginPageState();
}

class _BancolombiaLoginPageState extends State<BancolombiaLoginPage> {
  @override
  Widget build(BuildContext context) {
    // initialize size config
    SizeConfig().init(context);
    double sizeVertical = SizeConfig.blockSizeVertical!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: PageView.builder(
                itemBuilder: (context, index) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: sizeVertical * 50,
                      child: Lottie.network(
                          "https://assets1.lottiefiles.com/packages/lf20_jgMzeUJ4Nu.json"),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Conecta tu cuenta de Bancolombia",
                          style: kTitleOnboarding,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeVertical * 1,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Un paso rápido y seguro para acceder a todos los beneficios de nuestra app",
                          style: kSubtitleOnboarding,
                          maxLines: 6,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: sizeVertical * 5,
                    ),
                    BancolombiaButton()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BancolombiaButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            _openWebViewer(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.network(
              'https://www.bancolombia.com/wcm/connect/b8e4c3f2-36a9-497d-a125-ac04f83b0bf8/LogoBancolombia.png?MOD=AJPERES', // Ruta de la imagen del logo de Bancolombia
            ),
          ),
        ),
      ),
    );
  }

  void _openWebViewer(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Bancolombia Web Viewer'),
          backgroundColor: Colors.black, // Título de la barra de navegación
        ),
        body: WebView(
          initialUrl:
              'https://fua-qa.apps.ambientesbc.com/login/oauth/authorize?response_type=code&client_id=CPF&redirect_uri=http://example.com', // URL del visor web
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    ));
  }
}
