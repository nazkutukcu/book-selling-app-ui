import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(
    MaterialApp(
      // Hedef platform iOS ise bu tasarımı kullan:
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          // iOS değilse bu tasarımı kullan:
          : kDefaultTheme,
      title: 'FriendlyChat',
      home: ChatScreen(),
    ),
  );
}

// iOS için belirlediğimiz tasarım.
final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);
// Diğer platformlar için belirlediğimiz tasarım.
final ThemeData kDefaultTheme = ThemeData(
  primarySwatch: Colors.purple,
  accentColor: Colors.orangeAccent[400],
);

/* ChatScreen StatefulWidget'ı ile bir Scaffold 
döndüreceğiz. body parametresine ListView.builder
ve içine metin giriş alanı tasarımı yaptığımız bir 
başka widget'ı _buildTextComposer'ı vereceğiz. */
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  // ChatMessage sınıfından üreteceğimiz nesneleri tutacak.
  final List<ChatMessage> _messages = [];
  // TextField'ın aldığı değerleri tutacak.
  final _textController = TextEditingController();
  // Metin giriş alanına imleci yeniden odaklamayı sağlıyor.
  final FocusNode _focusNode = FocusNode();
  /* TextField'ın içi doldurulunca true olarak
  değerini true olarak değiştireceğimiz değişken */
  bool _isComposing = false;
  /* Buton çalıştığında veya enter'a basıldığında
  çaşışacak fonksiyon */
  void _handleSubmitted(String text) {
    // TextField'ın içini temizliyor.
    _textController.clear();
    /* İçinde mesaj tutan mesaj kutusu
    tasarımından (ChatMessage sınfından) 
    bir nesne oluşturuyor. */
    ChatMessage message = ChatMessage(
      /* Fonksiyonun aldığı text parametresi
      ChatMessage sınıfının yapıcı metoduna
      iletiliyor. */
      text: text,
      /* ChatMessage sınıfının ikinci yapıcı 
      metoduna iletilen animasyon ile ilgili değerler */
      animationController: AnimationController(
        duration: const Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      /* Üretilen nesne _messages listesinin en 
      başına ekleniyor. */
      _messages.insert(0, message);
      /* _isComposing'i yeniden false'a çeviriyor */
      _isComposing = false;
    });
    // TextField'a imleci odaklamayı tetikleyen kod:
    _focusNode.requestFocus();
    // Animasyonu tetikleyen kod.
    message.animationController.forward();
  }

  /* Metin giriş alanı tasarımını bu widget'ın içerisine
  yaptık */
  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(children: [
          Flexible(
            child: TextField(
              /* onChanged TextField'daki her değişikliği
              algılar. */
              onChanged: (String text) {
                setState(() {
                  /* Eğer TextField dolu ise _isComposing
                  true olacak. */
                  _isComposing = text.length > 0; // NEW
                });
              },
              controller: _textController,
              /* _isComposing true ise fonksiyon çalışabilir. 
              yoksa çalışamaz. */
              onSubmitted: _isComposing ? _handleSubmitted : null,
              decoration: InputDecoration.collapsed(hintText: 'Send a message'),
              /* _focusNode'un, imleci odaklayacağı yeri tanımladık. */
              focusNode: _focusNode,
            ),
          ),
          /* Hedef platfrom iOS ise üstünde Send yazan buton
          tasarımını göstecek */
          Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoButton(
                  child: Text('Send'),
                  /* _isComposing true ise fonksiyon çalışabilir. 
                  yoksa çalışamaz. */
                  onPressed: _isComposing
                      ? () => _handleSubmitted(_textController.text)
                      : null,
                )
              // iOS değilse varsayılan buton tasarımı gösterilecek.
              : IconButton(
                  icon: const Icon(Icons.send),
                  /* _isComposing true ise fonksiyon çalışabilir. 
                  yoksa çalışamaz. */
                  onPressed: _isComposing
                      /* Butona tıklayınca, TextField'ın 
                      içindeki değeri _handleSubmitted 
                      fonksiyonuna iletecek. */
                      ? () => _handleSubmitted(_textController.text)
                      : null),
        ]),
      ),
    );
  }

  /* Animasyonları, kullanıldıktan sonra 
 temizleyen kod */
  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(.75),
        title: Text('Satıcı ile Mesajlaş'),
        /* Hedef platfrom iOS ise AppBar'ın altında gölge olmasın.
        iOS değilse gölge olsun. */
        elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
      ),
      body: Container(
        // Hedef platfrom iOS ise bu renkler kullanılsın.
        decoration: Theme.of(context).platform == TargetPlatform.iOS
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.red),
                ),
              )
            : null,
        child: Column(
          children: [
            Flexible(
              /* _messages listesindeki elemanları ekranda
              kaydırılabilir liste olarak oluşturacak. */
              child: ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              /* ListView.builder'ın altında, metin giriş alanı tasarımını
              yaptığımız widget'ı veriyoruz. */
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }
}

// Kullanıcı ismi olarak tanımladığımız değişken.
String _name = 'Sarah Will';

/* Gönderilen mesajları göstereceğimiz mesaj kutusu widget'ı.
Bu widget ile bir CircleAvatar() ve iki Text() widget tutan 
bir tasarım yapacağız. Sonra bu widget'tan nesneler üretip bir
listenin içerisine (_messages listesine) koyacağız. Listeyi de 
ListView.builder ile ekranda göstereceğiz. Bu işlemleri yukarıdaki 
stateful widget (ChatScreen) içerisinde yapacağız. */
class ChatMessage extends StatelessWidget {
  /* İki kurucu metot alıyor. Birincisi mesaj için,
  İkicisi animasyon için */
  ChatMessage({required this.text, required this.animationController});
  /* Bu text değişkenine iletilen değeri Text() widget içinde
  gösteceğiz. */
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              /* Kullanıcı isminin ilk harfini profil resmi
              yerine gösterecek CircleAvatar widget */
              child: CircleAvatar(child: Text(_name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_name, style: Theme.of(context).textTheme.headline4),
                  Container(
                    margin: EdgeInsets.only(top: 5.0),
                    // Kurucu metodun aldığı text değeri:
                    child: Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
