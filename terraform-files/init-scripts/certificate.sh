country = GB
state=London
locality=London
organization=Sparta
unit=10x
common=sparta.global
email=tthaheem@spartaglobal.com

openssl req -x509 -newkey rsa:4096 -nodes -out cert.pem -keyout key.pem -days 365 \
    -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$unit"

mkdir certs
mv cert.pem certs/
mv key.pem certs/
chmod 400 certs/key.pem
