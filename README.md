# 🐾 Ứng Dụng Chăm Sóc Thú Cưng 🐾  

Ứng dụng Chăm Sóc Thú Cưng là nền tảng trực tuyến hỗ trợ người dùng quản lý hồ sơ thú cưng, đặt các dịch vụ chăm sóc và khám chữa bệnh tại phòng khám thú y hoặc dịch vụ tại nhà. Đồng thời, ứng dụng cung cấp một cộng đồng thú cưng năng động để người dùng chia sẻ bài viết, tương tác qua lượt thích và bình luận.  

---

## 🎯 **Mô Tả Dự Án**  
- Quản lý hồ sơ thú cưng: Thêm, cập nhật, và quản lý thông tin thú cưng.  
- Đặt lịch dịch vụ thú y: Dễ dàng tìm kiếm và đặt lịch khám gần nhà.  
- Đăng ký đối tác: Cho phép phòng khám hoặc nhà cung cấp dịch vụ tham gia hệ thống.  
- Cộng đồng thú cưng: Người dùng có thể chia sẻ bài viết, thích, và bình luận với những người yêu thú cưng khác.  

---

## 🚀 **Tính Năng Chính**  
- **Đăng nhập/Đăng ký:** Sử dụng Session để quản lý phiên làm việc và lưu trạng thái trong Shared Preferences (Flutter).  
- **Quản lý hồ sơ thú cưng:** Tạo, đọc, sửa, xóa thông tin thú cưng.  
- **Đặt lịch dịch vụ:** Tìm kiếm và đặt lịch dịch vụ thú y hoặc chăm sóc thú cưng tại nhà.  
- **Cộng đồng thú cưng:** Đăng bài, bình luận, và tương tác với cộng đồng yêu thú cưng.   
- **Hỗ trợ một số ngôn ngữ:** Tiếng Việt, Tiếng Anh.  

---

## ⚙️ **Công Nghệ Sử Dụng**  

### **Backend:**  
- **Spring Boot:** Framework chính để phát triển API và xử lý logic nghiệp vụ.  
- **MySQL:** Cơ sở dữ liệu lưu trữ thông tin người dùng, thú cưng, và giao dịch.  
- **Session:** Quản lý trạng thái đăng nhập người dùng trên server.  

### **Frontend:**  
- **Flutter:** Phát triển giao diện ứng dụng đa nền tảng (iOS, Android).  
- **Shared Preferences:** Lưu trạng thái đăng nhập cục bộ trên thiết bị.  

### **API và Tích Hợp:**  
- **Google Maps API:** Tìm kiếm dịch vụ thú y gần nhà.  
- **Push Notifications:** Thông báo cập nhật trạng thái dịch vụ.  

---

## 📋 **Chức Năng CRUD**  
- **Hồ sơ thú cưng:** Tạo, đọc, sửa, và xóa thông tin thú cưng.  
- **Bài viết cộng đồng:** Quản lý bài viết, lượt thích, và bình luận.  
- **Đối tác:** Quản lý tài khoản đối tác cung cấp dịch vụ.  

---

## 💳 **Đặt Lịch**  
- **Đặt dịch vụ:** Lựa chọn phòng khám hoặc dịch vụ gần nhà.  

---

## 🛠️ **Cài Đặt và Chạy Dự Án**  

### **Yêu Cầu Hệ Thống:**  
- **Flutter SDK**  
- **JDK 17+**  
- **Spring Boot 3.0+**  
- **MySQL 8.0+**  

### **Hướng Dẫn Cài Đặt:**  

1. **Clone repository:**  
   ```bash
   git clone https://github.com/QuangHung2801/PetCareApp.git
