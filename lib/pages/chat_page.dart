import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

// TickerProviderStateMixin: para que se puedan mostrar animaciones y que cada uno de los cuadros esté
// sincronizado con el vertical sync.
class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;

  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3,),
            Text('Melissa Flores', style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              )
            ),
            Divider(height: 1,),
            Container(
              color: Colors.white,
              height: 60,
              child: _inputChat(),
            )

          ],
        ),
      ),
   );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 8.0
        ),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (texto) {
                  setState(() {
                    if (texto.trim().length > 0) {
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje',
                ),
                focusNode: _focusNode,
              )
            ),
            // Botón de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
              ? CupertinoButton(
                  child: Text('Enviar'), 
                  onPressed: _estaEscribiendo
                    ? () => _handleSubmit(_textController.text.trim())
                    : null,
                )
              : Container(
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    icon: Icon(Icons.send),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: _estaEscribiendo
                      ? () => _handleSubmit(_textController.text.trim())
                      : null,
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  _handleSubmit(String texto) {

    if (texto.length == 0) return;

    print(texto);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      uid: '123', 
      texto: texto,
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)), // Gracias a: with TickerProviderStateMixin
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward(); // Dispara la animación.

    setState(() {
      _estaEscribiendo = false;
    });
  }

  // Para cuando vallamos a terminar de usar esta pantalla(cuando usamos algún
  // controlador o al usar la comunización por).
    @override
  void dispose() {
    // TODO: off del socket

    // Borramos las animaciones en los mensajes para que no nos ocupen memoria
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}