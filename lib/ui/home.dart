import 'dart:io';

import 'package:flutter/material.dart';

import '../models/caminhada.dart';
import '../services/storage_service.dart';
import 'nova_caminhada.dart';
import '../widgets/drawer_menu.dart';
import 'detalhes.dart';

class Home extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const Home({super.key, required this.onToggleTheme});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final StorageService storage = StorageService();

  List<Caminhada> caminhadas = [];

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {
    final lista = await storage.carregarCaminhadas();
    setState(() => caminhadas = lista);
  }

  @override
  Widget build(BuildContext context) {
    const azul = Color(0xFF2563EB);
    const roxo = Color(0xFF7C3AED);
    const fundo = Color(0xFFF8FAFC);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Caminhadas'),
        backgroundColor: azul,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      drawer: DrawerMenu(onToggleTheme: widget.onToggleTheme),

      backgroundColor: fundo,

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: caminhadas.isEmpty
            ? const Center(
                child: Text(
                  'Nenhuma caminhada cadastrada.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : GridView.builder(
                itemCount: caminhadas.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final c = caminhadas[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    splashColor: azul.withValues(alpha: 0.15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalhesScreen(caminhada: c),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color:azul.withValues(alpha: 0.2)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            c.fotoPath == null
                                ? const Icon(Icons.photo, size: 65, color: azul)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(c.fotoPath!),
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                            const SizedBox(height: 12),

                            Text(
                              c.titulo,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: roxo,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              '${c.distancia.toStringAsFixed(0)} m',
                              style: const TextStyle(color: azul, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: roxo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NovaCaminhadaScreen()),
          );

          carregar();
        },
      ),
    );
  }
}
