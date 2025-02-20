import 'package:flutter/material.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  PhotoScreenState createState() => PhotoScreenState();
}

class PhotoScreenState extends State<PhotoScreen> {
  List<bool> likedPhotos = List<bool>.filled(15, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Galeria de Fotos'),
        backgroundColor: Colors.red,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: 15,
        itemBuilder: (context, index) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset(
                    'img/photo${index + 1}.jpg',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      IconButton(
                        icon: Icon(
                          likedPhotos[index] ? Icons.favorite : Icons.favorite_border,
                          color: likedPhotos[index] ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => setState(() {
                          likedPhotos[index] = !likedPhotos[index];
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
