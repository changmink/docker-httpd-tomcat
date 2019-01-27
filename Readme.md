# HTTPD - TOMCAT을 위한 Docker Setting

### 첫 실행
```
mvn clean war:war
docker build -f dockerfile -t httpd_tomcat .
docker run -p 8080:8080 -p 80:80 --name httpd_tomcat -it httpd_tomcat

```
### 커밋하기
```$xslt
docker commit httpd_tomcat httpd_tomcat
```

### 커밋 이후 실행(파일만 바뀜)
```
mvn clean war:war
docker build -f dockerfile2 -t httpd_tomcat .
docker run -p 8080:8080 -p 80:80 --name httpd_tomcat -it httpd_tomcat
```