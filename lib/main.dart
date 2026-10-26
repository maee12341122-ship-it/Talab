import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

List<Map<String, dynamic>> globalOrdersList = [];

// معلومات حساب الكريمي للاستلام
const String kaimiAccountName = 'معين هشام المريش';
const String kaimiAccountNumber = '3132548976';

// رقم هاتف المندوب الافتراضي لاستقبال الواتساب
const String deliveryManPhone = '967770000000';

void main() {
  runApp(const TaizDeliveryApp());
}

class TaizDeliveryApp extends StatelessWidget {
  const TaizDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'تطبيق توصيل تعز',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: const Color(0xFF121212),
        brightness: Brightness.dark,
        fontFamily: 'Cairo',
      ),
      home: const TermsScreen(),
    );
  }
}

// ==========================================
// 1. شاشة الشروط والأحكام
// ==========================================
class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الشروط والأحكام'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F1F1F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: SingleChildScrollView(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'مرحباً بك في خدمة التوصيل - مدينة تعز',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '1. الالتزام بإدخال رقم هاتف يمني صحيح للتواصل عند التسليم.\n\n'
                              '2. يلتزم العميل بدفع قيمة الطلب ورسوم التوصيل عند الاستلام نقدًا أو عبر الحوالات.\n\n'
                              '3. يتم تنسيق الطلبات بدقة عالية لضمان سرعة التوصيل.',
                          style: TextStyle(fontSize: 14, height: 1.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('أوافق على جميع الشروط والأحكام'),
                Checkbox(
                  value: _isAccepted,
                  activeColor: Colors.amber,
                  onChanged: (val) {
                    setState(() {
                      _isAccepted = val ?? false;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _isAccepted
                    ? () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                }
                    : null,
                child: const Text('موافقة والمتابعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. تسجيل بيانات العميل
// ==========================================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedArea = 'شارع جمال';
  final List<String> _taizAreas = ['شارع جمال', 'الروضة', 'المسبح', 'عصيفرة', 'الحوبان', 'بير باشا'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل بيانات العميل'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1F1F1F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('أدخل بياناتك لتحديد موقع التوصيل في تعز', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'الاسم الكامل', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person, color: Colors.amber)),
                  validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال الاسم' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'رقم الهاتف اليمني (77/73/71/70)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone, color: Colors.amber)),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'يرجى إدخال الرقم';
                    if (!RegExp(r'^(77|73|71|70|78)\d{7}$').hasMatch(val)) return 'رقم يمني غير صحيح';
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedArea,
                  decoration: const InputDecoration(labelText: 'المنطقة في تعز', border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_city, color: Colors.amber)),
                  items: _taizAreas.map((area) => DropdownMenuItem(value: area, child: Text(area))).toList(),
                  onChanged: (val) => setState(() => _selectedArea = val!),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'عنوان البيت / المحل التفصيلي', border: OutlineInputBorder(), prefixIcon: Icon(Icons.home, color: Colors.amber)),
                  validator: (val) => val == null || val.isEmpty ? 'يرجى إدخال العنوان' : null,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainContainer(
                              userName: _nameController.text,
                              userPhone: _phoneController.text,
                              initialAddress: '$_selectedArea - ${_addressController.text}',
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('دخول للتطبيق', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. الحاويات الرئيسية وإدارة السلة
// ==========================================
class MainContainer extends StatefulWidget {
  final String userName;
  final String userPhone;
  final String initialAddress;

  const MainContainer({super.key, required this.userName, required this.userPhone, required this.initialAddress});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;
  int _lastHomeScreenIndex = 0;
  final List<Map<String, dynamic>> _cart = [];
  late String _currentAddress;

  @override
  void initState() {
    super.initState();
    _currentAddress = widget.initialAddress;
  }

  void _addToCart(String name, int price, int quantity) {
    setState(() {
      int index = _cart.indexWhere((item) => item['name'] == name);
      if (index >= 0) {
        _cart[index]['quantity'] += quantity;
      } else {
        _cart.add({'name': name, 'price': price, 'quantity': quantity});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تمت إضافة $name (الكمية: $quantity) للسلة!'), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        initialCategory: _lastHomeScreenIndex,
        onCategoryChanged: (idx) => _lastHomeScreenIndex = idx,
        onAddToCart: _addToCart,
      ),
      CartScreen(
        cartItems: _cart,
        userName: widget.userName,
        userPhone: widget.userPhone,
        userAddress: _currentAddress,
        onAddressUpdated: (newAddr) => setState(() => _currentAddress = newAddr),
        onReturnToPreviousPlace: () {
          setState(() => _currentIndex = 0);
        },
      ),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: const Color(0xFF1F1F1F),
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.store), label: 'الرئيسية'),
            BottomNavigationBarItem(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_cart),
                  if (_cart.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                        child: Text('${_cart.length}', style: const TextStyle(fontSize: 8, color: Colors.white), textAlign: TextAlign.center),
                      ),
                    ),
                ],
              ),
              label: 'السلة',
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. الشاشة الرئيسية والأقسام
// ==========================================
class HomeScreen extends StatefulWidget {
  final int initialCategory;
  final Function(int) onCategoryChanged;
  final Function(String, int, int) onAddToCart;

  const HomeScreen({super.key, required this.initialCategory, required this.onCategoryChanged, required this.onAddToCart});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _categoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _restaurantsList = [
    {
      'restaurantName': 'مطعم الشيباني',
      'meals': [
        {'name': 'وجبة مشكل سفري', 'price': 3500, 'qty': 1, 'image': 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=300'},
        {'name': 'مظبي لحم', 'price': 5000, 'qty': 1, 'image': 'https://images.unsplash.com/photo-1544025162-d76694265947?w=300'},
      ]
    },
    {
      'restaurantName': 'مطعم الشرق',
      'meals': [
        {'name': 'دجاج شواية مع الأرز', 'price': 4000, 'qty': 1, 'image': 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?w=300'},
        {'name': 'بروستد دجاج', 'price': 3000, 'qty': 1, 'image': 'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?w=300'},
      ]
    }
  ];

  final List<Map<String, dynamic>> _groceriesProducts = [
    {'name': 'حليب المراعي 1 لتر', 'price': 1200, 'qty': 1, 'image': 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=300'},
    {'name': 'سكر الروضة 1 كيلو', 'price': 900, 'qty': 1, 'image': 'https://images.unsplash.com/photo-1581404169727-c1ff3608796f?w=300'},
    {'name': 'زيت طهي 1 لتر', 'price': 1800, 'qty': 1, 'image': 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300'},
  ];

  final List<Map<String, dynamic>> _giftsProducts = [
    {'name': 'عطر بخور يمني ملكي', 'price': 5000, 'qty': 1, 'image': 'https://images.unsplash.com/photo-1523293182086-7651a899d37f?w=300'},
    {'name': 'ساعة يد رجالي أنيقة', 'price': 12000, 'qty': 1, 'image': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=300'},
    {'name': 'طقم هدايا نسائي متكامل', 'price': 15000, 'qty': 1, 'image': 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=300'},
  ];

  @override
  void initState() {
    super.initState();
    _categoryIndex = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = _searchQuery.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('أقسام وتوصيل تعز'),
        backgroundColor: const Color(0xFF1F1F1F),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Colors.amber),
            tooltip: 'لوحة المشرف',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن مطعم أو وجبة أو منتج (من أول حرف)...',
                prefixIcon: const Icon(Icons.search, color: Colors.amber),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _tabItem(0, 'المطاعم', Icons.restaurant),
              _tabItem(1, 'البقالات', Icons.local_grocery_store),
              _tabItem(2, 'هدايا', Icons.card_giftcard),
              _tabItem(3, 'طلبات أخرى', Icons.edit_note),
            ],
          ),
          const Divider(color: Colors.amber),
          Expanded(
            child: isSearching ? _buildSearchResults() : _buildCategoryContent(),
          ),
        ],
      ),
    );
  }

  Widget _tabItem(int index, String title, IconData icon) {
    bool isSelected = _categoryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _categoryIndex = index;
          widget.onCategoryChanged(index);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(color: isSelected ? Colors.amber : const Color(0xFF1F1F1F), borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.black : Colors.amber, size: 20),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    List<Map<String, dynamic>> results = [];

    for (var rest in _restaurantsList) {
      for (var meal in rest['meals']) {
        if (meal['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            rest['restaurantName'].toString().toLowerCase().contains(_searchQuery.toLowerCase())) {
          results.add({'name': '${rest['restaurantName']} - ${meal['name']}', 'price': meal['price'], 'item': meal});
        }
      }
    }
    for (var prod in _groceriesProducts) {
      if (prod['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())) {
        results.add({'name': 'بقالة: ${prod['name']}', 'price': prod['price'], 'item': prod});
      }
    }
    for (var gift in _giftsProducts) {
      if (gift['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase())) {
        results.add({'name': 'هدايا: ${gift['name']}', 'price': gift['price'], 'item': gift});
      }
    }

    if (results.isEmpty) {
      return const Center(child: Text('لا توجد نتائج مطابقة لبحثك', style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        var res = results[index];
        var itemData = res['item'];
        return Card(
          color: const Color(0xFF1F1F1F),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                itemData['image'] ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=300',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, color: Colors.amber),
              ),
            ),
            title: Text(res['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${res['price']} ر.ي', style: const TextStyle(color: Colors.greenAccent)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              onPressed: () => widget.onAddToCart(res['name'], res['price'], itemData['qty'] ?? 1),
              child: const Text('إضافة'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryContent() {
    switch (_categoryIndex) {
      case 0:
        return ListView.builder(
          itemCount: _restaurantsList.length,
          itemBuilder: (context, restIdx) {
            var restaurant = _restaurantsList[restIdx];
            return Card(
              color: const Color(0xFF1F1F1F),
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(restaurant['restaurantName'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                    const Divider(color: Colors.grey),
                    ...List.generate(restaurant['meals'].length, (mealIdx) {
                      var meal = restaurant['meals'][mealIdx];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                meal['image'],
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.restaurant_menu, size: 40, color: Colors.amber),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(meal['name'], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  Text('${meal['price']} ر.ي', style: const TextStyle(color: Colors.greenAccent, fontSize: 12)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.amber),
                                  onPressed: () => setState(() { if (meal['qty'] > 1) meal['qty']--; }),
                                ),
                                Text('${meal['qty']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, size: 20, color: Colors.amber),
                                  onPressed: () => setState(() => meal['qty']++),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 8)),
                                  onPressed: () => widget.onAddToCart('${restaurant['restaurantName']} - ${meal['name']}', meal['price'], meal['qty']),
                                  child: const Text('إضافة', style: TextStyle(fontSize: 11)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );

      case 1:
        return _buildProductListView(_groceriesProducts, 'بقالة');

      case 2:
        return _buildProductListView(_giftsProducts, 'هدية');

      case 3:
        return CustomOrderWidget(onAddToCart: widget.onAddToCart);

      default:
        return Container();
    }
  }

  Widget _buildProductListView(List<Map<String, dynamic>> products, String prefixTag) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        var prod = products[index];
        return Card(
          color: const Color(0xFF1F1F1F),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    prod['image'],
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag, size: 40, color: Colors.amber),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prod['name'], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('${prod['price']} ر.ي', style: const TextStyle(color: Colors.greenAccent, fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.amber),
                      onPressed: () => setState(() { if (prod['qty'] > 1) prod['qty']--; }),
                    ),
                    Text('${prod['qty']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 20, color: Colors.amber),
                      onPressed: () => setState(() => prod['qty']++),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 10)),
                      onPressed: () => widget.onAddToCart('$prefixTag: ${prod['name']}', prod['price'], prod['qty']),
                      child: const Text('إضافة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// 5. طلبات أخرى
// ==========================================
class CustomOrderWidget extends StatefulWidget {
  final Function(String, int, int) onAddToCart;

  const CustomOrderWidget({super.key, required this.onAddToCart});

  @override
  State<CustomOrderWidget> createState() => _CustomOrderWidgetState();
}

class _CustomOrderWidgetState extends State<CustomOrderWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('طلب أغراض خاصة غير موجودة بالقوائم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
            const SizedBox(height: 10),
            const Text('أدخل اسم الطلب وتكلفته التقديرية لإضافته إلى السلة مباشرة:', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 15),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم الطلب أو الغرض (إلزامي)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                prefixIcon: Icon(Icons.edit_note, color: Colors.amber),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'السعر بالريال (إلزامي)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color(0xFF1F1F1F),
                prefixIcon: Icon(Icons.attach_money, color: Colors.amber),
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('إضافة الطلب الخاص إلى السلة', style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  String name = _nameController.text.trim();
                  int? price = int.tryParse(_priceController.text.trim());

                  if (name.isNotEmpty && price != null && price > 0) {
                    widget.onAddToCart('طلب خاص: $name', price, 1);
                    _nameController.clear();
                    _priceController.clear();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('الرجاء إدخال اسم الطلب وسعر صحيح')),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 6. شاشة السلة والدفع
// ==========================================
class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems;
  final String userName;
  final String userPhone;
  final String userAddress;
  final Function(String) onAddressUpdated;
  final VoidCallback onReturnToPreviousPlace;

  const CartScreen({
    super.key,
    required this.cartItems,
    required this.userName,
    required this.userPhone,
    required this.userAddress,
    required this.onAddressUpdated,
    required this.onReturnToPreviousPlace,
  });

  void _showCheckoutDialog(BuildContext context, int totalAmount) {
    TextEditingController addressEditController = TextEditingController(text: userAddress);
    String selectedPaymentMethod = 'الدفع نقداً عند الاستلام';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: AlertDialog(
                backgroundColor: const Color(0xFF1F1F1F),
                title: const Text('إتمام الطلب والدفع', style: TextStyle(color: Colors.amber)),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('عنوان التوصيل في تعز:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 5),
                      TextField(
                        controller: addressEditController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.black26,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text('طريقة الدفع:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
                      RadioListTile<String>(
                        title: const Text('الدفع نقداً عند الاستلام'),
                        value: 'الدفع نقداً عند الاستلام',
                        groupValue: selectedPaymentMethod,
                        activeColor: Colors.amber,
                        onChanged: (val) => setDialogState(() => selectedPaymentMethod = val!),
                      ),
                      RadioListTile<String>(
                        title: const Text('السداد عند الاستلام عبر الكريمي (أو تحويل)'),
                        value: 'السداد عبر الكريمي',
                        groupValue: selectedPaymentMethod,
                        activeColor: Colors.amber,
                        onChanged: (val) => setDialogState(() => selectedPaymentMethod = val!),
                      ),
                      if (selectedPaymentMethod == 'السداد عبر الكريمي') ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('بيانات الحساب للاستلام (الكريمي جو):', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(height: 5),
                              Text('اسم المستفيد: $kaimiAccountName', style: const TextStyle(fontSize: 13)),
                              Text('رقم الحساب: $kaimiAccountNumber', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                              const SizedBox(height: 6),
                              const Text('يمكنك التحويل وإرفاق الإشعار أو السداد لاحقاً.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
                    onPressed: () {
                      onAddressUpdated(addressEditController.text);
                      Navigator.pop(context);
                      _submitFinalOrder(context, addressEditController.text, selectedPaymentMethod, totalAmount);
                    },
                    child: const Text('تأكيد وإرسال الطلب'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _submitFinalOrder(BuildContext context, String finalAddress, String paymentMethod, int totalAmount) {
    if (cartItems.isEmpty) return;

    String orderDetailsText = cartItems.map((item) => "${item['name']} (الكمية: ${item['quantity']})").join('، ');
    String orderId = (globalOrdersList.length + 101).toString();

    globalOrdersList.insert(0, {
      'id': orderId,
      'customerName': userName,
      'customerPhone': userPhone,
      'address': finalAddress,
      'details': orderDetailsText,
      'payment': paymentMethod,
      'status': 'قيد التنسيق - الإجمالي: $totalAmount ر.ي'
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تأكيد الطلب وإرساله إلى المشرف بنجاح!')),
    );

    cartItems.clear();
  }

  @override
  Widget build(BuildContext context) {
    int totalAmount = cartItems.fold(0, (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int));

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة المشتريات'),
        backgroundColor: const Color(0xFF1F1F1F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'الرجوع إلى مكانك السابق',
          onPressed: onReturnToPreviousPlace,
        ),
      ),
      body: cartItems.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('السلة فارغة حالياً', style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, foregroundColor: Colors.black),
              icon: const Icon(Icons.arrow_back),
              label: const Text('الرجوع للمكان السابق'),
              onPressed: onReturnToPreviousPlace,
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var item = cartItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('الكمية: ${item['quantity']} | الإجمالي: ${item['price'] * item['quantity']} ر.ي'),
                  trailing: Text('${item['price']} ر.ي', style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1F1F1F),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('الإجمالي الكلي:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('$totalAmount ر.ي', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                    onPressed: () => _showCheckoutDialog(context, totalAmount),
                    child: const Text('متابعة لاختيار الدفع وتأكيد الطلب', style: TextStyle(fontSize: 15)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ==========================================
// 7. لوحة تحكم المشرف
// ==========================================
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // دالة إجراء اتصال هاتفي عادي بالعميل
  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر إجراء الاتصال بالرقم')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  // دالة فتح محادثة واتساب مع العميل مباشرة بخصوص السعر وتوصيل الطلب
  Future<void> _openCustomerWhatsApp(BuildContext context, String customerPhone, String customerName) async {
    String formattedPhone = customerPhone.startsWith('0') ? customerPhone.substring(1) : customerPhone;
    if (!formattedPhone.startsWith('967')) {
      formattedPhone = '967$formattedPhone';
    }

    String initialMsg = "مرحباً يا عزيزي العميل ($customerName)، بخصوص طلبك من (توصيل تعز)، تواصلنا معك بخصوص إجمالي السعر وأجرة التوصيل:";
    final encodedMsg = Uri.encodeComponent(initialMsg);
    final whatsappUrl = Uri.parse("https://wa.me/$formattedPhone?text=$encodedMsg");

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح الواتساب للعميل')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  // دالة إرسال تفاصيل الطلب للمندوب عبر الواتساب
  Future<void> _launchWhatsApp(BuildContext context, String orderDetails, String address, String customerName, String customerPhone) async {
    String message = "📦 *طلب توصيل جديد - تعز إكسبرس*\n\n"
        "🛍 *الطلبات:* $orderDetails\n"
        "📍 *العنوان:* $address\n"
        "👤 *اسم العميل:* $customerName\n"
        "📞 *رقم العميل:* $customerPhone\n\n"
        "⚠️ يرجى الشراء والتوصيل بأسرع وقت.";

    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUrl = Uri.parse("https://wa.me/$deliveryManPhone?text=$encodedMessage");

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح تطبيق الواتساب')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة تحكم المشرف - الإدارة'),
        backgroundColor: const Color(0xFF1F1F1F),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'تحديث الطلبات',
            onPressed: () => setState(() {}),
          )
        ],
      ),
      body: globalOrdersList.isEmpty
          ? const Center(child: Text('لا توجد طلبات جديدة حالياً', style: TextStyle(color: Colors.grey)))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: globalOrdersList.length,
        itemBuilder: (context, index) {
          var order = globalOrdersList[index];
          return Card(
            color: const Color(0xFF1F1F1F),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('طلب جديد #${order['id']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                        tooltip: 'حذف الطلب',
                        onPressed: () {
                          setState(() {
                            globalOrdersList.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text('العميل: ${order['customerName']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),

                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('الهاتف: ${order['customerPhone']}', style: const TextStyle(color: Colors.cyanAccent, fontSize: 13)),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          minimumSize: const Size(0, 30),
                        ),
                        icon: const Icon(Icons.chat, size: 14),
                        label: const Text('واتساب العميل', style: TextStyle(fontSize: 11)),
                        onPressed: () => _openCustomerWhatsApp(context, order['customerPhone'], order['customerName']),
                      ),

                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.amberAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          minimumSize: const Size(0, 30),
                        ),
                        icon: const Icon(Icons.phone, size: 14),
                        label: const Text('اتصال', style: TextStyle(fontSize: 11)),
                        onPressed: () => _makePhoneCall(context, order['customerPhone']),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Text('العنوان: ${order['address']}', style: const TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('الطلب: ${order['details']}', style: const TextStyle(color: Colors.amber, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('الدفع: ${order['payment'] ?? 'نقداً'}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('الحالة: ${order['status']}', style: const TextStyle(color: Colors.orange, fontSize: 11)),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        icon: const Icon(Icons.chat, size: 16),
                        label: const Text('إرسال للمندوب'),
                        onPressed: () {
                          _launchWhatsApp(
                            context,
                            order['details'],
                            order['address'],
                            order['customerName'],
                            order['customerPhone'],
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}