# Tarım Yapay Zeka (Agricultural AI)

**Tarım Yapay Zeka**, çiftçilerin tarımsal faaliyetlerini verilere ve yapay zeka analizlerine dayanarak planlamalarına yardımcı olan yenilikçi bir web uygulamasıdır. Proje, modern bir React önyüzü (Frontend) ve Python FastAPI tabanlı bir arka uç (Backend) mimarisiyle geliştirilmiştir.

## 🚀 Proje Özeti

Bu platform, çiftçilere aşağıdaki konularda rehberlik etmeyi amaçlamaktadır:
- **İklim ve Hava Durumu Analizi:** Bölgesel hava durumu ve iklim istatistiklerini takip etme.
- **Yapay Zeka Destekli Öneriler:** Toprak, bölge ve iklim verilerine dayanarak en kârlı ve uygun ürün ekimi tavsiyeleri (Örn: Buğday, Ayçiçeği, Mısır).
- **Planlama Sihirbazı (Plan Wizard):** Gelecek sezon için adım adım ekim ve hasat planı oluşturma.
- **Piyasa Trendleri:** Tarımsal ürünlerin piyasa durumları ve kazanç projeksiyonları.

## 🛠️ Teknoloji Yığını (Tech Stack)

### Backend (Arka Uç)
- **Dil / Çerçeve:** Python, FastAPI
- **Sunucu:** Uvicorn
- **Veri Doğrulama:** Pydantic
- **Özellikler:** RESTful API mimarisi, CORS desteği, Mock (sahte) veri sağlama (şimdilik yapay zeka ve veritabanı entegrasyonu simüle edilmektedir).

### Frontend (Ön Uç)
- **Kütüphane:** React 19
- **Derleyici (Build Tool):** Vite
- **Yönlendirme (Routing):** React Router DOM
- **Görselleştirme \& İkonlar:** Recharts (Grafikler), Lucide-React (İkonlar)
- **Stil:** Standart CSS modülleri ve genel stiller (`App.css`, `index.css`).

---

## 📂 Proje Yapısı

\`\`\`text
tarım yapay zeka/
├── backend/
│   ├── main.py              # FastAPI uygulamasının ana dosyası (API Uç Noktaları)
│   └── requirements.txt     # Python bağımlılıkları (fastapi, uvicorn, pydantic)
│
└── frontend/
    ├── package.json         # Node.js bağımlılıkları ve script'ler
    ├── vite.config.js       # Vite yapılandırması
    ├── index.html           # Ana HTML şablonu
    └── src/
        ├── App.jsx          # Ana React Bileşeni ve Yönlendirme (Routing)
        ├── main.jsx         # React giriş noktası
        ├── components/      # Ortak Bileşenler (Örn: Layout vb.)
        └── pages/           # Sayfalar:
            ├── Login.jsx             # Kullanıcı Girişi
            ├── Dashboard.jsx         # Kontrol Paneli (Genel Özet)
            ├── PlanWizard.jsx        # Yeni Ekim Planı Oluşturma Asistanı
            ├── AiRecommendations.jsx # Yapay Zeka Ürün Tavsiyeleri
            ├── ClimateMarket.jsx     # İklim ve Piyasa Verileri
            └── Profile.jsx           # Kullanıcı Profili ve Ayarlar
\`\`\`

---

## ⚙️ Kurulum ve Çalıştırma

Platformu kendi bilgisayarınızda çalıştırmak için aşağıdaki adımları izleyin.

### 1. Backend'i (Arka Uç) Başlatma
Terminalinizde `backend` dizinine gidin ve aşağıdaki komutları çalıştırın:

\`\`\`bash
cd "tarım yapay zeka/backend"

# (İsteğe bağlı) Sanal ortam oluşturun ve aktif edin
python -m venv venv
# Windows için:
venv\Scripts\activate
# Mac/Linux için:
source venv/bin/activate

# Gerekli kütüphaneleri yükleyin
pip install -r requirements.txt

# FastAPI sunucusunu çalıştırın
uvicorn main:app --reload
\`\`\`
*Backend `http://127.0.0.1:8000` adresinde çalışmaya başlayacaktır. API dokümantasyonuna `http://127.0.0.1:8000/docs` adresinden erişebilirsiniz.*

### 2. Frontend'i (Ön Uç) Başlatma
Farklı bir terminal penceresinde `frontend` dizinine gidin:

\`\`\`bash
cd "tarım yapay zeka/frontend"

# Gerekli Node modüllerini yükleyin
npm install

# Geliştirme sunucusunu başlatın
npm run dev
\`\`\`
*Frontend, terminalde belirtilen yerel adreste (genellikle `http://localhost:5173`) çalışmaya başlayacaktır.*

---

## 🔌 API Uç Noktaları (Endpoints) Özeti

Backend `main.py` dosyasında aşağıdaki temel uç noktalar bulunmaktadır:

- `POST /api/auth/login` : Kullanıcı girişi ve JWT token (mock) oluşturma.
- `GET /api/dashboard/summary` : Hava durumu, toprak nemi ve piyasa trendi özetini getirir.
- `GET /api/dashboard/alerts` : Kullanıcıya özel tarımsal uyarıları (kuraklık riski, arz fazlası vb.) listeler.
- `GET /api/dashboard/history` : Geçmiş ekim/hasat planlarının tarihçesini sunar.
- `POST /api/ai/analyze-plan` : Belirtilen bölge, arazi büyüklüğü ve ürün bilgisine göre yapay zeka destekli kârlılık skoru ve alternatif ürün önerileri sunar.
- `GET /api/climate/data` : Belirli bir periyoda (Örn: 1Y) ait yağış ve sıcaklık geçmişini, yapay zeka yorumuyla birlikte döndürür.

---

## 💡 Gelecek Geliştirmeler (Roadmap)
- Gerçek bir Makine Öğrenmesi (Machine Learning) modeli entegrasyonu.
- PostgreSQL veya MongoDB ile kalıcı veritabanı bağlantısı.
- Canlı hava durumu API'leri (Örn: OpenWeatherMap) entegrasyonu.
- JWT tabanlı gerçek kimlik doğrulama.
