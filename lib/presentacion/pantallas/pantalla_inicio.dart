import 'package:flutter/material.dart';

import '../../dependencias.dart';
import '../../dominio/nivel.dart';
import '../tema.dart';
import 'pantalla_conversacion.dart';
import 'pantalla_dictado.dart';
import 'pantalla_escritura.dart';
import 'pantalla_lectura.dart';
import 'pantalla_pronunciacion.dart';
import 'pantalla_repaso.dart';
import 'widgets.dart';

class PantallaInicio extends StatelessWidget {
  final Dependencias deps;
  const PantallaInicio({super.key, required this.deps});

  void _ir(BuildContext c, Widget w) => Navigator.of(c).push(MaterialPageRoute(builder: (_) => w));

  Widget _destino(Habilidad h) => switch (h) {
        Habilidad.escucha => PantallaDictado(deps: deps),
        Habilidad.pronunciacion => PantallaPronunciacion(deps: deps),
        Habilidad.lectura => PantallaLectura(deps: deps),
        Habilidad.escritura => PantallaEscritura(deps: deps),
        Habilidad.conversacion => PantallaConversacion(deps: deps),
      };

  @override
  Widget build(BuildContext context) {
    final vm = deps.aprendizaje;
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            final plan = vm.plan;
            final total = plan.fold<int>(0, (a, b) => a + b.minutos);
            final pendientes = vm.pendientes.length;
            return ListView(padding: const EdgeInsets.fromLTRB(20, 16, 20, 28), children: [
              // ---------- Encabezado ----------
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Paleta.violeta, Color(0xFF9B7BC9), Color(0xFFD9A3C4)],
                  ),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Row(children: [
                    Text('Habla Fluido',
                        style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                    SizedBox(width: 6),
                    Text('🎀', style: TextStyle(fontSize: 22)),
                  ]),
                  const SizedBox(height: 4),
                  const Text('Tu práctica de inglés de hoy',
                      style: TextStyle(color: Color(0xFFF3EAFB), fontSize: 15)),
                  const SizedBox(height: 18),
                  Row(children: [
                    _Insignia(titulo: 'Nivel', valor: vm.nivel.etiqueta),
                    const SizedBox(width: 10),
                    _Insignia(titulo: 'Racha', valor: '🔥 ${vm.progreso.racha}'),
                    const SizedBox(width: 10),
                    _Insignia(titulo: 'Repasos', valor: '$pendientes'),
                  ]),
                ]),
              ),
              const SizedBox(height: 16),

              if (vm.puedeSubirDeNivel) ...[
                Panel(
                  color: Paleta.rosaClaro,
                  child: Row(children: [
                    const Text('🎉', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('¡Dominas este nivel!',
                            style: TextStyle(fontWeight: FontWeight.w700, color: Paleta.ciruela)),
                        Text('Ya puedes pasar a ${vm.nivel.siguiente!.etiqueta}',
                            style: const TextStyle(color: Paleta.suave)),
                      ]),
                    ),
                    FilledButton(onPressed: vm.subirDeNivel, child: const Text('Subir')),
                  ]),
                ),
                const SizedBox(height: 16),
              ],

              // ---------- Plan del día ----------
              Row(children: [
                const Text('Plan de hoy',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Paleta.ciruela)),
                const Spacer(),
                Etiqueta('$total min'),
              ]),
              const SizedBox(height: 4),
              const Text('Más tiempo a lo que te cuesta más ✨', style: TextStyle(color: Paleta.suave)),
              const SizedBox(height: 12),
              for (final b in plan) ...[
                _TarjetaHabilidad(
                  habilidad: b.habilidad,
                  minutos: b.minutos,
                  refuerzo: b.esRefuerzo,
                  dominio: vm.progreso.dominioDe(b.habilidad),
                  alTocar: () => _ir(context, _destino(b.habilidad)),
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 6),

              // ---------- Repaso ----------
              Material(
                color: Paleta.ciruela,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _ir(context, PantallaRepaso(deps: deps)),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.style_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('Repaso espaciado',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                          Text(
                            pendientes == 0 ? 'Todo al día 💜' : '$pendientes frase(s) esperándote',
                            style: const TextStyle(color: Color(0xFFD9CCEB)),
                          ),
                        ]),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Colors.white),
                    ]),
                  ),
                ),
              ),
            ]);
          },
        ),
      ),
    );
  }
}

class _Insignia extends StatelessWidget {
  final String titulo;
  final String valor;
  const _Insignia({required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(titulo, style: const TextStyle(color: Color(0xFFF3EAFB), fontSize: 12)),
            const SizedBox(height: 2),
            Text(valor, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          ]),
        ),
      );
}

class _TarjetaHabilidad extends StatelessWidget {
  final Habilidad habilidad;
  final int minutos;
  final bool refuerzo;
  final double dominio;
  final VoidCallback alTocar;
  const _TarjetaHabilidad({
    required this.habilidad,
    required this.minutos,
    required this.refuerzo,
    required this.dominio,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: alTocar,
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: refuerzo ? Paleta.rosa : Paleta.borde, width: refuerzo ? 1.5 : 1),
            ),
            child: Row(children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: refuerzo ? Paleta.rosaClaro : Paleta.lila,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(iconoDe(habilidad), color: Paleta.violeta),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                    Text(habilidad.nombre,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Paleta.ciruela)),
                    if (refuerzo) const Etiqueta('refuerzo 🎀', fondo: Paleta.rosaClaro, color: Color(0xFFB0577D)),
                  ]),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(value: dominio, minHeight: 6),
                  ),
                ]),
              ),
              const SizedBox(width: 14),
              Column(children: [
                Text('$minutos',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Paleta.violeta)),
                const Text('min', style: TextStyle(fontSize: 12, color: Paleta.suave)),
              ]),
            ]),
          ),
        ),
      );
}
