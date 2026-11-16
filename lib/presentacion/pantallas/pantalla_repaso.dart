import 'package:flutter/material.dart';

import '../../dependencias.dart';
import '../tema.dart';
import '../vm/repaso_vm.dart';
import 'widgets.dart';

class PantallaRepaso extends StatefulWidget {
  final Dependencias deps;
  const PantallaRepaso({super.key, required this.deps});
  @override
  State<PantallaRepaso> createState() => _EstadoPantalla();
}

class _EstadoPantalla extends State<PantallaRepaso> {
  late final RepasoViewModel vm = RepasoViewModel(widget.deps.aprendizaje, widget.deps.voz);

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Repaso espaciado')),
        body: ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            final t = vm.actual;
            if (t == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.check_circle_outline_rounded, size: 56, color: Paleta.violeta),
                    SizedBox(height: 12),
                    Text('¡Todo al día!',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Paleta.ciruela)),
                    SizedBox(height: 6),
                    Text('No tienes repasos pendientes hoy.\nPractica ejercicios para llenar tu mazo.',
                        textAlign: TextAlign.center, style: TextStyle(color: Paleta.suave)),
                  ]),
                ),
              );
            }
            return ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 28), children: [
              Align(alignment: Alignment.centerLeft, child: Etiqueta('Quedan ${vm.restantes}')),
              const SizedBox(height: 14),
              Panel(
                padding: const EdgeInsets.all(26),
                child: Column(children: [
                  const Text('Dilo en inglés', style: TextStyle(color: Paleta.suave)),
                  const SizedBox(height: 10),
                  Text(t.traduccion,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Paleta.ciruela)),
                  if (vm.respuestaVisible) ...[
                    const Padding(padding: EdgeInsets.symmetric(vertical: 18), child: Divider()),
                    Text(t.frase,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Paleta.violeta)),
                  ],
                ]),
              ),
              const SizedBox(height: 18),
              if (!vm.respuestaVisible)
                SizedBox(
                  height: 54,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.visibility_rounded),
                    onPressed: vm.mostrarRespuesta,
                    label: const Text('Ver y escuchar respuesta'),
                  ),
                )
              else ...[
                const Text('¿Qué tan bien la recordaste?',
                    textAlign: TextAlign.center, style: TextStyle(color: Paleta.suave)),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(child: OutlinedButton(onPressed: () => vm.calificar(1), child: const Text('Otra vez'))),
                  const SizedBox(width: 8),
                  Expanded(child: OutlinedButton(onPressed: () => vm.calificar(3), child: const Text('Difícil'))),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: FilledButton(onPressed: () => vm.calificar(4), child: const Text('Bien'))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: Paleta.rosa, foregroundColor: Paleta.ciruela),
                      onPressed: () => vm.calificar(5),
                      child: const Text('Fácil'),
                    ),
                  ),
                ]),
              ],
            ]);
          },
        ),
      );
}
