import 'package:lottie/lottie.dart';

class OnBoarding {
  String title;
  String subtitle;
  dynamic image;

  OnBoarding({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}

List<OnBoarding> onboardingContents = [
  OnBoarding(
    title: 'Analiza tus gastos',
    subtitle:
        'Con nuestra app financiera, puedes ver fácilmente cómo estás gastando tu dinero. Analiza tus gastos para tomar mejores decisiones financieras y alcanzar tus metas.',
    image: Lottie.network(
        "https://assets4.lottiefiles.com/packages/lf20_htdr8jgg.json"),
  ),
  OnBoarding(
    title: 'Controla tus finanzas',
    subtitle:
        '¿Te preocupa no tener suficiente dinero para llegar a fin de mes? No te preocupes, nuestra app te ayuda a controlar tus finanzas. Con ella, puedes ver tu historial de gastos y planificar tus próximos gastos.',
    image: Lottie.network(
        "https://assets2.lottiefiles.com/private_files/lf30_cmd8kh2q.json"),
  ),
  OnBoarding(
    title: 'Ahorra para el futuro ',
    subtitle:
        '¿Quieres ahorrar dinero para un viaje, una casa o tu jubilación?. Nuestra app tiene una funcionalidad de ahorro que te ayudará a alcanzar tus metas financieras. Establece tus objetivos de ahorro y haz un seguimiento de tu progreso.',
    image: Lottie.network(
        "https://assets2.lottiefiles.com/packages/lf20_zrqthn6o.json"),
  ),
  OnBoarding(
    title: 'Vincula tu cuenta bancaria',
    subtitle:
        'Para aprovechar al máximo nuestra app financiera, te recomendamos vincular tu cuenta bancaria de Bancolombia. Así, podrás ver tus transacciones y saldo actualizado en tiempo real. ¡Hazlo fácilmente desde la app!',
    image: Lottie.network(
        "https://assets2.lottiefiles.com/packages/lf20_5rImXbDsO1.json"),
  ),
];
