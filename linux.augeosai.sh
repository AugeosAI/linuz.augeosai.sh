#!/bin/bash

echo "Creating new host configuration"


# Install filebeat
echo "Installing log capture tool"
if which dpkg  > /dev/null; then
    echo "Command succeeded"
    yes | sudo curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.6.4-amd64.deb
    yes | sudo dpkg -i filebeat-5.6.4-amd64.deb
    yes | sudo rm filebeat-5.6.4-amd64.deb
else
    yes | sudo curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.6.4-x86_64.rpm
    yes | sudo rpm -vi filebeat-5.6.4-x86_64.rpm
    yes | sudo rm filebeat-5.6.4-x86_64.rpm
fi


echo "Copy configuration files and certs"

# Copy files
sudo bash -c "cat > /etc/filebeat/filebeat.yml" << EOF
filebeat.prospectors:
- input_type: log

  paths:
    - /var/log/*
    - /var/log/**/*

  exclude_files: [".gz$"]
    
  fields:  
    client: augeosai.com

output.logstash:
  hosts: ["log.augeosai.com:5044"]
  ssl.certificate_authorities: ["/etc/filebeat/augeosai-ca.crt"]
  ssl.certificate: "/etc/filebeat/augeosai.com.client.crt"
  ssl.key: "/etc/filebeat/augeosai.com.client.key"
  ssl.supported_protocols: "TLSv1.2"

logging.level: info

logging.selectors: ["*"]

EOF

sudo bash -c "cat > /etc/filebeat/augeosai.com.client.key" << EOF
-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----

EOF

sudo bash -c "cat > /etc/filebeat/augeosai.com.client.crt" << EOF
-----BEGIN CERTIFICATE-----
MIIGjDCCBXSgAwIBAgIJAMLphioNqOnxMA0GCSqGSIb3DQEBDQUAMIGyMQswCQYD
VQQGEwJVUzELMAkGA1UECAwCQ0ExEjAQBgNVBAcMCVNhbiBEaWVnbzEWMBQGA1UE
CgwNRGV0ZXhpYW4gSW5jLjEsMCoGA1UECwwjRGV0ZXhpYW4gSW5jLiBDZXJ0aWZp
Y2F0ZSBBdXRob3JpdHkxGjAYBgNVBAMMEWxvZ3MuZGV0ZXhpYW4uY29tMSAwHgYJ
KoZIhvcNAQkBFhFpbmZvQGRldGV4aWFuLmNvbTAeFw0xODEyMjkxNzE5MTRaFw0y
ODEyMjYxNzE5MTRaMIG8MQswCQYDVQQGEwJVUzELMAkGA1UECAwCQ0ExEjAQBgNV
BAcMCVNhbiBEaWVnbzEOMAwGA1UEEQwFOTIxMzExFjAUBgNVBAoMDUNvcGlsb3Rj
byBMTEMxIDAeBgNVBAsMF2ZpbGViZWF0IGNvdmVudHJ5LmFjLnVrMR8wHQYDVQQD
DBZmaWxlYmVhdC5jb3BpbG90Y28uY29tMSEwHwYJKoZIhvcNAQkBFhJpbmZvQGNv
cGlsb3Rjby5jb20wggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDA3XBA
8iiVarphqLIM9HSw2Mx+D+cUHVMPchpfUMsB6e33SgZwU5DNyP+3dBDQ2Z3rV/HQ
QylMFPnLEJ9i5AyKkYOn1lUlKSyFZQKv4YxqTNHOxn2VWDiXvqm/TE8cr+gTBg/6
avWLscEbebIYMj1XO3qUH/DWA/NR5Rvz54qc00aZF9Itzi8M2Tt+RlkkvzrL+8YS
rmdZJ118Z3gJuGmXCbtbALu8Uv4wHr9sOsI0H2oVagrqNdLiawhE9DyxRHOP3/jN
U3NPXm9aDTIyUoo9XsiuJZ28uFmokYGUClriazukDg7+nxJkpBrgKRdMxJXR5cw+
AUFlCLuvsuND2i4W2YV/kPeeEc904urbGfqLyLoEdl4w0tIZ2xcHvvRe2gZGcFrE
kMsa0aVAXS6PvHOgcHVJ0LjIEr24+NsAA4jbTahNCZaRx/3xtTB7y2GmhJbnQbN7
o4dB2RCStpxZ7lnhcx1WXmXufT7AmPZn8e/PCOtZY4BwES3jm5FrPcTZ/6UwV3qp
mvwtAUTyCJJBqJkxGLkCG+EW6/nE8CuM6U6RtbnfwtqkCVRXZZhTGuULiOh5MGVQ
nP+YGzD94bzDThecH4sza2caXS0Cyb1l0k5kDqHqRzQEw3UQ9c5iCCyh9QRIXijs
tH021oIsPTH+j/3FwkAIsAmW1mQFmX8RbPS81wIDAQABo4IBlzCCAZMwCQYDVR0T
BAIwADARBglghkgBhvhCAQEEBAMCBsAwOwYJYIZIAYb4QgENBC4WLE9wZW5TU0wg
RmlsZUJlYXQgU2VydmVyIC8gQ2xpZW50IENlcnRpZmljYXRlMB0GA1UdDgQWBBRK
7IYJWavq20V6emo+Yz+BSFQHyDCB5wYDVR0jBIHfMIHcgBQdnV+YUpMSCVFf+xau
Z3Oufqp+oaGBuKSBtTCBsjELMAkGA1UEBhMCVVMxCzAJBgNVBAgMAkNBMRIwEAYD
VQQHDAlTYW4gRGllZ28xFjAUBgNVBAoMDURldGV4aWFuIEluYy4xLDAqBgNVBAsM
I0RldGV4aWFuIEluYy4gQ2VydGlmaWNhdGUgQXV0aG9yaXR5MRowGAYDVQQDDBFs
b2dzLmRldGV4aWFuLmNvbTEgMB4GCSqGSIb3DQEJARYRaW5mb0BkZXRleGlhbi5j
b22CCQCp7YcgDq8pwzAOBgNVHQ8BAf8EBAMCA+gwHQYDVR0lBBYwFAYIKwYBBQUH
AwEGCCsGAQUFBwMCMA0GCSqGSIb3DQEBDQUAA4IBAQBMPsK6c9M5ukxa7vKM5pWZ
ZXiTagXDHxFfhki8pMiLII5P1cKwnIGZsW2jXcHMMcr+5M8BpMnt42lKMIdCXpJ7
gRK9XNZDlgaA9yck/e8o00MY96kLliBLD8mowFuhtMNXqsqO24fFGGvaxlV77XUo
NGGtlyxpA1c7A9YIpAT1WDMUSTl9P9JMJrT1YFvu+5Su1Su1oEIOW+EB1P0Tldir
zl4hd9hYK2UCv9o13fD/F49D/8EzAoj3q2NtyaSufJ2V4gtK3gna7pw+rE4o33Hk
YG82DE8/SgrRua0/KtgwgyARy1EAy6pCVBe8kqR6L8fHXsV+iB7/zJGKZ8MildXM
-----END CERTIFICATE-----

EOF

sudo bash -c "cat > /etc/filebeat/augeosai.com.client.csr" << EOF
-----BEGIN CERTIFICATE REQUEST-----
MIIFPzCCAycCAQAwgbwxCzAJBgNVBAYTAlVTMQswCQYDVQQIDAJDQTESMBAGA1UE
BwwJU2FuIERpZWdvMQ4wDAYDVQQRDAU5MjEzMTEWMBQGA1UECgwNQ29waWxvdGNv
IExMQzEgMB4GA1UECwwXZmlsZWJlYXQgY292ZW50cnkuYWMudWsxHzAdBgNVBAMM
FmZpbGViZWF0LmNvcGlsb3Rjby5jb20xITAfBgkqhkiG9w0BCQEWEmluZm9AY29w
aWxvdGNvLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMDdcEDy
KJVqumGosgz0dLDYzH4P5xQdUw9yGl9QywHp7fdKBnBTkM3I/7d0ENDZnetX8dBD
KUwU+csQn2LkDIqRg6fWVSUpLIVlAq/hjGpM0c7GfZVYOJe+qb9MTxyv6BMGD/pq
9YuxwRt5shgyPVc7epQf8NYD81HlG/PnipzTRpkX0i3OLwzZO35GWSS/Osv7xhKu
Z1knXXxneAm4aZcJu1sAu7xS/jAev2w6wjQfahVqCuo10uJrCET0PLFEc4/f+M1T
c09eb1oNMjJSij1eyK4lnby4WaiRgZQKWuJrO6QODv6fEmSkGuApF0zEldHlzD4B
QWUIu6+y40PaLhbZhX+Q954Rz3Ti6tsZ+ovIugR2XjDS0hnbFwe+9F7aBkZwWsSQ
yxrRpUBdLo+8c6BwdUnQuMgSvbj42wADiNtNqE0JlpHH/fG1MHvLYaaEludBs3uj
h0HZEJK2nFnuWeFzHVZeZe59PsCY9mfx788I61ljgHARLeObkWs9xNn/pTBXeqma
/C0BRPIIkkGomTEYuQIb4Rbr+cTwK4zpTpG1ud/C2qQJVFdlmFMa5QuI6HkwZVCc
/5gbMP3hvMNOF5wfizNrZxpdLQLJvWXSTmQOoepHNATDdRD1zmIILKH1BEheKOy0
fTbWgiw9Mf6P/cXCQAiwCZbWZAWZfxFs9LzXAgMBAAGgPTA7BgkqhkiG9w0BCQ4x
LjAsMAsGA1UdDwQEAwIEMDAdBgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIw
DQYJKoZIhvcNAQENBQADggIBAJXwqzj8f1lkKLn4vNMKji8UukuSK3zLwxT0QPkT
n1C2OLMAbWaokqhSfJrAmPhyFJ34HxRRSGBCOudRNKtmgif44TL84FssJW5q9Xl7
VVYMVazt93tyxE3m3VsHLm0Oz1Bl4sP1oSAWzTyP7V22lQ1wA7VRnG2rv9Pzz2hx
ZIncyxCDFb/PQhEox8tJPaA0ee4x7zD9igUxxdHE19T+6ZEpsaOwHstY+gtVl3eW
/fHHt4xYnF0WXfbF1av7NiWAInvpqUVnuGctP8zqiOe+nGTTfKiAy+IwMH18aVn1
K1lEW5JOKkyGAJjxeZa36TAdc4qiB2oDAAyw8S8o8TjexlxrEGyAg/cupYoEMBLJ
fgipnBM17Zi2nIv1Dqhq7NhRJaFdvytUahO7rlkH4deQJ+yn0Sodbu65UHNJQ9DA
EVpUTKsa/0M/oPIxAn3g1CduD0g+wMFaG52xhhLgK+6vnq3PC5IKpQwWHRF5eDgZ
Z9SiFV3jhitEgbBZb6rUF/J1rrTcZPEH8sWFpIBYk9kSfdv4PQiXFs110uqmXZok
vDsFK9zTd0EBaTXjMSctiQBGc2gOY4kPSdntuZaf+gi3kOTnEzaqBkgoWi3rVtNY
ur2tXG3ciC35PKg1QKMBYeVPXfhtUXQLoD6HdGs/CfG85qycvW3mRDz0afbJETem
xhn1
-----END CERTIFICATE REQUEST-----

EOF

sudo bash -c "cat > /etc/filebeat/augeosai.com-ca.crt" << EOF
-----BEGIN CERTIFICATE-----
MIIESjCCAzKgAwIBAgIJAKnthyAOrynDMA0GCSqGSIb3DQEBCwUAMIGyMQswCQYD
VQQGEwJVUzELMAkGA1UECAwCQ0ExEjAQBgNVBAcMCVNhbiBEaWVnbzEWMBQGA1UE
CgwNRGV0ZXhpYW4gSW5jLjEsMCoGA1UECwwjRGV0ZXhpYW4gSW5jLiBDZXJ0aWZp
Y2F0ZSBBdXRob3JpdHkxGjAYBgNVBAMMEWxvZ3MuZGV0ZXhpYW4uY29tMSAwHgYJ
KoZIhvcNAQkBFhFpbmZvQGRldGV4aWFuLmNvbTAeFw0xNzExMDcyMzI1NDBaFw0y
NzExMDUyMzI1NDBaMIGyMQswCQYDVQQGEwJVUzELMAkGA1UECAwCQ0ExEjAQBgNV
BAcMCVNhbiBEaWVnbzEWMBQGA1UECgwNRGV0ZXhpYW4gSW5jLjEsMCoGA1UECwwj
RGV0ZXhpYW4gSW5jLiBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkxGjAYBgNVBAMMEWxv
Z3MuZGV0ZXhpYW4uY29tMSAwHgYJKoZIhvcNAQkBFhFpbmZvQGRldGV4aWFuLmNv
bTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKseaA+FhDAeVTjvMDlG
ho2MlrZoOPpl0rosDiKu0qt+2/BpxYuQRRAp8E8Hb8yCrM/AX0eBQFDbXd917aKk
rk2pBnHTIeETDtiB1w4IDIfnKrX1Ox9nifHu3SyQNJwL3A7PnWE/H/ilek4RIW2U
EAUOybltQvc//ijLDxMNFL6QpV4tzgsxRU3W/Dtrco34jHIPQwl1imdoSKiU6NsB
kii65ccXcQL85T8sbH3X5OwGW+gQ2KYimTeji2grsvUqrdtWPU24QxTZ0jLF5LK3
ayWgxZkm24lehGrVzGXc3lAhlZ0mvdaDW7RRcG45UdyiaFcZ/nhcHyTdELnvw+Pm
WwkCAwEAAaNhMF8wHQYDVR0OBBYEFB2dX5hSkxIJUV/7Fq5nc65+qn6hMB8GA1Ud
IwQYMBaAFB2dX5hSkxIJUV/7Fq5nc65+qn6hMAwGA1UdEwQFMAMBAf8wDwYDVR0R
BAgwBocECgAKFjANBgkqhkiG9w0BAQsFAAOCAQEAmPWFe8Vu+uig8wA4WOPdClu4
BQ0rawPFSya0nTU6XKiDJ3t0Uvmwgh9YMisPHkhScmBWxByoLXl55WQJ4KF7pH1P
/6/yP0gJqi9pv7kMghk5aX2Z+QmVlNlkNNZbgnT7MGJXtyUbVfPHrDZKfcoZ4uY/
VimC16lDd06Zd3zwpLPu4wwqdUkKqBUXRlsMs/0lCHmSYP8BsvdrBVva1pZcOzId
T1hUb0U6yZgK3HMPAKMPhJGyZ3hKRmFBZtxk2/4oZzasPipZjP4UXyjjRA4VZAwm
WuZV7HXpbQa1IS4O1LRb56NIxFDgaJ5sCKO6Dcdqd+w6Tzyx+Xa7js94RkUqVQ==
-----END CERTIFICATE-----

EOF

# Launch filebeat
echo "Installing agent"
sudo service filebeat start
sudo systemctl enable filebeat


echo "Done, this system is now being monitored by Detexian."
