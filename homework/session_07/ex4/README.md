# Bài 4: Cấu hình Reverse Proxy Nginx cho ứng dụng Spring Boot

Thư mục này chứa toàn bộ tài liệu cấu hình, mã nguồn tĩnh và mã kịch bản tự động hóa quá trình cấu hình Nginx Server Block làm Reverse Proxy cho hệ thống Spring Boot.

## Cấu trúc thư mục

- `spring-proxy.conf`: Tệp cấu hình máy chủ ảo Nginx (Reverse Proxy & Static Serve).
- `index.html`: Trang chủ tĩnh chứa thông tin học viên được phục vụ trực tiếp tại root `/`.
- `setup.sh`: Script Shell tự động hóa việc triển khai thư mục, phân quyền, liên kết cấu hình và khởi động lại Nginx.

## Chức năng cấu hình định tuyến

1. **Trang tĩnh (`/`)**:
   - Nginx trực tiếp phân phối tệp `index.html` từ thư mục `/var/www/html/` mà không cần chuyển tiếp tới Backend giúp tăng hiệu năng hệ thống.
2. **Đường dẫn API (`/api/`)**:
   - Chuyển tiếp (Reverse Proxy) tất cả các request bắt đầu bằng `/api/` tới dịch vụ Spring Boot đang chạy tại cổng `8082` (`http://127.0.0.1:8082/`).
   - Đảm bảo giữ nguyên thông tin Header gốc (`Host`, `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto`) để Backend nhận dạng đúng Client.

## Hướng dẫn cài đặt và chạy

### Bước 1: Phân quyền thực thi cho Script

```bash
chmod +x setup.sh
```

### Bước 2: Chạy Script tự động thiết lập

```bash
./setup.sh
```

### Bước 3: Kiểm tra cấu hình Nginx

Để đảm bảo cấu hình chính xác, chạy lệnh sau:
```bash
sudo nginx -t
```
**Kết quả mong đợi:**
```text
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

### Bước 4: Kiểm tra phản hồi HTTP bằng Curl

- **Kiểm tra truy cập trang tĩnh (Root `/`):**
  ```bash
  curl -I http://localhost/
  ```
  *Kết quả mong đợi:* Mã HTTP trả về `200 OK`.

- **Kiểm tra Reverse Proxy tới Backend (`/api/health`):**
  ```bash
  curl -I http://localhost/api/health
  ```
  *Kết quả mong đợi:* Nhận được mã phản hồi tương ứng trực tiếp từ ứng dụng Spring Boot backend mà không gặp lỗi `502 Bad Gateway` (Nếu cổng `8082` đã được start thành công).

## Ảnh chụp màn hình kết quả thực nghiệm
![Kết quả thực nghiệm](nginx_verification_result.png)
