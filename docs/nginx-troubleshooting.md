# Nginx Troubleshooting

## 404 Not Found
- Resource does not exist
- Check access.log

## 403 Forbidden
- Permission issue
- Check file ownership and permissions

## 502 Bad Gateway
- Backend service is down or unreachable
- Common with Nginx + Tomcat / PHP-FPM
- Check error.log
