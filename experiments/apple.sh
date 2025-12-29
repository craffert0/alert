#!/opt/homebrew/bin/bash

TEAM_ID=65BH4M439S
TOKEN_KEY_FILE_NAME=~/Scratch/AuthKey_NK5PK5BWL5.p8
AUTH_KEY_ID=NK5PK5BWL5
TOPIC=net.rafferty.colin.eBirdAlert

DEVICE_TOKEN=80ec9e763c9bcc6595de47c453707b1e3646447f6aa8dd192c21ada14d4b356c1a2cc8f0ea8f4592d6a108fac58d5c10f58362d029a66cb1a164aa17f88a9c3439359e2d23dd29bdffd42c751fe18847
APNS_HOST_NAME=api.sandbox.push.apple.com

JWT_ISSUE_TIME=$(date +%s)
JWT_HEADER=$(printf '{ "alg": "ES256", "kid": "%s" }' "${AUTH_KEY_ID}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
JWT_CLAIMS=$(printf '{ "iss": "%s", "iat": %d }' "${TEAM_ID}" "${JWT_ISSUE_TIME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
JWT_HEADER_CLAIMS="${JWT_HEADER}.${JWT_CLAIMS}"
JWT_SIGNED_HEADER_CLAIMS=$(printf "${JWT_HEADER_CLAIMS}" | openssl dgst -binary -sha256 -sign "${TOKEN_KEY_FILE_NAME}" | openssl base64 -e -A | tr -- '+/' '-_' | tr -d =)
AUTHENTICATION_TOKEN="${JWT_HEADER}.${JWT_CLAIMS}.${JWT_SIGNED_HEADER_CLAIMS}"

read -r -d '' payload <<-'EOF'
{
   "aps": {
      "badge": 2,
      "category": "mycategory",
      "alert": {
         "title": "whoa birdie!",
         "subtitle": "my subtitle",
         "body": "Black & White"
      }
   },
   "custom": {
      "mykey": "myvalue"
   }
}
EOF

echo $AUTHENTICATION_TOKEN

exec curl -D /dev/tty \
   --header "apns-topic: $TOPIC" \
   --header "apns-push-type: alert" \
   --header "authorization: bearer $AUTHENTICATION_TOKEN" \
   --data "$payload" \
   https://${APNS_HOST_NAME}/3/device/${DEVICE_TOKEN}
