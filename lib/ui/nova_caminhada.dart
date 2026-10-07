import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';

import '../services/storage_service.dart';
import '../services/location_service.dart';
import '../models/caminhada.dart';

class NovaCaminhadaScreen extends StatefulWidget {
  const NovaCaminhadaScreen({super.key});

  @override
  State<NovaCaminhadaScreen> createState() => _NovaCaminhadaScreenState();
}

class _NovaCaminhadaScreenState extends State<NovaCaminhadaScreen> {
  final LatLng origem = LatLng(-22.713, -46.818);
  LatLng? destino;

  double distancia = 0;
  double calorias = 0;
  double tempo = 0;

  File? imagem;

  final StorageService storage = StorageService();
  final LocationService location = LocationService();

  static const azul = Color(0xFF2563EB);
  static const roxo = Color(0xFF7C3AED);
  static const fundo = Color(0xFFF8FAFC);

  void calcular() {
    if (destino == null) return;

    distancia = location.calcularDistancia(origem, destino!);
    calorias = location.calcularCalorias(distancia);
    tempo = location.calcularTempo(distancia);

    setState(() {});
  }

  Future<void> tirarFoto() async {
    final picker = ImagePicker();

    final foto = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (foto != null && mounted) {
      setState(() {
        imagem = File(foto.path);
      });
    }
  }

  Future<void> salvar() async {
    final tituloController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Título da caminhada",
          style: TextStyle(
            color: roxo,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          controller: tituloController,
          decoration: InputDecoration(
            hintText: "Digite o título",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: azul),
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: azul),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: roxo,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final caminhada = Caminhada(
                titulo: tituloController.text,
                distancia: distancia,
                calorias: calorias,
                tempo: tempo,
                data: DateTime.now(),
                fotoPath: imagem?.path,
              );

              await storage.salvarCaminhada(caminhada);

              if (!mounted) return;

              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Salvar"),
          ),
        ],
      ),
    );

    tituloController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,

      appBar: AppBar(
        title: const Text("Nova Caminhada"),
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: origem,
                  initialZoom: 15,
                  onTap: (tapPosition, latLng) {
                    destino = latLng;
                    calcular();
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                        'com.example.caminhadas',
                  ),

                  if (destino != null)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [origem, destino!],
                          color: roxo,
                          strokeWidth: 5,
                        ),
                      ],
                    ),

                  MarkerLayer(
                    markers: [
                      Marker(
                        point: origem,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_on,
                          color: azul,
                          size: 40,
                        ),
                      ),

                      if (destino != null)
                        Marker(
                          point: destino!,
                          width: 40,
                          height: 40,
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

          if (destino != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    "Vai percorrer ${distancia.toStringAsFixed(0)} m,\nqueimando cerca de ${calorias.toStringAsFixed(0)} calorias\nem aproximadamente ${tempo.toStringAsFixed(0)} min.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: roxo,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (imagem != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        imagem!,
                        height: 140,
                        width: 140,
                        fit: BoxFit.cover,
                      ),
                    ),

                  if (imagem != null)
                    const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: tirarFoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Tirar Foto"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azul,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton.icon(
                    onPressed: salvar,
                    icon: const Icon(Icons.save),
                    label: const Text("Salvar Caminhada"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: roxo,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}