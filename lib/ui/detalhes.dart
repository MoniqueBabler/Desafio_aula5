import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/caminhada.dart';

class DetalhesScreen extends StatelessWidget {
  final Caminhada caminhada;

  const DetalhesScreen({
    super.key,
    required this.caminhada,
  });

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2563EB);
    const roxo = Color(0xFF7C3AED);
    const fundo = Color(0xFFF8FAFC);

    // Ponto inicial
    final origem = LatLng(-22.713, -46.818);

    // Ponto final
    final destino = LatLng(-22.710, -46.812);

    return Scaffold(
      appBar: AppBar(
        title: Text(caminhada.titulo),
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: fundo,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (caminhada.fotoPath != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(caminhada.fotoPath!),
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 20),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.straighten, color: azul),
                          const SizedBox(width: 8),
                          Text(
                            "Distância: ${caminhada.distancia.toStringAsFixed(0)} m",
                            style: const TextStyle(
                              color: azul,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(Icons.local_fire_department,
                              color: roxo),
                          const SizedBox(width: 8),
                          Text(
                            "Calorias: ${caminhada.calorias.toStringAsFixed(0)} kcal",
                            style: const TextStyle(
                              color: roxo,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(Icons.timer, color: azul),
                          const SizedBox(width: 8),
                          Text(
                            "Tempo: ${caminhada.tempo.toStringAsFixed(0)} min",
                            style: const TextStyle(
                              color: azul,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(Icons.calendar_today, color: roxo),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Data: ${caminhada.data.toLocal().toString().substring(0, 16)}",
                              style: const TextStyle(
                                color: roxo,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                "Percurso",
                style: TextStyle(
                  color: roxo,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: origem,
                      initialZoom: 14,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'com.example.caminhadas',
                      ),

                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [origem, destino],
                            strokeWidth: 6,
                            color: roxo,
                          ),
                        ],
                      ),

                      MarkerLayer(
                        markers: [
                          Marker(
                            point: origem,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_on,
                              color: azul,
                              size: 45,
                            ),
                          ),

                          Marker(
                            point: destino,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.flag,
                              color: roxo,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}