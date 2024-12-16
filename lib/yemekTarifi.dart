import 'package:flutter/material.dart';

// Yemek Tarifleri Sayfası

class FoodRecipesPage extends StatefulWidget {
  @override
  _FoodRecipesPageState createState() => _FoodRecipesPageState();
}

class _FoodRecipesPageState extends State<FoodRecipesPage> {
  List<String> recipes = [
    'Köfte',
    'Makarna',
    'Salata',
    'Çorba',
    'Pilav',
    'Izgara Balık',
  ];

  List<List<String>> ingredients = [
    ['500g kıyma', '1 adet soğan', '1 dilim bayat ekmek', '1 yumurta', 'Tuz, karabiber'],
    ['250g makarna', '2 yemek kaşığı zeytinyağı', '1 diş sarımsak', 'Tuz', 'Karabiber'],
    ['1 adet marul', '2 adet domates', '1 adet salatalık', 'Zeytinyağı', 'Limon suyu'],
    ['1 adet soğan', '2 diş sarımsak', '2 adet havuç', '1 litre su', 'Tuz'],
    ['2 su bardağı pirinç', '4 su bardağı su', '1 yemek kaşığı tereyağı', 'Tuz'],
    ['2 adet levrek fileto', '1 limon', 'Taze otlar', 'Zeytinyağı', 'Tuz, karabiber'],
  ];

  List<List<String>> steps = [
    ['Kıymayı bir kapta yoğurun.', 'Soğanı rendeleyin ve ekleyin.', 'Baharatları ekleyin ve köfte şekli verin.', 'Kızartın veya fırınlayın.'],
    ['Makarnayı haşlayın.', 'Zeytinyağını tavada ısıtın.', 'Sarımsağı ekleyin ve kavurun.', 'Makarnayı ekleyip karıştırın.'],
    ['Marulu doğrayın.', 'Domates ve salatalığı ekleyin.', 'Zeytinyağı ve limon suyu ile soslayın.'],
    ['Soğanı ve sarımsağı kavurun.', 'Havuçları ekleyin ve soteleyin.', 'Su ekleyin ve kaynamaya bırakın.'],
    ['Pirinçleri yıkayın.', 'Tereyağını eritip pirinçleri ekleyin.', 'Su ve tuz ekleyip pişirin.'],
    ['Balıkları limon ve otlarla marine edin.', 'Izgarada pişirin.'],
  ];

  List<bool> isFavorited = List.generate(6, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Yemek Tarifleri', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                  title: Text(
                    recipes[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isFavorited[index] ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited[index] ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorited[index] = !isFavorited[index];
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodRecipeDetailPage(
                          recipeName: recipes[index],
                          ingredients: ingredients[index],
                          steps: steps[index],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Yemek Tarifi Detay Sayfası
class FoodRecipeDetailPage extends StatelessWidget {
  final String recipeName;
  final List<String> ingredients;
  final List<String> steps;

  FoodRecipeDetailPage({required this.recipeName, required this.ingredients, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(recipeName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Malzemeler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 8.0),
              _buildIngredientsList(),
              SizedBox(height: 16.0),
              Text(
                'Yapılışı',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 8.0),
              _buildRecipeSteps(),
            ],
          ),
        ),
      ),
    );
  }

  // Yemek malzemelerini listeleyen widget
  Widget _buildIngredientsList() {
    return Column(
      children: ingredients.map((ingredient) => _ingredientTile(ingredient)).toList(),
    );
  }

  // Her malzeme için ListTile oluşturan widget
  Widget _ingredientTile(String ingredient) {
    return ListTile(
      leading: Icon(Icons.check_circle, color: Colors.green),
      title: Text(ingredient),
    );
  }

  // Yemek yapılışını listeleyen widget
  Widget _buildRecipeSteps() {
    return Column(
      children: steps.asMap().entries.map((entry) {
        int index = entry.key;
        String step = entry.value;
        return _recipeStepTile('Adım ${index + 1}', step);
      }).toList(),
    );
  }

// Her adım için ListTile oluşturan widget
  Widget _recipeStepTile(String step, String description) {
    return ListTile(
      leading: Text(step, style: TextStyle(fontWeight: FontWeight.bold)),
      title: Text(description),
    );
  }
}