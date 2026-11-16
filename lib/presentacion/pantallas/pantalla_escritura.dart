import 'package:flutter/material.dart';

import '../../dependencias.dart';
import '../tema.dart';
import '../vm/escritura_vm.dart';
import 'widgets.dart';

class PantallaEscritura extends StatefulWidget {
  final Dependencias deps;
  const PantallaEscritura({super.key, required this.deps});
  @override
  State<PantallaEscritura> createState() => _EstadoPantalla();
}

class _EstadoPantalla extends State<PantallaEscritura> {
  late final EscrituraViewModel vm = EscrituraViewModel(widget.deps.tutor, widget.deps.aprendizaje);
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Escritura')),
        body: ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            final r = vm.resultado;
            return ListView(padding: const EdgeInsets.fromLTRB(20, 4, 20, 28), children: [
              Panel(
                color: Paleta.lila,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Etiqueta('Tema de hoy', fondo: Colors.white),
                  const SizedBox(height: 10),
                  Text(vm.tema,
                      style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Paleta.ciruela)),
                ]),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _texto,
                maxLines: 6,
                maxLength: 500,
                decoration: const InputDecoration(hintText: 'Write here…'),
              ),
              SizedBox(
                height: 52,
                child: FilledButton.icon(
                  icon: const Icon(Icons.auto_awesome_rounded),
                  onPressed: vm.ocupado ? null : () => vm.enviar(_texto.text),
                  label: Text(vm.ocupado ? 'Revisando…' : 'Pedir corrección'),
                ),
              ),
              Aviso(vm.error),
              if (r != null) ...[
                const SizedBox(height: 18),
                Text(r.respuesta,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Paleta.ciruela)),
                const SizedBox(height: 10),
                for (final c in r.correcciones) ...[
                  _Correccion(original: c.original, corregido: c.corregido, explicacion: c.explicacion),
                  const SizedBox(height: 8),
                ],
                if (r.textoCorregido != null) ...[
                  const SizedBox(height: 6),
                  Panel(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Versión corregida',
                          style: TextStyle(fontWeight: FontWeight.w700, color: Paleta.violeta)),
                      const SizedBox(height: 6),
                      Text(r.textoCorregido!, style: const TextStyle(fontSize: 16, height: 1.45)),
                    ]),
                  ),
                ],
                if (r.siguientePregunta != null) ...[
                  const SizedBox(height: 10),
                  Panel(
                    color: Paleta.rosaClaro,
                    padding: const EdgeInsets.all(14),
                    child: Text('Reto: ${r.siguientePregunta}',
                        style: const TextStyle(color: Paleta.ciruela, fontWeight: FontWeight.w600)),
                  ),
                ],
              ],
            ]);
          },
        ),
      );
}

class _Correccion extends StatelessWidget {
  final String original;
  final String corregido;
  final String explicacion;
  const _Correccion({required this.original, required this.corregido, required this.explicacion});

  @override
  Widget build(BuildContext context) => Panel(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 8, runSpacing: 4, children: [
            Text(original,
                style: const TextStyle(
                    color: Paleta.mal, decoration: TextDecoration.lineThrough, fontWeight: FontWeight.w600)),
            const Icon(Icons.arrow_forward_rounded, size: 16, color: Paleta.suave),
            Text(corregido, style: const TextStyle(color: Paleta.bien, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 6),
          Text(explicacion, style: const TextStyle(color: Paleta.suave, height: 1.35)),
        ]),
      );
}
