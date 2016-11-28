openssl req -newkey rsa:2048 -sha256 -nodes -keyout telegram.key -x509 -days 365 -out telegram.pem -subj "/C=IT/ST=state/L=location/O=description/CN=your_domain.com"

openssl pkcs12 -export -in telegram.pem -inkey telegram.key -out telegram.p12 -name telegram

keytool -importkeystore -deststorepass password -destkeypass password -destkeystore telegram.store -srckeystore telegram.p12 -srcstoretype PKCS12 -srcstorepass password -alias telegram

openssl x509 -outform der -in telegram.pem -out telegram.der

keytool -import -alias telegram_cert -keystore telegram.store -file telegram.der

_____ THE OTHER WAY AROUND ______

keytool -genkey -keyalg RSA -keystore telegram.store -storepass password -validity 360 -keysize 2048

keytool -importkeystore -srckeystore telegram.store -destkeystore telegram.p12 -srcstoretype jks -deststoretype pkcs12

openssl pkcs12 -in telegram.p12 -out telegram.pem

openssl x509 -outform der -in telegram.pem -out telegram.der

keytool -import -alias telegram -keystore cacerts -file telegram.der

cp telegram.pem telegram_cert.pem // remove everything but -----BEGIN CERTIFICATE----- ... -----END CERTIFICATE-----

_____ THE OTHER *OTHER* WAY AROUND ______

openssl req -newkey rsa:2048 -sha256 -nodes -keyout telegram.key -x509 -days 365 -out telegram.pem -subj "/C=IT/ST=IT/L=IT/O=IT/CN=IP_ADDRESS"

// TO TRY: 
	openssl s_server -accept 8443 -key telegram.key -cert telegram.pem

	curl -F "url=https://IP_ADDRESS:8443/update" -F "certificate=@telegram.pem" https://api.telegram.org:443/bot263069999:AAHnl_Q7_eV_xzR-mA6jmtQZV57rP1YQYEA/setWebhook

openssl x509 -outform der -in telegram.pem -out telegram.der

keytool -import -alias telegram_cert -keystore telegram.store -file telegram.der

_____ THE OTHER *OTHER* *OTHER* WAY AROUND ______

keytool -genkeypair -keystore telegram.store -dname "CN=IP_ADDRESS, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown" -keypass password -storepass password -keyalg RSA -alias telegram -ext SAN=ip:IP_ADDRESS

