import 'package:flutter/material.dart';

import '../../dependencias.dart';
import '../tema.dart';
import '../vm/pronunciacion_vm.dart';
import 'widgets.dart';

class PantallaPronunciacion extends StatefulWidget {
  final Dependencias deps;
  const PantallaPronunciacion({super.key, required this.deps});
  @override
  State<PantallaPronunciacion> createState() => _EstadoPantalla();
}

class _EstadoPantalla extends State<PantallaPronunciacion> {
  late final PronunciacionViewModel vm = PronunciacionViewModel(widget.deps.voz, widget.deps.aprendizaje);

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Pronunciación')),
        body: ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            if (vm.frases.isEmpty) return const SinContenido();
            final f = vm.actual;
            return ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 28), children: [
              const Text('Escucha el modelo y repítelo enseguida (shadowing).',
                  style: TextStyle(color: Paleta.suave)),
              const SizedBox(height: 14),
              TarjetaFrase(ingles: f.ingles, espanol: f.espanol, foco: f.foco, consejo: f.consejo),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.volume_up_rounded),
                    label: const Text('Escuchar'),
                    onPressed: vm.ocupado ? null : () => vm.escucharModelo(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.slow_motion_video_rounded),
                    label: const Text('Lento'),
                    onPressed: vm.ocupado ? null : () => vm.escucharModelo(lento: true),
                  ),
                ),
              ]),
              const SizedBox(height: 10),
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  icon: const Icon(Icons.mic_rounded),
                  label: Text(vm.ocupado ? 'Escuchando…' : 'Repetir en voz alta'),
                  onPressed: vm.ocupado ? null : vm.grabar,
                ),
              ),
              Aviso(vm.error),
              if (vm.resultado != null) ...[
                const SizedBox(height: 16),
                Text('Te entendí: "${vm.escuchado}"', style: const TextStyle(color: Paleta.suave)),
                const SizedBox(height: 8),
                PalabrasColoreadas(vm.resultado!),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: vm.siguiente,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Siguiente frase'),
                ),
              ],
              const SizedBox(height: 18),
              const Text(
                'Nota: la app mide si el reconocedor de voz te entendió. Es una guía de inteligibilidad, '
                'no un examen de acento.',
                style: TextStyle(fontStyle: FontStyle.italic, color: Paleta.suave, fontSize: 13),
              ),
            ]);
          },
        ),
      );
}
