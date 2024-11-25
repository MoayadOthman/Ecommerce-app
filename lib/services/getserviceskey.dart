import 'package:googleapis_auth/auth_io.dart'; // استيراد مكتبة googleapis_auth لاستخدام OAuth2 في التوثيق.

class GetServerKey { // تعريف كلاس GetServerKey للحصول على مفتاح الخدمة.
  Future<String> getServerKeyToken() async { // تعريف دالة غير متزامنة للحصول على توكن مفتاح الخدمة.
    final scopes = [ // تعريف قائمة بالنطاقات التي نحتاجها للوصول إلى APIs المختلفة.
      'https://www.googleapis.com/auth/userinfo.email', // النطاق الخاص بالحصول على معلومات البريد الإلكتروني للمستخدم.
      'https://www.googleapis.com/auth/firebase.database', // النطاق للوصول إلى قاعدة بيانات Firebase.
      'https://www.googleapis.com/auth/firebase.messaging', // النطاق للوصول إلى خدمة Firebase Messaging.
    ];

    // إنشاء عميل عبر حساب الخدمة باستخدام معلومات التوثيق.
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({ // تحويل بيانات حساب الخدمة من JSON.
          "type": "service_account", // نوع الحساب.
          "project_id": "ecommerce-7650e", // معرّف المشروع في Google Cloud.
          "private_key_id": "faa0515d0a78f8feb61fbb0d785c6fda7b1d45e8", // معرّف المفتاح الخاص.
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDPx/6oU0b+Xadq\n7oCY0l6JmbrtuRW4W+z+j+D7+utS7/560vjAGpVu/+wCQEFX9fkY/GqKFFx3tloF\nVdViCz1ucWBvdJD4BXIHFbChmCIo8y43XD5HTQoQRBjJx4kVfbeDRLECA5cRXjR4\nR61wgY/RXyUc9AAXqvrdUngNux1ZN0UvzRIAhY09oN9tZ4nhkoXjCvg3M8+ee61J\nD/jWtE9ZIH3H8fTrSdNVfUQSzBxQAYSa9S8fn/9dTcEd+u3hta9Q9AGR4JatXEXL\npOrP5EnB8iOEGnUsQcJfPn8FPueTUv04JdYkTqLC0dRWtiZcHHPVwvCUjOAleB8j\nGzIIkmS/AgMBAAECggEACXbcItGsQwDZaTWqQOEa3PIA1ubegOfFsJtgIvTSdul8\nnMlIUFka+RPfgwNnQTjwhZKrIv/7bZkuRN5HL8Xq9ewPJEnZzUT+On637XG5uJt0\naEwjgBRCbZbpzs3FG5Kpjb6kFhSQyIHof5lljTbcP1ax9j19AEGnAfbJhiKW8Hh5\na4cRHYt/VI3nw0EmvRonb6ZAPHMUsrwQkdoAJ9NLA3b3VgI/50ZSjyOcYjjgLXOR\nxCWPHWfLWt6vFXSapEgza6VBZj4bkNgmcuG7SkOReK8dLkYt6qbxugNKyoQY4LMA\naG3k3oS7cauRPA/Vhep5Ld932yOMdIS3/mKSJO2J9QKBgQD9kMfPmiNt7Bc0mLkX\nWIdkouuEEAchukyCAHtWjPY1RttMoDIQwt4SI5zvYkBnFdhYz88BSFDCSnfJ9+5j\nXvuy/mp6HNqz+i8//LaLJMdi/i/t5in+jUVWy3n0pIrtfpKn8bIer+2mn+Bc+NZg\nSTiES2PYHgL2ik/U7ALTb1u6UwKBgQDRxq8320LJ6f5/sgdOkSR3yD8i92xiYi6g\n4NneO6sie2kZOyqRDpMEZz7kASZSnv2EJeGQpp8VvWARPEly85FvAekEHrF895sj\nekXueBXKvkbx4NPncwTKvjOkR1QUp5tZI+T9o+TeX24F0BjWhIw58r1lDKpHIg2W\n+TOQ/s5WZQKBgFnjtoHpMcApHvzdW1hkYPMTMozJpc2WHsNDanX/WNUAPoQGklkQ\ny+sARwUx/oTM4LpzSP46Za7K+XZW92Kw7GfC+3o4umttOMzlSM1BB5IXbGRY4PBF\nopwnXB+XKU0SPulcrHlmgsg8CyzKZi0SJ//2PfoCgahm1fA0jrfn1UvTAoGAR/Fn\n7jQYN780NP8NWniUlS/r10YbubIKY8o5benwyyaf6LNN6emhqgTuoKt0RSmZsFR9\ng2phbMdBxydx2SaHXha9n1gXbtBMOGKa0SoF7z5KfnGoutvLbOzGMTT1NRA2St/w\njLxEpa78wKmZmxhiLw18vscVLsgS+RAGC1gX07ECgYEA28oMIGliYisSW3giJstS\nFnf2QtJw69QisiUECoUBJQD6kQKGAKjBuuNMLRByuMu4nAH7MnnXDNGs1K90sXd+\nBvloqH6rd9NACW/r4JiERi+a1AaXGMBMtSgMltLHYc3nbkpmPefZqPeszQkwItCN\n6cNE+qNvHmIHlGm+7gtkvE4=\n-----END PRIVATE KEY-----\n", // المفتاح الخاص بالتوثيق.
          "client_email": "firebase-adminsdk-q1mab@ecommerce-7650e.iam.gserviceaccount.com", // البريد الإلكتروني لعميل الخدمة.
          "client_id": "101903821018169733010", // معرّف العميل.
          "auth_uri": "https://accounts.google.com/o/oauth2/auth", // عنوان URL الخاص بتوثيق OAuth2.
          "token_uri": "https://oauth2.googleapis.com/token", // عنوان URL للحصول على التوكن.
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs", // عنوان URL لشهادة موفر التوثيق.
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-q1mab%40ecommerce-7650e.iam.gserviceaccount.com", // عنوان URL لشهادة العميل.
          "universe_domain": "googleapis.com" // نطاق خدمة Google APIs.
        }),
        scopes // تمرير النطاقات المحددة.
    );

    final accessServerKey = client.credentials.accessToken.data; // الحصول على توكن الوصول من بيانات الاعتماد الخاصة بالعميل.
    return accessServerKey; // إرجاع توكن الوصول.
  }
}
