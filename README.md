# Pokémon Team (Flutter)

แอปจัดทีมโปเกมอนด้วย Flutter + GetX + GetStorage  
สร้างทีมได้ 3 ตัว เลือก/ค้นหา/แก้ไข/ลบ และบันทึกลงเครื่องให้กลับมาแล้วข้อมูลยังอยู่ รองรับทั้ง Mobile และ Web

---

## คุณสมบัติ
- เลือกโปเกมอนเข้าทีมได้ทีละ 3 ตัว
- รีเซ็ตโปเกมอนที่เลือก
- ค้นหาโปเกมอนตามชื่อ  
- ตั้งชื่อทีม บันทึกทีม แก้ไขทีม
- ข้อมูลทีมเก็บถาวรด้วย GetStorage
- รองรับ Android, iOS, Web  

---

## เทคโนโลยีที่ใช้
- [Flutter](https://flutter.dev/) (Dart)  
- [GetX](https://pub.dev/packages/get) – state management และ routing  
- [GetStorage](https://pub.dev/packages/get_storage) – local storage  
- Pokémon API ภายนอก (ไม่เปลี่ยนแปลงจากต้นฉบับ)  

---

## การติดตั้งและรัน

### 1) โคลนโปรเจกต์
git clone https://github.com/SiXMaRs/PokemonTeam.git
cd PokemonTeam

### 2) ติดตั้ง dependency
flutter pub get

### 3) รันแอป
-web
flutter run -d "Your browser"

-android emulator
flutter run -d android

---

## วิธีใช้งาน
1. เปิดแอป → เห็นหน้า รายชื่อทีม
2. กด บวก ขวาล่างเพื่อสร้างทีม
3. ตั้งชื่อทีม
4. ลือกโปเกมอน3ตัวด้านล่าง หรือค้นหาโปเกมอนด้วยช่องค้นหา
5. กด reset เพื่อล้างโปเกมอนที่เลือก
6. เลือกครบตั้งชื่อทีมเสร็จกดบันทึก เพื่อบันทึกทีม
7. กดไอคอนดินสอเพื่อแก้ไข

---

## การตรวจสอบก่อนบันทึก
- ต้องตั้งชื่อทีม
- ต้องเลือกโปเกมอนครบ 3 ตัว
- หากไม่ครบจะมี snackbar แจ้งเตือนและไม่บันทึก

