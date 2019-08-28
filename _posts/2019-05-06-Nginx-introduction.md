---
layout: post
title: Understanding NGINX
excerpt_separator: <!--more-->
---

## Introduction

nginx is an alternative to webservers like Apache HTTP server. It was created to takle the _C10K_ problem - 10,000 concurrent connections.

<!--more-->

Use cases:

- High performance webserver
- Reverse proxy
  - SSL/TLS termination
  - Content caching and compression
- Loadbalancer

### Apache vs Nginx

#### Apache

- Directive based configuration language
  - Blocks of configuration looks similar to XML tags
- Multiple processing method
  - Pre-fork method
    - Multi-process server architecture
    - Do not use threads
  - Worker method
    - Multi-thread/Multi-process server architecture
    - Thread enables less resource consumption than process based architecture
    - A pool of spare threads are on standby to server incoming requests.
  - Event method
    - Similar to worker method but preferred for keep-alive connections
- Support third party modules
  - Dynamic - no need to compile when new modules are integrated
- Slow for serving static files
- Concept of .htaccess files for directory localized configuration
  - instead of global config, enforce configuration on a sub-directory

#### Nginx

- Directive based configuration language
  - Keyword and it has some arguments.
  - Blocks of configuration use curly braces.
- One processing method
  - Handle concurrent requests
  - Worker process model - use threads when an event triggers it.
  - Asynchronous - helps in concurrency.
- Support third party modules
  - Dynamic - no need to compile when new modules are integrated
- Faster for serving static files
- No concept equivalent to .htaccess files
- Lightweight
  - works fine on lower end hardware

### Installation

Follow the official documentation: [here](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/)

I would recommend to install from the `Official NGINX Repository` by adding repository to your sources. This way we will get the latest nginx package.

Automatically start nginx when the system boots:
```bash
sudo systemctl start nginx
sudo systemctl enabled nginx
```

## Nginx as Web Server

`/etc/nginx` contains all the configuration files.  
`nginx.conf` main server configuration.  
`conf.d` directory contains config files for virtual hosts  

### Configuration

#### nginx.conf

```bash
vim /etc/nginx/nginx.conf
```

Inside the file we see multiple entries:

```vim
user  nginx;
worker_processes  1;
```
> `user nginx;` -> all the child processes runs as nginx user.  
> `worker_processes` -> number of worker processes you want.  

```vim
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
```
> `pid` is the file you want as identifier the nginx is running.  

```vim
events {
    worker_connections  1024;
}
```
>`events` context is required. If removed, nginx won't run (MANDATORY).  
`worker_connections` -> every worker process can have specified number of clients in it.  

```vim
http {
    include       /etc/nginx/mime.types;
```
`http` specifies configuration for http handiling of nginx.  
> `include`  break the configurations in separate chunks. Here, all the mime type definations are present in the dir and it tells nginx what context type it should return. Try reading `mime.types` file.  

```vim
    default_type  application/octet-stream;
```
> `default_type` tells if something is not defined in mime.types it returns the default type.  

```vim
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
```
> When someone access our server the logs are put in `access_log` in `log_format` format. Everything with `$` is a variable.  

```vim
    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;
```
> `sendfile` will allow to use sendfile system call to deliver content, improve performance.  

```vim
    include /etc/nginx/conf.d/*.conf;
}
```
> This allows us to break up all virtual host connections into separate files.

#### default.conf

If `default.conf` doesn't exist, you won't be able to connect to the nginx webserver even if the service is running.

Create `default.conf` file and put the below lines.
```bash
vim /etc/nginx/conf.d/default.conf
```

```vim
server {
        listen 80 default_server;
        server_name _;
        root /usr/share/nginx/html;
}
```

This directs any traffic to the server to `/usr/share/nginx/html/index.html` page.

> `server_name` has a '`_`' after it. This represents that ANY traffic which does not specifies the virtual host will be redirected to default server page.

Let's create a virtual host for `example.com`

```bash
vim /etc/nginx/conf.d/example.com.conf
```
```vim
server {
        listen 80;
        server_name example.com www.example.com;
        root /var/www/example.com/html;
}
```
Put the index page for example.com as `/var/www/example.com/html/index.html`

Reload the service and try to access example.com

```bash
sudo systemctl reload nginx.service
curl --header "Host: example.com" localhost
```

### Error pages

```bash
curl localhost/test.html
```

This will result in nginx default 404 page. We can customize these pages.
We can also refer to [Official Documentation](https://nginx.org/en/docs/http/ngx_http_core_module.html#error_page) for help.

#### default.conf

```vim
server {
        listen 80 default_server;
        server_name _;
        root /usr/share/nginx/html;

        error_page 404 /404.html;
}
```
> `error_page 404 /404.html;` will enable a custom 404 page located at `/usr/share/nginx/html/404.html`

Just add the page contents and reload the nginx service.

### Access control

The `location` will give us power of enforce access control on a specific page or a number of pages using regex. 

[Docs](https://nginx.org/en/docs/http/ngx_http_core_module.html#location) instructs to put the following lines in `/etc/nginx/conf.d/default.conf`

```vim
location {

}
```

The contents of the block can be found [here](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html)

```vim
location = /admin.html {
        auth_basic "Login Required";
        auth_basic_user_file /etc/nginx/.htpasswd;
}
```

Install `htpasswd` utility to generate `.htpasswd` file for `admin` user or any user.

```bash
sudo apt-get install -y apache2-utils
sudo htpasswd -c /etc/nginx/.htpasswd admin
```
> `output:`  
> Adding password for user admin  

Create `admin.html`  
```bash
sudo echo "<h1> Admin Page <h2>" > /usr/share/nginx/html/admin.html
```

Check if all the configurations are correct:
```bash
sudo nginx -t
```
> `output:`  
>sudo nginx -t  
>nginx: the configuration file /etc/nginx/nginx.conf syntax is ok  
>nginx: configuration file /etc/nginx/nginx.conf test is successful  

Use `curl` to confirm authentication.
```bash
curl localhost/admin.html
```
> This should result in `401 Error` page.  

```bash
curl -u admin:password localhost/admin.html
```
> You must have access to the `admin.html` page.

Now `default.conf` looks like this:
```vim
server {
        listen 80 default_server;
        server_name _;
        root /usr/share/nginx/html;

        location = /admin.html {
                auth_basic "Login Required";
                auth_basic_user_file /etc/nginx/.htpasswd;
        }


        error_page 404 /404.html;
        error_page 500 501 502 503 504 /50x.html;
}
```

### Basic NGINX Security

#### Self-signed certificates

