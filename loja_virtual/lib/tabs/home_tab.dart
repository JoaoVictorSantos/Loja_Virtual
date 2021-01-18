import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  Widget _buildBodyBack() => Container(
        decoration: BoxDecoration(
          //Forma de fazer um degrade na tela do app
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168)
              ],
              //Indica onde o degrade vai começar e terminar
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
      );

  @override
  Widget build(BuildContext context) {
    //Permite fazer sobreposição de widget na tela
    return Stack(
      children: [
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            //Forma de deixar a appBar flutuando no inicio da tela e deslizando sobre a pagina.
            SliverAppBar(
              floating:
                  true, //Faz com que a appbar fique flutuando na começo da pagina
              snap:
                  true, //Faz com que a barra apareca, quando a appbar não está aparecendo e o usuario rola a tela para cima.
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              //Forma de deixar a appBar no mesmo nivel do degrade e sem deixar sombra
              //Forma de deixar o texto centralizado
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection("home")
                    .orderBy("pos")
                    .getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    //Como só pode Sliver, precisa fazer uma adaptação no CircularProgress
                    return SliverToBoxAdapter(
                      child: Container(
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return SliverStaggeredGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0,
                      staggeredTiles: snapshot.data.documents.map((doc) {
                        //forma de pegar o tamanho que deve ser ocupado na vertical e horizontal
                        return StaggeredTile.count(
                            doc.data["x"], doc.data["y"]);
                      }).toList(),
                      children: snapshot.data.documents.map((doc) {
                        //forma de apresenta a imagem que está na internet
                        return FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: doc.data["image"],
                          fit: BoxFit.cover,
                        );
                      }).toList(),
                    );
                  }
                })
          ],
        )
      ],
    );
  }
}
