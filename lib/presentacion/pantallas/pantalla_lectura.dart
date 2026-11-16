import 'package:flutter/material.dart';

import '../../dependencias.dart';
import '../tema.dart';
import '../vm/lectura_vm.dart';
import 'widgets.dart';

class PantallaLectura extends StatefulWidget {
  final Dependencias deps;
  const PantallaLectura({super.key, required this.deps});
  @override
  State<PantallaLectura> createState() => _EstadoPantalla();
}

class _EstadoPantalla extends State<PantallaLectura> {
  late final LecturaViewModel vm = LecturaViewModel(widget.deps.aprendizaje);

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Lectura')),
        body: ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            if (vm.textos.isEmpty) return const SinContenido();
            final t = vm.actual;
            return ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 28), children: [
              Panel(
                padding: const EdgeInsets.all(22),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Etiqueta('Lee con calma'),
                  const SizedBox(height: 12),
                  Text(t.titulo,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Paleta.ciruela)),
                  const SizedBox(height: 10),
                  Text(t.texto, style: const TextStyle(fontSize: 18, height: 1.55, color: Paleta.texto)),
                ]),
              ),
              const SizedBox(height: 20),
              for (var i = 0; i < t.preguntas.length; i++) ...[
                Text('${i + 1}. ${t.preguntas[i].enunciado}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Paleta.ciruela)),
                const SizedBox(height: 8),
                for (var o = 0; o < t.preguntas[i].opciones.length; o++) ...[
                  _Opcion(
                    texto: t.preguntas[i].opciones[o],
                    elegida: vm.respuestas[i] == o,
                    esCorrecta: t.preguntas[i].correcta == o,
                    respondida: vm.respuestas.containsKey(i),
                    alTocar: () => vm.responder(i, o),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 10),
              ],
              if (vm.terminado) ...[
                Panel(
                  color: Paleta.lila,
                  child: Row(children: [
                    Text('${vm.correctas}/${t.preguntas.length}',
                        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Paleta.violeta)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        vm.correctas == t.preguntas.length ? '¡Perfecto!' : '¡Buen intento! Sigue leyendo',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Paleta.ciruela),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: vm.siguienteTexto,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Otro texto'),
                ),
              ],
            ]);
          },
        ),
      );
}

class _Opcion extends StatelessWidget {
  final String texto;
  final bool elegida;
  final bool esCorrecta;
  final bool respondida;
  final VoidCallback alTocar;
  const _Opcion({
    required this.texto,
    required this.elegida,
    required this.esCorrecta,
    required this.respondida,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext context) {
    // Antes de responder: neutra. Después: la correcta en verde y la elegida (si falló) en rosa.
    Color borde = Paleta.borde;
    Color fondo = Colors.white;
    IconData icono = Icons.radio_button_unchecked_rounded;
    Color colorIcono = Paleta.suave;
    if (respondida && esCorrecta) {
      borde = Paleta.bien;
      fondo = const Color(0xFFE9F6F0);
      icono = Icons.check_circle_rounded;
      colorIcono = Paleta.bien;
    } else if (elegida) {
      borde = Paleta.mal;
      fondo = Paleta.rosaClaro;
      icono = Icons.cancel_rounded;
      colorIcono = Paleta.mal;
    }
    return Material(
      color: fondo,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: respondida ? null : alTocar,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borde),
          ),
          child: Row(children: [
            Icon(icono, color: colorIcono, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(texto, style: const TextStyle(fontSize: 15, color: Paleta.texto))),
          ]),
        ),
      ),
    );
  }
}
