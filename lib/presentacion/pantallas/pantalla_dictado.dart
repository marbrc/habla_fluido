import 'package:flutter/material.dart';

import '../../dependencias.dart';
import '../tema.dart';
import '../vm/dictado_vm.dart';
import 'widgets.dart';

class PantallaDictado extends StatefulWidget {
  final Dependencias deps;
  const PantallaDictado({super.key, required this.deps});
  @override
  State<PantallaDictado> createState() => _EstadoPantalla();
}

class _EstadoPantalla extends State<PantallaDictado> {
  late final DictadoViewModel vm = DictadoViewModel(widget.deps.voz, widget.deps.aprendizaje);
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Oído · dictado')),
        body: ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            if (vm.frases.isEmpty) return const SinContenido();
            return ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 28), children: [
              Panel(
                color: Paleta.lila,
                padding: const EdgeInsets.all(22),
                child: Column(children: [
                  const Icon(Icons.headphones_rounded, size: 44, color: Paleta.violeta),
                  const SizedBox(height: 10),
                  const Text('Escucha la frase y escribe exactamente lo que entiendas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Paleta.ciruela, fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.volume_up_rounded),
                        label: const Text('Escuchar'),
                        onPressed: vm.ocupado ? null : () => vm.reproducir(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                        icon: const Icon(Icons.slow_motion_video_rounded),
                        label: const Text('Lento'),
                        onPressed: vm.ocupado ? null : () => vm.reproducir(lento: true),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Etiqueta('Reproducciones: ${vm.reproducciones}', fondo: Colors.white),
                ]),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _texto,
                decoration: const InputDecoration(hintText: 'Lo que escuché…'),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 52,
                child: FilledButton(onPressed: () => vm.enviar(_texto.text), child: const Text('Comprobar')),
              ),
              Aviso(vm.error),
              if (vm.resultado != null) ...[
                const SizedBox(height: 16),
                Panel(
                  color: Paleta.rosaClaro,
                  padding: const EdgeInsets.all(14),
                  child: Text('Frase correcta: ${vm.actual.ingles}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: Paleta.ciruela)),
                ),
                const SizedBox(height: 10),
                PalabrasColoreadas(vm.resultado!),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    _texto.clear();
                    vm.siguiente();
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Siguiente'),
                ),
              ],
            ]);
          },
        ),
      );
}
