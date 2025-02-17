FROM centos:latest
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum install httpd -y
RUN sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
WORKDIR /var/www/html
COPY index.html .
EXPOSE 8080
WORKDIR /var
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]