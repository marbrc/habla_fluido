import 'package:flutter/material.dart';

import '../../dominio/comparador.dart';
import '../tema.dart';

/// Muestra cada palabra con color Y con texto: verde bien, ámbar casi, rosa mal u omitida.
class PalabrasColoreadas extends StatelessWidget {
  final ResultadoComparacion resultado;
  const PalabrasColoreadas(this.resultado, {super.key});

  Color _color(EstadoPalabra e) => switch (e) {
        EstadoPalabra.correcta => Paleta.bien,
        EstadoPalabra.parecida => Paleta.casi,
        EstadoPalabra.sustituida => Paleta.mal,
        EstadoPalabra.omitida => Paleta.mal,
        EstadoPalabra.sobrante => Paleta.sobra,
      };

  @override
  Widget build(BuildContext context) {
    final porcentaje = (resultado.puntaje * 100).round();
    return Panel(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('$porcentaje%',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Paleta.ciruela)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              resultado.aprobado ? '¡Muy bien!' : 'Inténtalo otra vez',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: resultado.aprobado ? Paleta.bien : Paleta.violeta,
              ),
            ),
          ),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(value: resultado.puntaje, minHeight: 8),
        ),
        const SizedBox(height: 14),
        Wrap(spacing: 6, runSpacing: 6, children: [
          for (final p in resultado.palabras)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _color(p.estado).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                p.estado == EstadoPalabra.sobrante ? '+ ${p.dicha}' : (p.esperada ?? ''),
                style: TextStyle(
                  color: _color(p.estado),
                  fontWeight: FontWeight.w700,
                  decoration: p.estado == EstadoPalabra.omitida ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
        ]),
        if (resultado.porPracticar.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Practica: ${resultado.porPracticar.join(", ")}',
              style: const TextStyle(color: Paleta.suave)),
        ],
        const SizedBox(height: 10),
        const Wrap(spacing: 12, runSpacing: 4, children: [
          _Leyenda(Paleta.bien, 'bien'),
          _Leyenda(Paleta.casi, 'casi'),
          _Leyenda(Paleta.mal, 'mal / faltó'),
          _Leyenda(Paleta.sobra, 'sobró'),
        ]),
      ]),
    );
  }
}

class _Leyenda extends StatelessWidget {
  final Color color;
  final String texto;
  const _Leyenda(this.color, this.texto);
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(texto, style: const TextStyle(fontSize: 12, color: Paleta.suave)),
      ]);
}

/// Mensaje amable de error (no muestra detalles técnicos).
class Aviso extends StatelessWidget {
  final String? texto;
  const Aviso(this.texto, {super.key});
  @override
  Widget build(BuildContext context) => texto == null
      ? const SizedBox.shrink()
      : Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Paleta.rosaClaro,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(children: [
            const Icon(Icons.info_outline_rounded, color: Paleta.violeta, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(texto!, style: const TextStyle(color: Paleta.ciruela))),
          ]),
        );
}

/// Contenedor blanco redondeado con borde fino: la "tarjeta" base de toda la app.
class Panel extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsets padding;
  const Panel({super.key, required this.child, this.color = Colors.white, this.padding = const EdgeInsets.all(18)});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Paleta.borde),
        ),
        child: child,
      );
}

/// Etiqueta pequeña tipo "pastilla".
class Etiqueta extends StatelessWidget {
  final String texto;
  final Color fondo;
  final Color color;
  const Etiqueta(this.texto, {super.key, this.fondo = Paleta.lila, this.color = Paleta.violeta});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: fondo, borderRadius: BorderRadius.circular(20)),
        child: Text(texto, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
      );
}

/// La frase de práctica en grande, con su traducción y consejo.
class TarjetaFrase extends StatelessWidget {
  final String ingles;
  final String? espanol;
  final String? foco;
  final String? consejo;
  const TarjetaFrase({super.key, required this.ingles, this.espanol, this.foco, this.consejo});

  @override
  Widget build(BuildContext context) => Panel(
        color: Paleta.lila,
        padding: const EdgeInsets.all(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (foco != null) ...[Etiqueta(foco!, fondo: Colors.white), const SizedBox(height: 14)],
          Text(ingles,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w700, color: Paleta.ciruela, height: 1.25)),
          if (espanol != null) ...[
            const SizedBox(height: 6),
            Text(espanol!, style: const TextStyle(fontSize: 16, color: Paleta.suave)),
          ],
          if (consejo != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.lightbulb_outline_rounded, size: 18, color: Paleta.violeta),
                const SizedBox(width: 8),
                Expanded(child: Text(consejo!, style: const TextStyle(color: Paleta.texto, height: 1.35))),
              ]),
            ),
          ],
        ]),
      );
}

/// Pantalla amable cuando un nivel todavía no tiene contenido.
class SinContenido extends StatelessWidget {
  const SinContenido({super.key});
  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('Aún no hay ejercicios para tu nivel.\n¡Pronto agregaremos más!',
              textAlign: TextAlign.center, style: TextStyle(color: Paleta.suave, fontSize: 16)),
        ),
      );
}
