import 'package:flutter/material.dart';
import 'package:overheard/product/constants/product_colors.dart';
import 'package:overheard/product/constants/product_padding.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gizlilik Politikası',
          style: TextStyle(color: ProductColors.instance.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const ProductPadding.allMedium(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _policySection(
              "1. Veri Toplama",
              "OverHeard olarak, size daha iyi bir deneyim sunmak için kullanıcı adınız, e-posta adresiniz ve profil bilgileriniz gibi temel verileri topluyoruz.",
            ),
            _policySection(
              "2. Verilerin Kullanımı",
              "Toplanan veriler, hesabınızın güvenliğini sağlamak, topluluk kurallarını ihlal eden içerikleri denetlemek ve uygulama içi etkileşimlerinizi yönetmek amacıyla kullanılır.",
            ),
            _policySection(
              "3. Üçüncü Taraflar",
              "Verileriniz hiçbir koşulda reklam ajanslarına veya üçüncü taraf şirketlere satılmaz. Sadece Firebase (Google) altyapısı üzerinde güvenle saklanır.",
            ),
            _policySection(
              "4. Kullanıcı Hakları",
              "İstediğiniz zaman ayarlar kısmından hesabınızı ve tüm verilerinizi kalıcı olarak silme hakkına sahipsiniz.",
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Son Güncelleme: Aralık 2025",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _policySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
