import 'package:flutter/material.dart';

import '../../dependencias.dart';
import '../tema.dart';
import '../vm/conversacion_vm.dart';
import 'widgets.dart';

class PantallaConversacion extends StatefulWidget {
  final Dependencias deps;
  const PantallaConversacion({super.key, required this.deps});
  @override
  State<PantallaConversacion> createState() => _EstadoPantalla();
}

class _EstadoPantalla extends State<PantallaConversacion> {
  late final ConversacionViewModel vm =
      ConversacionViewModel(widget.deps.tutor, widget.deps.voz, widget.deps.aprendizaje)..iniciar();
  final _texto = TextEditingController();

  @override
  void dispose() {
    _texto.dispose();
    vm.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final t = _texto.text;
    _texto.clear();
    await vm.enviar(t);
    if (vm.textoNoEnviado != null) _texto.text = vm.textoNoEnviado!;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Row(children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Paleta.lila,
              child: Text('🎀', style: TextStyle(fontSize: 16)),
            ),
            SizedBox(width: 10),
            Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Tu tutora'),
              Text('English practice', style: TextStyle(fontSize: 12, color: Paleta.suave, fontWeight: FontWeight.w400)),
            ]),
          ]),
          actions: [
            ListenableBuilder(
              listenable: vm,
              builder: (_, __) => IconButton(
                tooltip: 'Voz del tutor',
                icon: Icon(vm.autoVoz ? Icons.volume_up_rounded : Icons.volume_off_rounded),
                onPressed: vm.alternarAutoVoz,
              ),
            ),
          ],
        ),
        body: ListenableBuilder(
          listenable: vm,
          builder: (context, _) => Column(children: [
            Expanded(
              child: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), children: [
                for (final m in vm.historial) _Burbuja(texto: m.texto, mia: m.delEstudiante),
                if (vm.ocupado)
                  const Padding(
                    padding: EdgeInsets.only(left: 6, top: 4),
                    child: Text('escribiendo… ✍️', style: TextStyle(color: Paleta.suave)),
                  ),
                for (final c in vm.ultimasCorrecciones)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Paleta.rosaClaro,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('✏️ ${c.original}  →  ${c.corregido}',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: Paleta.ciruela)),
                      const SizedBox(height: 4),
                      Text(c.explicacion, style: const TextStyle(color: Paleta.texto, height: 1.35)),
                    ]),
                  ),
                Aviso(vm.error),
              ]),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Paleta.borde)),
              ),
              child: SafeArea(
                top: false,
                child: Row(children: [
                  IconButton.filledTonal(
                    icon: const Icon(Icons.mic_rounded),
                    onPressed: vm.ocupado ? null : vm.dictar,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _texto,
                      maxLength: ConversacionViewModel.maxCaracteres,
                      decoration: const InputDecoration(
                        hintText: 'Type or tap the mic…',
                        counterText: '',
                        fillColor: Paleta.lavanda,
                      ),
                      onSubmitted: (_) => _enviar(),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton.filled(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: vm.ocupado ? null : _enviar,
                  ),
                ]),
              ),
            ),
          ]),
        ),
      );
}

class _Burbuja extends StatelessWidget {
  final String texto;
  final bool mia;
  const _Burbuja({required this.texto, required this.mia});

  @override
  Widget build(BuildContext context) => Align(
        alignment: mia ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: mia ? Paleta.violeta : Colors.white,
            border: mia ? null : Border.all(color: Paleta.borde),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(mia ? 20 : 6),
              bottomRight: Radius.circular(mia ? 6 : 20),
            ),
          ),
          child: Text(texto,
              style: TextStyle(color: mia ? Colors.white : Paleta.texto, fontSize: 16, height: 1.35)),
        ),
      );
}
